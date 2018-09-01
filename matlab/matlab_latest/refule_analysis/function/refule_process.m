clc;
clear;
close all;
%%
fs_org=5;

data_20180730=load('原始采集数据\油位传感器现场测试数据_20180730.txt');
data_20180801=load('原始采集数据\油位传感器现场测试数据_20180801.txt');
data_20180806=load('原始采集数据\加磁铁固定数据_20180806.txt');
len_1=length(data_20180730);
len_2=length(data_20180801);
len_3=length(data_20180806);
t1=0:1/fs_org:(len_1-1)/fs_org;
t2=0:1/fs_org:(len_2-1)/fs_org;
t3=0:1/fs_org:(len_3-1)/fs_org;

figure(1)
subplot(3,1,1);
plot(t1',data_20180730);
title('20180730油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值')

subplot(3,1,2);
plot(t2',data_20180801);
title('20180801油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值')

subplot(3,1,3);
plot(t3',data_20180806);
title('20180806油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');
% axis([0 8.3e4 1000 2000]);

%肉眼观察： 
% 20180730 曲线包络合理
% 20180801 曲线包络1.4e5s之后不再合理

%曲线合理度时间段选取：
% 20180730 -> [0, 2.255e5]s 
% 20180801 -> [0, 1.415e5]s 

%%
%信号处理方案
%参数选取：fs=1Hz, 1min(60)计算一次油量均指与方差

%嵌入式处理:
%step1: 计算1min油量液压值均值，方差
%step2: 根据方差值设置幅度阈值门限判断机械的状态 0:静止 1：发动机工作 2：加油
%step3: 根据机械的状态对油量液压值均值作alpha滤波
%step4: 将step2机械状态(2bit)与step3实时油量液压值（8bit）上传至服务器
%服务器处理:
%step5: 根据step3状态数据对实时油量液压值进行分段曲线拟合（最小方差直线拟合）
%step6: 对于分段拟合后的不连续点作插值或者滤波处理

%%
%step1: 信号抽取，均值计算，方差计算
first_start_sample_random_array = random('Poisson',1:3,1,3);  
%use to provide random data for first sample postion;
first_start_index = mod(first_start_sample_random_array(2)+1,5) + 1;  
%use to adjust first sample position to cover sample error
t1_end=2.255e5; t2_end=1.415e5;t3_end=8.3e4;
%曲线合理度时间段选取：
% 20180730 -> [0, 2.255e5]s 
% 20180801 -> [0, 1.415e5]s 

%选取20180730的采样数据
data_sel=data_20180730;
t_end_sel=t1_end;

% %选取20180801的采样数据
% data_sel=data_20180801;
% t_end_sel=t2_end;

% %选取20180806的采样数据
% data_sel=data_20180806;
% t_end_sel=t3_end;

%信号抽取计算抽取的步长与整个信号的长度
fs=1/60; %信号抽取频率
fs_step=fs_org/fs; %信号抽取步长
data_num_fs=floor(t_end_sel*fs); %信号抽取后信号的长度
data_down_sample=zeros(data_num_fs,1);%抽取信号的定义

%抽取信号的时间与抽取油压值计算
t_x_down_sample=0:1/fs:(data_num_fs-1)/fs;
for i=1:data_num_fs
    j=(i-1)*fs_step + first_start_index;
    data_down_sample(i)=data_sel(j);
end

% fs_mean=1/60; %计算均值的频率 1min
% N_fs_mean=(1/fs_mean)/(1/fs);
% number_mean=floor(t_end_sel*fs_mean); %均值的数量
% data_mean=zeros(number_mean,1); %均值信号的定义
% data_variance=zeros(number_mean,1); %方差信号的定义
% 
% %均值信号的时间与压值计算
% t_x_data_mean=0:1/fs_mean/60:(number_mean-1)/fs_mean/60; %分钟数
% for i=1:number_mean
%     refule_variance_once=0;
%     ds_idx=1+(i-1)*N_fs_mean;
%     de_idx=i*N_fs_mean;
%     data_fetch_mean_once=data_down_sample(ds_idx:de_idx);
%     refule_mean_once=mean(data_fetch_mean_once);
%     for j=1:N_fs_mean
%         refule_variance_once = refule_variance_once + (data_fetch_mean_once(j)-refule_mean_once)*(data_fetch_mean_once(j)-refule_mean_once);
%     end
%     data_mean(i)=refule_mean_once;
%     data_variance(i)=sqrt(refule_variance_once/N_fs_mean);
% end
% 
% 
% figure(2)
% %抽取信号时域波形
% subplot(4,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % %均值信号时域波形
% % subplot(4,1,2);
% % plot(t_x_data_mean,data_mean);
% % title('1min油量液压值均值与时间曲线');
% % xlabel('时间t/min');
% % ylabel('油量液压值');
% % axis([0 3760 1000 2200]);
% 
% %均值信号时域波形
% subplot(4,1,3);
% plot(t_x_data_mean,data_variance);
% % title('1min油量液压值标准差与时间曲线');
% % xlabel('时间t/min');
% % ylabel('油量液压值');
% % axis([0 3760 0 60]);
% hold on
% 
% %%
% %step2: 方差判断状态 
% %门限设置： 5min算一次均值 静止(0):[0,5]  运动(1):[5:35]-> 20  加油(2):[45:55] -> 50
% %发动机正常工作范围：[5-25] [10-35] => [5-35] 均值大致靠近[15-25]
% %正常工作的极大值点：47.5  偶然出现单个
% %加油范围：[46,53] [52,56] => [45,55] -> 50 5min中油量差值门限大于400
% %判断加油与工作区别： 加油：方差门限>=45 方差 5min均值 > 29  工作：方差门限均值 > 5 禁止：others 
% 
% %计算： in: 方差  mid: 方差 + 方差 5min 均值（overlap: 4） out: 工作状态
% %函数： 计算5min overlap 均值计算函数
% %in: data_variance
% %mid: data_variance_mean
% %out： machine_status
% 
% fs_variance_mean=1/60/5; %方差均值的频率
% number_overlap=fs_mean/fs_variance_mean; %方差均值的点数
% data_variance_mean=overlap_mean_cal(data_variance,number_overlap);%方差均值计算
% machine_status=zeros(number_mean,1); %machine_status defination
% 
% plot(t_x_data_mean,data_variance_mean,'r')
% title('1min油量液压值标准差与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 0 60]);
% 
% %判决门限定义
% refule_variance_limit = 50;
% refule_variance_mean_limit = 28;
% work_variance_mean_limit = 3.5;
% 
% 
% %machine_status cal
% for i=1:number_mean
%     if (data_variance(i) >= refule_variance_limit) && (data_variance_mean(i) > refule_variance_mean_limit)
%         machine_status(i) = 2;
%     elseif data_variance_mean(i) >= work_variance_mean_limit
%         machine_status(i) = 1;
%     else
%         machine_status(i) = 0;
%     end
% end
% 
% subplot(4,1,4);
% plot(t_x_data_mean,machine_status,'r')
% title('1min机械工作状态与时间曲线');
% xlabel('时间t/min');
% ylabel('工作状态');
% axis([0 3760 -0.5 2.5]);
% %%
% %step3: 根据机械的状态对油量液压值均值作alpha滤波
% 
% %静止： alpha = 0.25
% %工作+加油： alpha = 0.5
% %加油： data_mean(i)
% %工作： 1/6 data_mean(i)+ 1/3 data_mean(i-1) + 1/3 data_mean(i-2) + 1/6 data(i-2)
% alpha0=1/8;
% alpha1=3/8;
% data_mean_alpha=zeros(number_mean,1);
% 
for i=1:number_mean
    if (i <= 3) || (machine_status(i) == 2) || (machine_status(i-1) == 2) ||  (machine_status(i-2) == 2)
        data_mean_alpha(i) = data_mean(i);
    else
%         if machine_status(i) == 2
%             data_mean_alpha(i) = data_mean(i) * alpha0 + data_mean(i-1) * (1 - alpha0);
%         elseif machine_status(i) == 1
%             data_mean_alpha(i) = data_mean(i) * alpha1 + data_mean(i-1) * (1 - alpha1);
%         elseif machine_status(i) == 2
%             data_mean_alpha(i) = data_mean(i) * alpha2 + data_mean(i-1) * (1 - alpha2);
%         end
        data_mean_alpha(i) = alpha0 * (data_mean(i) + data_mean(i-3)) + alpha1 * (data_mean(i-1) + data_mean(i-2));
    end 
end
% 
% % 均值信号时域波形
% subplot(4,1,2);
% plot(t_x_data_mean,data_mean);
% hold on
% plot(t_x_data_mean,data_mean_alpha,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% %%
% %step4: 将step2机械状态(2bit)与step3实时油量液压值（8bit）上传至服务器
% %产生一个（number_mean * 2）数组
% data_info=[data_mean_alpha,machine_status];
% upload_refule=data_info(:,1);
% upload_status=data_info(:,2);
% 
% %%
% %服务端处理
% %step5: 根据step3状态数据对实时油量液压值进行分段曲线拟合（最小方差直线拟合）
% %step6: 对于分段拟合后的不连续点作插值或者滤波处理
% 
% %机械状态处理： 
% %a. 加油状态延时2min   
% %b. 非加油状态持续时间小于5min的处理
% 
% %a: in: upload_status (number_mean) out: status_pre_pro
% status_pre_cl_shift_1=circshift(upload_status,-1); %循环左移一个数据
% status_pre_cr_shift_1=circshift(upload_status,1);  %循环右移一个数据
% status_pre_pro=zeros(number_mean,1);
% 
% for i=1:number_mean
%     if  (upload_status(i) == 2) || (status_pre_cl_shift_1(i) == 2) || (status_pre_cr_shift_1(i) == 2)
%         status_pre_pro(i) = 2;
%     else
%         status_pre_pro(i) = upload_status(i);
%     end
% end
% 
% %b: in: status_pre_pro (number_mean)  out: status_post_pro
% 
% %对曲线状态分段统计：段总数，每段起点，每段长度
% [status_piece,status_start,status_len]=segmentation_cal(status_pre_pro,number_mean);
% 
% %祛除非加油状态中超短的时间段： a. 当前持续时间小于5min,前一个状态持续时间大于15min  b当前持续时间小于2min,前后两个状态大于等于5min
% threshold_a_unstable=5;
% threshold_a_stable=15;
% threshold_b_unstable=2;
% threshold_b_stable=5;
% [status_mid_pro]=delete_unstable_status_cal(status_pre_pro,status_piece,status_start,status_len,threshold_a_unstable,threshold_a_stable,threshold_b_unstable,threshold_b_stable);
% 
% %祛除非加油状态中较短的时间段： （ 曲线拟合的准备）
% %c. 工作（>=30min）,休息（< 10min）,工作（>=30min）中途的停顿会引起信号的抬高，休息->工作  
% %d. 休息（>=30min）,工作（< 10min）,休息（>=30min）中途的工作会引起信号的抖动，工作->休息 
% threshold_prepare_match_curve_min=10;
% threshold_prepare_match_curve_max=30;
% threshold_prepare_match_curve_status=2;
% 
% [status_piece_mid,status_start_mid,status_len_mid]=segmentation_cal(status_mid_pro,number_mean);
% [status_normal_pro]=delete_short_unstable_status_cal(status_mid_pro,status_piece_mid,status_start_mid,status_len_mid,threshold_prepare_match_curve_min,threshold_prepare_match_curve_max,threshold_prepare_match_curve_status);
% 
% 
% %对曲线状态二次分段统计：段总数，每段起点，每段长度
% [status_piece_post,status_start_post,status_len_post]=segmentation_cal(status_normal_pro,number_mean);
% 
% figure(3)
% subplot(3,1,1)
% plot(t_x_data_mean,machine_status,'b');
% title('原始的机械工作状态与时间曲线');
% xlabel('时间t/min');
% ylabel('工作状态');
% axis([0 3760 -0.5 2.5]);
% 
% subplot(3,1,2)
% plot(t_x_data_mean,status_pre_pro,'r');
% title('预处理的机械工作状态与时间曲线');
% xlabel('时间t/min');
% ylabel('工作状态');
% axis([0 3760 -0.5 2.5]);
% 
% subplot(3,1,3)
% plot(t_x_data_mean,status_normal_pro,'r');
% title('后处理的机械工作状态与时间曲线');
% xlabel('时间t/min');
% ylabel('工作状态');
% axis([0 3760 -0.5 2.5]);
% 
% figure(4)
% %抽取信号时域波形
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% subplot(3,1,3)
% plot(t_x_data_mean,status_normal_pro,'r');
% title('后处理的机械工作状态与时间曲线');
% xlabel('时间t/min');
% ylabel('工作状态');
% axis([0 3760 -0.5 2.5]);
% 
%处理加油前20分钟不稳定状态：(加油引起的负向脉冲)
%方差判断 前[-20 -10]均值 前[-10,0]是否修正
%in: [data_mean_alpha,status_normal_pro,number_mean] 
%substep1: out: flag_start_pos_array,flag_stop_pos_array, flag_times
flag_status=2;
flag_times=0;
flag_start_pos_array=zeros(number_mean,1);
flag_stop_pos_array=zeros(number_mean,1);

for i=2:number_mean-1
    if (status_normal_pro(i) == flag_status) && (status_normal_pro(i-1) ~= flag_status)
        flag_times = flag_times + 1;
        flag_start_pos_array(flag_times)=i;
    end
    if (status_normal_pro(i) == flag_status) && (status_normal_pro(i+1) ~= flag_status)
        flag_stop_pos_array(flag_times)=i;
    end
end

%mean->[-20,-11],variacne->[-10,-1]，方差门限设置为2.00
flag_pro_len=10; 
flag_variance_limit=2;
flag_search_time_variance_range=flag_pro_len;
flag_search_time_mean_range=2*flag_pro_len;
flag_pos_mean_variance_array = zeros(flag_times,3);
data_refule_pre_pro=upload_refule;


for i=1:flag_times
    flag_signal_mean=upload_refule(flag_start_pos_array(i)-flag_search_time_mean_range:flag_start_pos_array(i)-flag_search_time_variance_range+1);
    flag_signal_varinace=upload_refule(flag_start_pos_array(i)-flag_search_time_variance_range:flag_start_pos_array(i)-1);
    flag_pos_mean_variance_array(i,1)=flag_start_pos_array(i);
    flag_pos_mean_variance_array(i,2)=mean(flag_signal_mean);
    for j=1:flag_pro_len
        flag_pos_mean_variance_array(i,3)=flag_pos_mean_variance_array(i,3) + (flag_signal_varinace(i)-flag_pos_mean_variance_array(i,2))*(flag_signal_varinace(i)-flag_pos_mean_variance_array(i,2));
    end
    flag_pos_mean_variance_array(i,3) = sqrt(flag_pos_mean_variance_array(i,3)/flag_pro_len);
    
    if flag_pos_mean_variance_array(i,3) > flag_variance_limit
        for j=0:flag_pro_len
            data_refule_pre_pro(flag_pos_mean_variance_array(i,1) - j)=flag_pos_mean_variance_array(i,2);
        end
    end
end
% 
% figure(5)
% %抽取信号时域波形
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,3);
% plot(t_x_data_mean,data_refule_pre_pro,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% %工作（>30min）->静止(>1h): 油量回流以及热涨冷缩导致的液压值的变化
% % [status_piece_post,status_start_post,status_len_post]
% %机械的三种状态
% status_quiet=0;
% status_move=1;
% status_refule=2;
% refule_mid_pro_move_threshold=10;
% refule_mid_pro_quiet_threshold=70;
% refule_mid_pro_quiet_remove_threshold=50;
% 
% data_refule_mid_pro=amend_move_to_quiet_cal(data_refule_pre_pro,status_normal_pro,status_piece_post,status_start_post,status_len_post,refule_mid_pro_quiet_threshold,refule_mid_pro_quiet_remove_threshold,refule_mid_pro_move_threshold,status_quiet,status_move);
% 
% figure(6)
% subplot(2,1,1)
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% subplot(2,1,2)
% plot(t_x_data_mean,data_refule_pre_pro,'b');
% hold on
% plot(t_x_data_mean,data_refule_mid_pro,'r');
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% %曲线拟合
% data_refule_curve_match=data_refule_mid_pro;
% for i=1:status_piece_post
%     if status_normal_pro(status_start_post(i)) ~= status_refule
%         fn_x=t_x_data_mean(status_start_post(i):status_start_post(i) + status_len_post(i) - 1)';
%         fn_y=data_refule_curve_match(status_start_post(i):status_start_post(i) + status_len_post(i) - 1);
%         if status_len_post(i) == 1
%             coe_ab(1) = 0;
%             coe_ab(2) = fn_y(1);
%         else
%             coe_ab = polyfit(fn_x(1: status_len_post(i)), fn_y(1:status_len_post(i)), 1);
% %             if status_normal_pro(status_start_post(i)) == status_move
% %             end
%         end
%         for j=1:status_len_post(i)
%             data_refule_curve_match(status_start_post(i)+j-1) = coe_ab(1)*fn_x(j) + coe_ab(2);
%         end  
%     end
% end
% 
% figure (7)
% %抽取信号时域波形
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'b');
% hold on 
% plot(t_x_data_mean,data_refule_curve_match,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,3);
% plot(t_x_data_mean,upload_status,'b');
% hold on 
% plot(t_x_data_mean,status_normal_pro,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 -0.5 2.5]);
% 
% 
% % 二次曲线曲线扩展：
% % 拟合条件： 状态变化（前后两状态时间长达30min） + 变化节点幅度达10
% 
% %计算满足的突变节点的片段：
% threshold_status_continue_time_range=30;
% threshold_refule_amplitude_vary_range=10;
% threshold_refule_match_time_wind=30;
% data_refule_curve_match_twice=data_refule_curve_match;
% 
% for i=2:status_piece_post
%     if (status_len_post(i) >= threshold_status_continue_time_range) && (status_len_post(i-1) >= threshold_status_continue_time_range) && (abs(data_refule_curve_match(status_start_post(i))-data_refule_curve_match(status_start_post(i)-1)) > threshold_refule_amplitude_vary_range)
%         if status_normal_pro(status_start_post(i)) == status_move
%             extend_directory = 1; %右扩展
%         else
%             extend_directory = 0; %左扩展
%         end
%         if extend_directory ==1 %向右扩展
%             for j=0:threshold_refule_match_time_wind-1
%                 if data_refule_curve_match_twice(status_start_post(i)+j) > data_refule_curve_match_twice(status_start_post(i)-1)
%                     data_refule_curve_match_twice(status_start_post(i)+j)= data_refule_curve_match_twice(status_start_post(i)-1);
%                 end
%             end
%         else %向左扩展
%             for j=0:threshold_refule_match_time_wind-1
%                 if data_refule_curve_match_twice(status_start_post(i)) > data_refule_curve_match_twice(status_start_post(i)-j-1)
%                     data_refule_curve_match_twice(status_start_post(i)-j-1)= data_refule_curve_match_twice(status_start_post(i));
%                 end
%             end
%         end
%     end
% end
% 
% figure (8)
% %抽取信号时域波形
% subplot(2,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(2,1,2);
% plot(t_x_data_mean,data_refule_curve_match,'b');
% hold on 
% plot(t_x_data_mean,data_refule_curve_match_twice,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% figure (9)
% %抽取信号时域波形
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('油量液压值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'b');
% hold on
% plot(t_x_data_mean,data_refule_curve_match_twice,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 1000 2200]);
% 
% % 均值信号时域波形
% subplot(3,1,3);
% plot(t_x_data_mean,upload_status,'b');
% hold on 
% plot(t_x_data_mean,status_normal_pro,'r');
% title('1min油量液压值均值与时间曲线');
% xlabel('时间t/min');
% ylabel('油量液压值');
% axis([0 3760 -0.5 2.5]);



