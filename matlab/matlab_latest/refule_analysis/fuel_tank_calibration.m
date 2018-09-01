%% Decription
% **********************************************
% This program is used for fuel tank calibration
% **********************************************

%% Clear screen
close all
clc
clear

%% Paramter defination

%fuel tank volume and height 
V = 500;  % unit: L
% H = 80;   % unit: cm

%add fuel heigh vary range [6.4 76.2] 
%deta_h : (70/80 = 87.5%), (4/80 = 5 % ,1.6/80 = 2%)
%height range: [0 6.4], [6.4 76.2], [76.2 80]  
V_deta = 450; % unit: L
H_min_unit = 0.5; % unit: cm

%threshold setting
threshold_add_fuel_slope = 0.08;    
threshold_add_fuel_time_wind = 90; %1.5min

% 1->20180730, 2->20180801, 3->20180806, 4->20180813
select_data_idx=4;   

%orignal sample frequency: 5Hz
fs_org=5; 
%down sample freq: 1/4 Hz
fs_downsample=1/4; 
T_downsample =1/fs_downsample; % 4 seconds

% relationship between hydraumatic and height
k_relation = 1/19.5048;
b_relation = -580/19.5048;  


%% Fetch valid data from orignal data

%load four sample datas 
data_20180813=load('原始采集数据\加磁铁固定数据_20180813.txt');

%get datas lengths
len_4=length(data_20180813);

%generate datas time axis
t4=(0:1/fs_org:(len_4-1)/fs_org)';

%plot orignal signal waveform
figure(1)
plot(t4,data_20180813);
title('20180813油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');

%add fuel valid time select
t4_start = 2.17e5;
t4_end   = 2.18e5;

if select_data_idx == 4
    fx_start = t4_start;
    fx_end   = t4_end;
    fy_select = data_20180813;
    fx_select = t4;
end

fx_dat_len   = floor((fx_end - fx_start) * fs_downsample);
fx_start_idx = fx_start * fs_org;
fx_step      = fs_org/fs_downsample;

fx_valid_idx = zeros(fx_dat_len,1);
fy_valid_dat = zeros(fx_dat_len,1);

for i = 1 : fx_dat_len
    j = fx_start_idx + (i - 1) * fx_step;
    fx_valid_idx(i) = fx_select(j);
    fy_valid_dat(i) = fy_select(j);
end

%plot down sample valid signal waveform
figure(2)
plot(fx_valid_idx,fy_valid_dat);
title('加油时段的油量液压值与时间曲线');
xlabel('时间t/s');
ylabel('油量液压值');
axis([fx_start fx_end 500 2500]);

%convert hydraulic value to height
fh_valid_dat = k_relation * fy_valid_dat + b_relation;

%plot down sample valid signal waveform
figure(3)
subplot(3,1,1)
plot(fx_valid_idx,fh_valid_dat);
title('加油时段的油量高度与时间曲线');
xlabel('时间t/s');
ylabel('油量高度h/cm');
axis([fx_start fx_end 0 110]);

%set calibration flag throught sample frequeny: 0.25 Hz
calibration_enable_flag = ones(fx_dat_len-1,1);

%% Fetch detail add fule timing based continue slope
calibration_slope_fx = zeros(fx_dat_len-1,1);
calibration_slope_fy = zeros(fx_dat_len-1,1);

for i = 1 : fx_dat_len-1
    if calibration_enable_flag(i) == 1
        j = i + 1;
        calibration_slope_fx(i) = fx_valid_idx(j);
        calibration_slope_fy(i) = (fh_valid_dat(j) - fh_valid_dat(i))/((fx_valid_idx(j) - fx_valid_idx(i)));
    end
end

%plot slope signal waveform
subplot(3,1,2)
plot(calibration_slope_fx,calibration_slope_fy);
title('加油时段的油量高度斜率与时间曲线');
xlabel('时间t/s');
ylabel('油量高度斜率 cm/s');
axis([fx_start fx_end -0.25 0.5]);

great_threshold_slope_flag = zeros(fx_dat_len-1,1);
threshold_count_add_fuel_time_wind = floor(threshold_add_fuel_time_wind * fs_downsample);

for i = 1 : fx_dat_len-1
    if calibration_slope_fy(i) >= threshold_add_fuel_slope
        great_threshold_slope_flag(i) = 1;
    else
        great_threshold_slope_flag(i) = 0;
    end
end

subplot(3,1,3)
plot(calibration_slope_fx,great_threshold_slope_flag*78);
hold on 
plot(fx_valid_idx,fh_valid_dat,'r');
title('加油时段的加油状态与时间曲线');
xlabel('时间t/s');
ylabel('加油状态');
axis([fx_start fx_end -0.25 80]);

[number_piece,pos_array,len_array]=segmentation_cal(great_threshold_slope_flag,fx_dat_len-1);

for i = 1 : number_piece
    if (len_array(i) > threshold_count_add_fuel_time_wind) && (great_threshold_slope_flag(pos_array(i)) == 1)
        break;
    end
end

h_start_idx = pos_array(i);
h_end_idx   = pos_array(i) + len_array(i) - 1;
h_valid_len = len_array(i);
h_start = fh_valid_dat(h_start_idx);
h_end   = fh_valid_dat(h_end_idx);
H = h_end / 0.98;
%% build fuel tank model
% [0 h_start]
V1 = 0.98 * V - V_deta;
K1 = V1/(h_start - H_min_unit);
h1_dat_len = floor(h_start/H_min_unit - 1);
h1_fx = (0 : H_min_unit : (h1_dat_len - 1) * H_min_unit)';
h1_fy = K1 * h1_fx;

% [h_start h_end]
V2 = V_deta;
h2_dat_len = h_valid_len;
h2_fx = fh_valid_dat(h_start_idx:h_end_idx);
h2_fy = zeros(h_valid_len,1);
deta_v = V_deta/h_valid_len;
for i = 1 : h2_dat_len
    h2_fy(i) = V1 + i * deta_v;
end

% [h_end H]
V3 = 0.02 * V ;
H3 = H - h_end;
K3 = V3/H3;
h3_dat_len = floor(H3/H_min_unit);
h3_fx = (h_end+H_min_unit:H_min_unit:h_end + h3_dat_len * H_min_unit)';
h3_fy = K3 * (h3_fx-h_end) + 0.98 * V;

figure(4)
plot(h1_fx,h1_fy,'r')
hold on
plot(h2_fx,h2_fy,'g');
hold on
plot(h3_fx,h3_fy,'b');

h_fx_all = [h1_fx;h2_fx;h3_fx];
h_fy_all = [h1_fy;h2_fy;h3_fy];


figure(5)
plot(h_fx_all,h_fy_all,'-o');









