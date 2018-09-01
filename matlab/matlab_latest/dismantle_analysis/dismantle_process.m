%% clear screen
clc
close all
clear

%% paramter defination

% select_idx = 1;        %use to control select orignal data 
select_idx = 1;        %use to control select orignal data 
gravity_acc_factor=9.8;  %9.8/8192

fs=100;                %orignal sample frequenct 
sample_len=256;        %FFT length
Tsample_interval=6;    %sample time interval
package_len=60;        %package time interval
max_num = 4;           %number of fft max data
clr_radius = 1;        %clear radius in fft spectrum

threshold_fft_fx = 15; % freq threshold
threshold_fft_fy = 8 * gravity_acc_factor / sample_len * 2;  % freq amp sum

threshold_warning_acc_sum = 3; % 1 min dismantle accumulate threshold
threshold_warning_time_interval = 10 * 60; % 10 min: time interval between two warning flag

debug_flag = 1;

%% orignal signal 

data_20180809=load('data_orignal_sample/SixAxisSenorSamDat_20180809.txt');
data_20180817=load('data_orignal_sample/SixAxisSenorSamDat_20180817.txt');

if select_idx == 1
    data_org = data_20180809;
elseif select_idx == 2
    data_org = data_20180817; 
end

data_idx  =data_org(:,1);                       %sample data index
data_acc_x=data_org(:,2)*gravity_acc_factor;    %sample axis x acc
data_acc_y=data_org(:,3)*gravity_acc_factor;    %sample axis y acc
data_acc_z=data_org(:,4)*gravity_acc_factor;    %sample axis z acc

data_len = length(data_idx);
data_x=(0:1/fs:(data_len-1)/fs)'/60;


figure(1)
subplot(4,1,1)
plot(data_x, data_idx);
title('采集样本的序号与时间曲线');
xlabel('时间t/min');
ylabel('采样样本的序号值');

subplot(4,1,2)
plot(data_x, data_acc_x);
title('采集样本的x轴加速度与重力加速度g的比值与时间曲线');
xlabel('时间t/min');
ylabel('x轴加速度比例');

subplot(4,1,3)
plot(data_x, data_acc_y);
title('采集样本的y轴加速度与重力加速度g的比值与时间曲线');
xlabel('时间t/min');
ylabel('y轴加速度比例');

subplot(4,1,4)
plot(data_x, data_acc_z);
title('采集样本的z轴加速度与重力加速度g的比值与时间曲线');
xlabel('时间t/min');
ylabel('z轴加速度比例');

%% data down sample to imitate real sample

first_sample_phase_max=Tsample_interval*fs;     %600=6*100
random_array=random('Poisson',1:first_sample_phase_max,1,first_sample_phase_max);
first_phase=mod(random_array(first_sample_phase_max),first_sample_phase_max) + 1; %first random sample data phase
package_infor_number = floor((data_len - first_phase + 1)/(fs*package_len)); %number of package

% package information: 91 = 1(Ts) + (1(sd) + 4(max number) * 2(Freq,Amp)) * 10 (package_len/Tsample_interval)
% sd: (2)  1: (3,4)  2: (5,6)  3:(7,8)  4: (9,10) 
package_piece = package_len/Tsample_interval;                   % 1min/6s = 10
package_infor_len = 1 + (1 + 4 * 2)*package_piece;              % 91
package_infor = zeros(package_infor_number,package_infor_len);



for i = 1 : package_infor_number
    time_idx = first_phase + (i-1) * fs * package_len;
    package_infor(i,1) = data_x(time_idx);
    for j = 1 : package_piece
        dat_start_idx = time_idx + (j-1) * fs * Tsample_interval;
        dat_end_idx =  dat_start_idx + sample_len - 1;
        signal_x=data_acc_x(dat_start_idx:dat_end_idx);
        signal_y=data_acc_y(dat_start_idx:dat_end_idx);
        signal_z=data_acc_z(dat_start_idx:dat_end_idx);
        
        variance_xyz=var(signal_x) + var(signal_y) + var(signal_z);  %standard error
        fft_signal_z_abs=abs(fft(signal_z)) / sample_len * 2;
        fft_signal_z_abs(1)=0;
        
        package_infor(i,9*(j-1)+2)=variance_xyz; %store sd
        package_infor(i,9*(j-1)+3:9*(j-1)+10)=get_max_number(fft_signal_z_abs,package_len,clr_radius,max_num); %store 4 max spectrum   
    end
end

%% 服务器处理
% package_pro_info = [even_Ts, even_fx, even_fy; odd_Ts, odd_fx, odd_fy];
package_pro_info = zeros(2,3);
package_debug_info = zeros(package_infor_number*package_piece,3);
dismantle_status_pre_pro = zeros(package_infor_number*package_piece,2); %[Ts, dismantle_status]
dismantle_status_pre_sum = zeros(package_infor_number,2);               %[Ts, dismantle_status]
dismantle_status_normal_pro = zeros(package_infor_number,2);              %[Ts, dismantle_status]
dismantle_status_post_pro = zeros(package_infor_number,2);
deta_t = Tsample_interval /60;
threshold_warning_num_interval=threshold_warning_time_interval/package_len;

for i = 1 : package_infor_number
    Ts_start = package_infor(i,1);
    dismantle_status_pre_sum(i,1) = Ts_start + (package_piece/2) * deta_t;
    for j = 1 : package_piece/2 
        Tj_start = Ts_start + 2 * (j-1) * deta_t ; 
        %fetch spectrum from package information
        %[even: 3,5,7,9  odd: 12,14,16,18] 
        %[even: 4,6,8,10 odd: 13,15,17,19]
        fx_idx_start = (j-1) * 9 * 2;
        fx_vector_four_even = [package_infor(i,fx_idx_start+3),package_infor(i,fx_idx_start+5),package_infor(i,fx_idx_start+7),package_infor(i,fx_idx_start+9)]; 
        fy_vector_four_even = [package_infor(i,fx_idx_start+4),package_infor(i,fx_idx_start+6),package_infor(i,fx_idx_start+8),package_infor(i,fx_idx_start+10)]; 
        fx_vector_four_odd = [package_infor(i,fx_idx_start+12),package_infor(i,fx_idx_start+14),package_infor(i,fx_idx_start+16),package_infor(i,fx_idx_start+18)];
        fy_vector_four_odd = [package_infor(i,fx_idx_start+13),package_infor(i,fx_idx_start+15),package_infor(i,fx_idx_start+17),package_infor(i,fx_idx_start+19)];
        
        fx_vector_even_odd_max_mean = (max(fx_vector_four_even) + max(fx_vector_four_odd))/2;
        fy_vector_even_sum = sum(fy_vector_four_even);
        fy_vector_odd_sum  = sum(fy_vector_four_odd);
        
        for k = 0 : 1
            idx = k + 1;
            package_pro_info(idx,1) = Tj_start + k * deta_t;
            package_pro_info(idx,2) = fx_vector_even_odd_max_mean;
            if k == 0
                package_pro_info(idx,3) = fy_vector_even_sum;
            else
                package_pro_info(idx,3) = fy_vector_odd_sum;
            end
            
            if (package_pro_info(idx,2) < threshold_fft_fx) && (package_pro_info(idx,3) > threshold_fft_fy )
                dismantle_status = 1;
            else
                dismantle_status = 0;
            end
            
            dismantle_status_pre_sum(i,2) = dismantle_status_pre_sum(i,2) + dismantle_status;
            
            pre_pro_idx = (i-1) * package_piece + (j-1) * 2 + idx;
            
            dismantle_status_pre_pro(pre_pro_idx,1) = package_pro_info(idx,1);
            dismantle_status_pre_pro(pre_pro_idx,2) = dismantle_status;
            
            if debug_flag == 1
                % debug information
                package_debug_info(pre_pro_idx,1) = package_pro_info(idx,1);
                package_debug_info(pre_pro_idx,2) = package_pro_info(idx,2);
                package_debug_info(pre_pro_idx,3) = package_pro_info(idx,3);
            end
        end
        
    end
end

% for i = 2 : package_infor_number
%     dismantle_status_normal_pro(i,1) = dismantle_status_pre_sum(i,1);
%     if (dismantle_status_pre_sum(i,2)  + dismantle_status_pre_sum(i-1,2)) >= threshold_warning_acc_sum
%         dismantle_status_normal_pro(i,2) = 1;
%     end
% end
for i = 1 : package_infor_number
    dismantle_status_normal_pro(i,1) = dismantle_status_pre_sum(i,1);
    if dismantle_status_pre_sum(i,2)  >= threshold_warning_acc_sum
        dismantle_status_normal_pro(i,2) = 1;
    end
end


dismantle_status_post_pro(:,1)=dismantle_status_normal_pro(:,1);

k = 1 ;
while ( k <= package_infor_number)
    if dismantle_status_normal_pro(k,2) == 1
        dismantle_status_post_pro(k,2) = 1;
        k = k + threshold_warning_num_interval - 1;
    else
        k = k + 1;
    end
end

if debug_flag == 1
    figure(2)
    subplot(3,1,1)
    plot(package_debug_info(:,1),package_debug_info(:,2));
    axis([0 50 0 40]);
    subplot(3,1,2)
    plot(package_debug_info(:,1),package_debug_info(:,3));
    axis([0 50 -5 40]);
    subplot(3,1,3)
    plot(dismantle_status_pre_pro(:,1),dismantle_status_pre_pro(:,2));
    axis([0 50 -0.5 1.5]);
    
    figure(3)
    subplot(2,1,1)
    plot(dismantle_status_pre_pro(:,1),dismantle_status_pre_pro(:,2));
    axis([0 50 -0.5 1.5]);
    subplot(2,1,2)
    plot(dismantle_status_pre_sum(:,1),dismantle_status_pre_sum(:,2));
    axis([0 50 -0.5 10]);
    
    figure(4)
    subplot(2,1,1)
    plot(dismantle_status_normal_pro(:,1),dismantle_status_normal_pro(:,2));
    axis([0 50 -0.5 1.5]);  
    subplot(2,1,2)
    plot(dismantle_status_post_pro(:,1),dismantle_status_post_pro(:,2));
    axis([0 50 -0.5 1.5]);
end








