%%
clc
close all
clear

%% orignal signal and data down sample
select_variance_or_fft_value = 1; %0: variance  1: fft_value

fs=100;
package_len=100;
select_idx = 1;
clr_radius = 1;
max_num = 4;

Fs_inter=1/6;
Ts_inter=6;

overlap_len=3;

time_wind_len=1;
warning_acc_threshold = 3;

warning_time_one = 5*60;

if select_variance_or_fft_value == 1
    threshold_acc_variance = 5;
    threshold_freq = 15;
else
    threshold_acc_variance = 0.05;
    threshold_freq = 20;
end


%%
%2018_08_10 data
data_2=load('data_orignal_sample/Record_2_pl.txt');

if select_idx == 1
    data_org=data_2;
end

data_idx=data_org(:,1);
factor=1;
data_acc_x=data_org(:,2)*factor;
data_acc_y=data_org(:,3)*factor;
data_acc_z=data_org(:,4)*factor;
data_len=length(data_idx);
data_x=(0:1/fs:(data_len-1)/fs)';

figure(1)
subplot(4,1,1)
plot(data_x/60, data_idx);
title('采集样本的序号与时间曲线');
xlabel('时间t/min');
ylabel('采样样本的序号值');

subplot(4,1,2)
plot(data_x/60, data_acc_x);
title('采集样本的x轴加速度与重力加速度g的比值与时间曲线');
xlabel('时间t/min');
ylabel('x轴加速度比例');

subplot(4,1,3)
plot(data_x/60, data_acc_y);
title('采集样本的y轴加速度与重力加速度g的比值与时间曲线');
xlabel('时间t/min');
ylabel('y轴加速度比例');


subplot(4,1,4)
plot(data_x, data_acc_z);
title('采集样本的z轴加速度与重力加速度g的比值与时间曲线');
xlabel('时间t/min');
ylabel('z轴加速度比例');


%%

%三轴加速方差计算
package_number=floor(data_len/package_len);
variance_t_sec=(0:1:package_number-1)';
variance_t_min = variance_t_sec/60;
variance_x=zeros(package_number,1);
variance_y=zeros(package_number,1);
variance_z=zeros(package_number,1);
fmax_max  =zeros(package_number,max_num*2);


for j=1:package_number
    signal_x=data_acc_x((j-1)*package_len+1:j*package_len);
    signal_y=data_acc_y((j-1)*package_len+1:j*package_len);
    signal_z=data_acc_z((j-1)*package_len+1:j*package_len);
    variance_x(j)=var(signal_x);
    variance_y(j)=var(signal_y);
    variance_z(j)=var(signal_z);
    
    fft_signal_z_abs=abs(fft(signal_z));
    fft_signal_z_abs(1)=0;
    fmax_max(j,:)=get_max_number(fft_signal_z_abs,package_len,clr_radius,max_num);
end

figure(2)
subplot(3,1,1)
plot(variance_t_min, variance_x);

subplot(3,1,2)
plot(variance_t_min, variance_y);

subplot(3,1,3)
plot(variance_t_min, variance_z);

figure(3)
subplot(4,1,1)
plot(variance_t_min, fmax_max(:,1));
subplot(4,1,2)
plot(variance_t_min, fmax_max(:,3));
subplot(4,1,3)
plot(variance_t_min, fmax_max(:,5));
subplot(4,1,4)
plot(variance_t_min, fmax_max(:,7));

figure(4)
subplot(4,1,1)
plot(variance_t_min, fmax_max(:,2));
subplot(4,1,2)
plot(variance_t_min, fmax_max(:,4));
subplot(4,1,3)
plot(variance_t_min, fmax_max(:,6));
subplot(4,1,4)
plot(variance_t_min, fmax_max(:,8));

%%

variance_xyz = variance_x + variance_y + variance_z;
variance_xyz_sat=saturation_max_data(variance_xyz,package_number,0.5);

fx_max=zeros(package_number,2);

for i=1:package_number
    
    [fx_max(i,1),fx_idx] = max([fmax_max(i,1),fmax_max(i,3),fmax_max(i,5),fmax_max(i,7)]);
    fx_max(i,2)=fmax_max(i,2)+fmax_max(i,4)+fmax_max(i,6)+fmax_max(i,8);
    
end

figure(5)
subplot(2,1,1)
plot(variance_t_min, fx_max(:,1));

subplot(2,1,2)
plot(variance_t_min, fx_max(:,2));


random_array=random('Poisson',1:Ts_inter,1,Ts_inter);
first_phase=mod(random_array(Ts_inter),Ts_inter) + 1;
data_num_downsample=floor(package_number/Ts_inter);

time_downsample=zeros(data_num_downsample,1);
data_downsample=zeros(data_num_downsample,1);
freq_downsample=zeros(data_num_downsample,1);

for i=1:data_num_downsample
    sample_idx=first_phase + (i-1)*Ts_inter;
    time_downsample(i) = variance_t_min(sample_idx);
    if select_variance_or_fft_value == 1
        data_downsample(i) = fx_max(sample_idx,2);
    else
        data_downsample(i) = variance_xyz_sat(sample_idx);
    end
    freq_downsample(i) = fx_max(sample_idx,1);
end

figure(6)
subplot(2,1,1)
plot(time_downsample, data_downsample);

subplot(2,1,2)
plot(time_downsample, freq_downsample);

%% 判别门限的设定
% 三轴加速度方差融合门限：threshold_acc_variance -> 0.1
% 频率门限：融合5次的均值小于等于 threshold_freq -> 15~20
% 4次频率波动： 3*6=18s

freq_downsample_mean = overlap_mean_cal(freq_downsample,data_num_downsample,overlap_len);
% freq_downsample_mean = freq_downsample;

figure(7)
subplot(3,1,1)
plot(time_downsample, data_downsample);
title('三轴加速度方差和与时间曲线');
xlabel('时间t/min');
ylabel('三轴加速度方差和');
if select_variance_or_fft_value == 1
    axis([0 48.5 0 15])
else
    axis([0 48.5 0 0.05])
end

subplot(3,1,2)
plot(time_downsample, freq_downsample_mean);
title('最大频率的24s平均值与时间曲线');
xlabel('时间t/min');
ylabel('最大频率的24s平均值');
axis([0 48.5 0 55])

warning_dismantle=zeros(data_num_downsample,1);

for i=1:data_num_downsample
    if (data_downsample(i) >= threshold_acc_variance) && (freq_downsample_mean(i) <= threshold_freq) 
        warning_dismantle(i) = 1;
    end
end

subplot(3,1,3)
plot(time_downsample, warning_dismantle);
title('拆除报警的状态与时间曲线');
xlabel('时间t/min');
ylabel('拆除报警的状态');
axis([0 48.5 -0.5 1.5]);

%% 服务端逻辑

%1min time window
%if warning_dismantle enable, open 1min time window and accumulate warning flag value

data_num_wind=time_wind_len/Fs_inter;
warning_time_one_data_num = warning_time_one*Fs_inter;


warning_sum = zeros(data_num_downsample - data_num_wind + 1,1);
warning_flag = zeros(data_num_downsample - data_num_wind + 1,1);
warning_last = zeros(data_num_downsample - data_num_wind + 1,1);

i=1;

while(i <= data_num_downsample - data_num_wind + 1)
    if warning_dismantle(i) == 1
        for j=0:data_num_wind-1
            warning_sum(i) = warning_sum(i) + warning_dismantle(i+j);
        end
        if warning_sum(i) >= warning_acc_threshold
            warning_flag(i) = 1;
        end  
        i = i + data_num_wind - 1;
    else
        i = i + 1;
    end
end

i=1;

while(i <= data_num_downsample - data_num_wind + 1)
    if warning_flag(i) == 1
        warning_last(i) = 1;
%         for j=0:warning_time_one_data_num-1
%             warning_last(i+j) = 1;
%         end
        i = i + warning_time_one_data_num - 1;
    else
        i = i + 1;
    end
end


figure(8)
subplot(4,1,1)
plot(time_downsample, warning_dismantle);
subplot(4,1,2)
plot(time_downsample(data_num_wind:data_num_downsample), warning_sum);
subplot(4,1,3)
plot(time_downsample(data_num_wind:data_num_downsample), warning_flag);
subplot(4,1,4)
plot(time_downsample(data_num_wind:data_num_downsample), warning_last);










