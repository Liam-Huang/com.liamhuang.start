%%
%clear screen and close images
clc;
clear;
close all;
%% parameter and threshold defination


%orignal sample frequency: 5Hz
fs_org=5; 
%down sample freq: 1/60 Hz
fs_downsample=1/60; 
T_downsample =1/fs_downsample; % 1 min

% 1->20180730, 2->20180801, 3->20180806, 4->20180813
select_data_idx=4;             


cal_len=5; %calcalute mean value length

status_static = 0; 
status_move   = 1;
status_refule = 2;
status_steal  = 3;

%加油
refule_add_mean_threshold = 95; %need adjust
refule_add_var_threshold  = 85; %need adjust

%偷油
cal_len_steal = 5;
refule_steal_mean_acc_threshold = -100;  %need adjust
refule_steal_var_threshold = 50;         %need adjust

%运动
refule_move_var_threshold = 3.0;         %need adjust

%静止
%others except the following condition

%extend add and steal oil state: before and after 1 min
%acc state for static and move 
threshold_acc_state_time_len = 10; % acc time windown len 10min
threshold_acc_state_value = threshold_acc_state_time_len/2 - 1; % acc value great than half of acc time window

%服务端:
%祛除非加油+偷油状态中的非常短暂的状态
% a)	当前状态为非加油状态且持续时间小于等于2min，前后两个工作状态大于等于5min
% b)	当前状态为非加油状态且持续时间小于等于5min, 前一个工作状态大于等于15min
threshold_unstable = 10;
threshold_stable = 20;


%加油前10min的门限设置
flag_pro_len = 10; 
flag_variance_limit = 2;

%工作时间大于10min, 静止时间大于70min分钟，静止的前50min左右用静止的阶段50min之后的均值代替
refule_mid_pro_move_threshold=10;
refule_mid_pro_quiet_threshold=70;
refule_mid_pro_quiet_remove_threshold=50;

curve_match_len_min = 60;

%曲线扩展
threshold_process_static_time_min = 80;
threshold_extend_time_max = 80;
extend_wind_len=0;

%refule add control
threshold_refule_add_len=5;

%refule steal threshold
threshold_refule_steal_wind_len = 5;
threshold_refule_steal_value1   = -80;
threshold_refule_steal_value2   = -200;

% relationship between hydraumatic and height
k_relation = 1/19.5048;
b_relation = -580/19.5048;  

%% orignal signal load and downsample signal

%load four sample datas 
data_20180730=load('原始采集数据\油位传感器现场测试数据_20180730.txt');
data_20180801=load('原始采集数据\油位传感器现场测试数据_20180801.txt');
data_20180806=load('原始采集数据\加磁铁固定数据_20180806.txt');
data_20180813=load('原始采集数据\加磁铁固定数据_20180813.txt');

%get datas lengths
len_1=length(data_20180730);
len_2=length(data_20180801);
len_3=length(data_20180806);
len_4=length(data_20180813);

%generate datas time axis
t1=(0:1/fs_org:(len_1-1)/fs_org)';
t2=(0:1/fs_org:(len_2-1)/fs_org)';
t3=(0:1/fs_org:(len_3-1)/fs_org)';
t4=(0:1/fs_org:(len_4-1)/fs_org)';

%plot orignal signal waveform
figure(1)
subplot(4,1,1);
plot(t1,data_20180730);
title('20180730油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');
subplot(4,1,2);
plot(t2,data_20180801);
title('20180801油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');
subplot(4,1,3);
plot(t3,data_20180806);
title('20180806油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');
subplot(4,1,4);
plot(t4,data_20180813);
title('20180813油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');

%three data available time stage search
% 20180730 -> [0, 2.255e5]s 
% 20180801 -> [0, 1.415e5]s 
% 20180806 -> [0, 8.300e4]s 
% 20180813 -> [0, 2.850e5]s 
t1_end=2.255e5;
t2_end=1.415e5;
t3_end=8.300e4;
t4_end=2.850e5;

%select precoess data from from sample datas
if select_data_idx == 1
    %select 20180730 sample data
    data_sel=data_20180730;
    t_end_sel=t1_end;
elseif select_data_idx == 2
    %select 20180801 sample data
    data_sel=data_20180801;
    t_end_sel=t2_end;
elseif  select_data_idx == 3
    %select 20180806 sample data
    data_sel=data_20180806;
    t_end_sel=t3_end;
elseif  select_data_idx == 4
    %select 20180813 sample data
    data_sel=data_20180813;
    t_end_sel=t4_end;
end

%fetch down sample data from select data
[y_down_sample,x_down_sample,len_down_sample]=down_sample_cal(data_sel,t_end_sel,fs_org,fs_downsample);

%plot down sample data 
figure(2)
plot(x_down_sample,y_down_sample);
title('采样率1min的油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值');

%% 服务端接收的数据 [Ts, OilMass,Fs, Acc_x, Acc_y, Acc_z]
% Now available data: [Ts, OilMass] -> [x_down_sample,y_down_sample,len_down_sample]
% fs_downsample=1/60;

%Emebedded signal process
% 1.	每隔5min计算油量的均值，方差，方差均值，以上变量采用重叠滑窗的方式计算，以及油量2min的变化量。
% 2.	根据均值，方差，方差均值，油量2min的变化量，油量5min的变化量等条件判断出机械状态（静止：0，移动：1， 加油： 2， 偷油： 3）。
% 3.	基于步骤2中得到的机械状态曲线对步骤1中的油量均值进行滤波处理，输出实时的油量曲线。
% 4.	将步骤2中的机械状态曲线，步骤3中的实时油量曲线上传至服务器。

%one: mean, std_var, refule_var_1min 
[y_mean,y_sd,y_varmean]=mean_variance_varmean_cal(y_down_sample,len_down_sample,cal_len);
figure(3)

subplot(4,1,1)
plot(x_down_sample,y_down_sample);
title('采样率1min的油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值');

subplot(4,1,2)
plot(x_down_sample,y_mean);
title('5min的油量液压均值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压均值');

subplot(4,1,3)
plot(x_down_sample,y_varmean);
title('2min的油量液压均值差值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压均值差值');

subplot(4,1,4)
plot(x_down_sample,y_sd);
title('油量液压标准差与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值标准差');

%two: base on mean, std_var, refule_var_1min to get machine status 
% real time machine status curve for add and steal oil : machine_status_pre_pro
% real time oil curve: y_mean
[machine_status_pre_pro]=machine_status_pre_process(len_down_sample,status_static,status_move,status_refule,status_steal,y_sd,y_varmean,refule_add_mean_threshold,refule_add_var_threshold,cal_len_steal,refule_steal_mean_acc_threshold,refule_steal_var_threshold,refule_move_var_threshold);

figure (4)
subplot(4,1,1)
plot(x_down_sample,y_down_sample);
hold on 
plot(x_down_sample,y_mean,'r');  
title('采样率1min的油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值');

subplot(4,1,2)
plot(x_down_sample,y_varmean);
title('2min的油量液压均值差值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压均值差值');

subplot(4,1,3)
plot(x_down_sample,y_sd);
title('油量液压标准差与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值标准差');

subplot(4,1,4)
plot(x_down_sample,machine_status_pre_pro);
title('油量液压标准差与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值标准差');

%four: machine_status and refule_curve 
data_info=[y_mean,machine_status_pre_pro];


%% 服务端处理
% 服务端处理：
% 1.	油量曲线： 日报机械状态曲线   + 日报油量液压值曲线处理
% 2.	加油事件： 加油事件的持续时间 + 加入的油量
% 3.	偷油事件： 服务端裁决
% a)	检测的类型：油箱盖未被打开且静止的偷油情形
% b)	油箱盖打开的影响: 服务端较大概率的触发报警，需要6轴加速度的油箱盖打开检查条件把此次报警mask清除

upload_refule=data_info(:,1);
upload_status=data_info(:,2);

% one: machine_status signal process
% a. extend refule time right and left one minutes
% b. extend steal time right and left one minutes
% c. delete very short time stage
% d. delete short time stage

%a+b: process at same function -> extend_refule_steal_stage
[status_extend,steal_flag]=status_extend_refule_steal_stage(upload_status,len_down_sample,status_refule,status_steal);

status_mid_pro = StatusTimeWindSegmentationProcess(status_extend,threshold_acc_state_time_len,threshold_acc_state_value,status_refule,status_static,status_move);

[status_piece,status_start,status_len]=segmentation_cal(status_mid_pro,len_down_sample);


status_normal_pro=DeleteShortStatus(status_mid_pro,status_piece,status_start,status_len,threshold_unstable,threshold_stable,status_refule,status_steal);
[status_piece_post,status_start_post,status_len_post]=segmentation_cal(status_normal_pro,len_down_sample);

figure(5)

subplot(3,1,1)
plot(x_down_sample,status_extend,'b');
title('服务端收到机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(3,1,2)
plot(x_down_sample,status_mid_pro,'r');
title('服务端收到机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(3,1,3)
plot(x_down_sample,status_normal_pro,'r');
title('服务端收到机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

%c.delete very short time stage
% [status_piece,status_start,status_len]=segmentation_cal(status_extend,len_down_sample);
% [status_mid_pro]=delete_very_short_status_cal(status_extend,status_piece,status_start,status_len,threshold_a_unstable,threshold_a_stable,threshold_b_unstable,threshold_b_stable,status_refule, status_steal);
% 
% [status_piece_mid,status_start_mid,status_len_mid]=segmentation_cal(status_mid_pro,len_down_sample);
% [status_normal_pro]=delete_short_status_cal(status_mid_pro,status_piece_mid,status_start_mid,status_len_mid,threshold_c_unstable,threshold_c_stable,status_refule,status_steal);
% 
% [status_piece_post,status_start_post,status_len_post]=segmentation_cal(status_normal_pro,len_down_sample);
% 
% figure(5)
% 
% subplot(4,1,1)
% plot(x_down_sample,upload_status);
% title('服务端收到机械状态与时间曲线');
% xlabel('时间t/min');
% ylabel('机械状态');

% subplot(4,1,2)
% plot(x_down_sample,status_extend);
% title('扩展后的机械状态与时间曲线');
% xlabel('时间t/min');
% ylabel('机械状态');
% 
% subplot(4,1,3)
% plot(x_down_sample,status_mid_pro);
% title('预处理后的机械状态与时间曲线');
% xlabel('时间t/min');
% ylabel('机械状态');
% 
% subplot(4,1,4)
% plot(x_down_sample,status_normal_pro);
% title('处理后的机械状态与时间曲线');
% xlabel('时间t/min');
% ylabel('机械状态');
% 
%two: daily refule signal process
% a.	加油时间段的前10min左右的负向脉冲处理
% b)	工作时间大于10min, 静止时间大于60min分钟，静止的前40min左右用静止的阶段40min之后的均值代替。
% c.	曲线分段进行一次多项式拟合
% d.	曲线扩展

%a. 加油时间段的前10min左右的负向脉冲处理
[flag_times,flag_start_pos_array]=cal_refule_boundry(status_normal_pro,len_down_sample,status_refule);
[data_refule_pre_pro]=data_before_refule_process(upload_refule,flag_times,flag_start_pos_array,flag_pro_len,flag_variance_limit);


figure(6)
plot(x_down_sample,upload_refule);
hold on 
plot(x_down_sample,data_refule_pre_pro,'r');
title('服务端收到油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

%b. 工作时间大于10min, 静止时间大于60min分钟，静止的前40min左右用静止的阶段40min之后的均值代替
data_refule_mid_pro=amend_move_to_quiet_cal(data_refule_pre_pro,status_normal_pro,status_piece_post,status_start_post,status_len_post,refule_mid_pro_quiet_threshold,refule_mid_pro_quiet_remove_threshold,refule_mid_pro_move_threshold,status_static,status_move);

figure(7)
subplot(2,1,1)
plot(x_down_sample,upload_refule);
hold on 
plot(x_down_sample,data_refule_mid_pro,'r');
title('服务端收到油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(2,1,2)
plot(x_down_sample,status_normal_pro);
title('处理后的机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

%c. 分段曲线拟合
%曲线拟合：拟合区间长度大于90min的时间段

number_ge_match_len = 0;
len_status_flag = zeros(status_piece_post,1);
coe_idx = zeros(status_piece_post,3);

for i=1:status_piece_post
    if ( status_len_post(i) >= curve_match_len_min)
        number_ge_match_len = number_ge_match_len + 1;
        fn_x=x_down_sample(status_start_post(i):status_start_post(i) + status_len_post(i) - 1);
        fn_y=data_refule_mid_pro(status_start_post(i):status_start_post(i) + status_len_post(i) - 1);
        coe_ab = polyfit(fn_x(1: status_len_post(i)), fn_y(1:status_len_post(i)), 1);
        if (status_normal_pro(status_start_post(i)) == status_static) && (abs(coe_ab(1)) > 0.05)
            coe_ab(2) = coe_ab(1) * fn_x(floor(status_len_post(i)/2)) + coe_ab(2);
            coe_ab(1) = 0;
        end
        for j=1:status_len_post(i)
            data_refule_mid_pro(status_start_post(i)+j-1) = coe_ab(1)*fn_x(j) + coe_ab(2);
        end 
        len_status_flag(i) = 1;
        coe_idx(number_ge_match_len,1) = i;
        coe_idx(number_ge_match_len,2) = coe_ab(1);
        coe_idx(number_ge_match_len,3) = coe_ab(2);
    elseif (status_normal_pro(status_start_post(i)) == status_refule) || (status_normal_pro(status_start_post(i)) == status_steal)
        len_status_flag(i) = 2;
    else
        len_status_flag(i) = 0;
    end
end

figure(8)
subplot(2,1,1)
plot(x_down_sample,upload_refule);
hold on 
plot(x_down_sample,data_refule_mid_pro,'r');
title('服务端收到油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(2,1,2)
plot(x_down_sample,status_normal_pro);
title('处理后的机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

% 曲线扩展： 
%condition1: 两段大于90min的线段中不存在加油和偷油状态，两条直线交点为分界点
%condition2: 两段大于90min的线段中存在加油和偷油状态，加油或偷油的起点为第一段线段的分界点



for i = 1 : number_ge_match_len - 1
    sum_len_status_flag = sum(len_status_flag(coe_idx(i,1):coe_idx(i+1,1)));
    if sum_len_status_flag > 2  %condition2
        for j = 1 : coe_idx(i+1,1) - coe_idx(i,1) - 1
            if len_status_flag(coe_idx(i,1)+j) == 2
                break;
            end
        end
        match_start_idx = status_start_post(coe_idx(i,1)) + status_len_post(coe_idx(i,1)) - 1;
        match_end_idx   = status_start_post(coe_idx(i,1)+j) ;
        for k = match_start_idx : match_end_idx
            data_refule_mid_pro(k) = coe_idx(i,2) * x_down_sample(k) + coe_idx(i,3);
        end
    else                        %condition1
        current_start_idx = status_start_post(coe_idx(i,1));
        current_end_idx   = status_start_post(coe_idx(i,1)) + status_len_post(coe_idx(i,1)) - 1;
        next_start_idx = status_start_post(coe_idx(i+1,1));
        next_end_idx   = status_start_post(coe_idx(i+1,1)) + status_len_post(coe_idx(i+1,1)) - 1;
        junction_idx = floor(-(coe_idx(i,3) - coe_idx(i+1,3))/(coe_idx(i,2) - coe_idx(i+1,2)));
        table_idx = [ current_start_idx, current_end_idx, next_start_idx, next_end_idx, junction_idx];
        if (junction_idx > current_start_idx) && (junction_idx <= current_end_idx)
            for k = junction_idx +1 : next_start_idx
                data_refule_mid_pro(k) = coe_idx(i+1,2) * x_down_sample(k) + coe_idx(i+1,3);
            end
        elseif (junction_idx >= next_start_idx) && (junction_idx < next_end_idx)
            for k = current_end_idx : junction_idx
                data_refule_mid_pro(k) = coe_idx(i,2) * x_down_sample(k) + coe_idx(i,3);
            end
        elseif (junction_idx > current_end_idx) && (junction_idx < next_start_idx)
            for k = current_end_idx + 1 : junction_idx
                data_refule_mid_pro(k) = coe_idx(i,2) * x_down_sample(k) + coe_idx(i,3);
            end
            for k = junction_idx + 1 : next_start_idx
                data_refule_mid_pro(k) = coe_idx(i+1,2) * x_down_sample(k) + coe_idx(i+1,3);
            end
%         else
%             coe_k = (data_refule_mid_pro(next_start_idx) - data_refule_mid_pro(current_end_idx))/(x_down_sample(next_start_idx) - x_down_sample(current_end_idx));
%             coe_b = (data_refule_mid_pro(current_end_idx) * x_down_sample(next_start_idx) - data_refule_mid_pro(next_start_idx) * x_down_sample(current_end_idx))/(x_down_sample(next_start_idx) - x_down_sample(current_end_idx));
%             for k = current_end_idx + 1 : next_start_idx - 1
%                 data_refule_mid_pro(k) = coe_k * x_down_sample(k) + coe_b;
%             end
        end
    end
end
data_refule_curve_match = data_refule_mid_pro;

figure(9)
subplot(2,1,1)
plot(x_down_sample,upload_refule);
hold on 
plot(x_down_sample,data_refule_mid_pro,'r');
title('服务端收到油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(2,1,2)
% plot(x_down_sample,data_refule_mid_pro,'r');
plot(x_down_sample,status_normal_pro);
title('处理后的机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');


% close all

figure(10)
subplot(2,1,1)
% plot(x_down_sample,upload_refule);
% hold on 
plot(x_down_sample,data_refule_mid_pro,'r');
title('服务端收到油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(2,1,2)
plot(x_down_sample,status_normal_pro);
title('处理后的机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

% subplot(2,1,2)
% plot(x_down_sample,y_down_sample);
% title('采样率1min的油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
%% 加油量的求取
% status_normal_pro,len_down_sample
refule_times=0;
for i=2:len_down_sample-1
    if (status_normal_pro (i-1) ~= status_refule) && (status_normal_pro(i) == status_refule)
        refule_times=refule_times+1;
    end 
end

refule_table=zeros(refule_times,3);

j=0;
for i=2:len_down_sample-1
    if (status_normal_pro (i-1) ~= status_refule) && (status_normal_pro(i) == status_refule)
        j=j+1;
        refule_table(j,1)=i-1;   
    end
    if (status_normal_pro (i) == status_refule) && (status_normal_pro(i+1) ~= status_refule)
        refule_table(j,2)=i-1;   
    end
end

for i=1:refule_times
    signal_pre=data_refule_curve_match(refule_table(i,1)-threshold_refule_add_len:refule_table(i,1)-1);
    signal_post=data_refule_curve_match(refule_table(i,2)+1:refule_table(i,2) + threshold_refule_add_len);
    refule_table(i,3)=mean(signal_post)-mean(signal_pre);
end

%% 偷油报警处理
warning_flag=zeros(len_down_sample,1);

for i=10:len_down_sample-5
    if steal_flag(i) == 1
        signal_pre=data_refule_curve_match(i-4-threshold_refule_add_len:i-5);
        signal_post=data_refule_curve_match(i+1:i+threshold_refule_add_len);
        mean_value_sub = mean(signal_post)- mean(signal_pre);
        if mean_value_sub < threshold_refule_steal_value2
            warning_flag(i+5)=2;
        elseif mean_value_sub < threshold_refule_steal_value1
            warning_flag(i+5)=1;
        end
    end
end

figure(11)
subplot(2,1,1)
% plot(x_down_sample,upload_refule);
% hold on 
plot(x_down_sample,data_refule_curve_match,'r');
title('服务端收到油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

subplot(2,1,2)
plot(x_down_sample,status_normal_pro);
hold on 
plot(x_down_sample,warning_flag,'r');
title('处理后的机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');


data_refule_height = k_relation  * data_refule_curve_match + b_relation ;
figure(12)
subplot(2,1,1)
plot(x_down_sample,data_refule_height,'r');
title('服务端收到油量高度与时间曲线');
xlabel('时间t/min');
ylabel('油量的高度/cm');

subplot(2,1,2)
plot(x_down_sample,status_normal_pro);
hold on 
plot(x_down_sample,warning_flag,'r');
title('处理后的机械状态与时间曲线');
xlabel('时间t/min');
ylabel('机械状态');

figure(13)
subplot(3,1,1)
plot(x_down_sample,y_down_sample);
title('采样率1min的油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值');

subplot(3,1,2)
plot(x_down_sample,data_refule_curve_match);
title('采样率1min的油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值');

subplot(3,1,3)
plot(x_down_sample,data_refule_height);
title('采样率1min的油量液压值与时间曲线');
xlabel('时间t/min');
ylabel('油量液压值');






