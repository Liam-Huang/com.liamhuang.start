close all
clear
clc

%% import data
data_select_idx=1;

startRow=2;
endRow=100;

time_wind_min=0.025; %1.5min  normal: 3min -> 0.05h
threshold_speed_sat=100;

acc_wind_len=5;
threshold_speed=10;
threshold_acc=4;
speed_interpolation_win_len=0.05;
threshold_unstable = 1;
threshold_stable   = 2;

if data_select_idx == 1
    [gpsDatalatitude_src,gpsDatalongitude_src,presentTs] = importfile_gps_data('GPS_DATA\gauss.gpsMsg_1805132.csv', startRow, endRow);
    ts=presentTs*60;
    gpsDatalatitude=gpsDatalatitude_src;
    gpsDatalongitude=gpsDatalongitude_src;
elseif data_select_idx == 2
   [gpsDatalatitude_src,gpsDatalongitude_src,presentTs] = importfile_gps_data('GPS_DATA\gauss.gpsMsg_1804827.csv', startRow, endRow);
   ts=presentTs;
   gpsDatalatitude=gpsDatalatitude_src;
   gpsDatalongitude=gpsDatalongitude_src;
elseif data_select_idx == 3
   [gpsDatalatitude_src,gpsDatalongitude_src,presentTs] = importfile_gps_data('GPS_DATA\gauss.gpsMsg_1804943.csv', startRow, endRow);
   ts=presentTs;
   gpsDatalatitude=gpsDatalatitude_src;
   gpsDatalongitude=gpsDatalongitude_src;
elseif data_select_idx == 4
   [gpsDatalatitude_src,gpsDatalongitude_src,presentTs] = importfile_gps_data('GPS_DATA\gauss.gpsMsg_1804955.csv', startRow, endRow);
   ts=presentTs;
   gpsDatalatitude=gpsDatalatitude_src;
   gpsDatalongitude=gpsDatalongitude_src;
elseif data_select_idx == 5
   [gpsDatalatitude_src,gpsDatalongitude_src,presentTs] = importfile_gps_data('GPS_DATA\gauss.gpsMsg_1805032.csv', startRow, endRow);
   ts=presentTs;
   gpsDatalatitude=gpsDatalatitude_src;
   gpsDatalongitude=gpsDatalongitude_src;
end

package_info = [ts,gpsDatalatitude,gpsDatalongitude];


% ts=(ts - ts(1))/3600;
 ts=(ts )/3600;

figure(1)
plot(gpsDatalatitude,gpsDatalongitude);
title('GPS collection data');
xlabel('Latitude data');
ylabel('Longitude data');


%% delete short time window : 1.5min time windown
[ts_out,gpsDatalatitude_out,gpsDatalongitude_out] = GPSDataShortTimeWindowDelete(ts,gpsDatalatitude,gpsDatalongitude,time_wind_min);

%% calculate time_interval, distance, speed
len = length(ts_out);
len_real=len - 1;

time_interval  = zeros(len_real,1);
dis_interval   = zeros(len_real,1);
spd_interval   = zeros(len_real,1);

for i = 2:len
    j = i - 1;
    time_interval(j)  = (ts_out(i) - ts_out(j));
    dis_interval(j)   = Distance(gpsDatalatitude_out(i),gpsDatalongitude_out(i),gpsDatalatitude_out(j),gpsDatalongitude_out(j));
    spd_interval(j)   = dis_interval(j)/time_interval(j);
    if spd_interval(j) >= threshold_speed_sat %saturation speed 150km/h
        if j == 1
            spd_interval(j) = 0;
        else
            spd_interval(j) = spd_interval(j-1);
        end
    end
end

ts_real = ts_out(2:len);

figure(2)
subplot(3,1,1)
plot(ts_real,time_interval);
title('time interval vs time curve');
xlabel('time -> h');
ylabel('time interval -> h');
axis([0 max(ts_real) 0 4])

subplot(3,1,2);
plot(ts_real,dis_interval);
title('distance interval vs time curve');
xlabel('time -> h');
ylabel('distance interval -> km');
axis([0 max(ts_real) 0 10])

subplot(3,1,3)
plot(ts_real,spd_interval);
title('speed interval vs time curve');
xlabel('time -> h');
ylabel('speed interval -> km/h');
axis([0 max(ts_real) 0 150])

%% distinguish real time machine moving(1) and unmoving(0) status from speed threshold

machine_status = zeros(len_real,1);
for i = 1:len_real
    if spd_interval(i) >= threshold_speed
        machine_status(i) = 1;
    else
        machine_status(i) = 0;
    end
end

%% Daily report machine moving status precess
%% interpolate status for different time interval
[status_interpolate,ts_interpolate,len_interpolate] = interpolation_status(machine_status,ts_real,speed_interpolation_win_len);

%% calculate slide window accumulation for machine status 
status_slide_wind_acc = slide_wind_acc(status_interpolate,acc_wind_len);

%% distinguish stable status from status acc value
machine_status_normal = zeros(len_interpolate,1);

for i = 1:len_interpolate
    if status_slide_wind_acc(i) >=  threshold_acc
        machine_status_normal(i) = 1;
    else
        machine_status_normal(i) = 0;
    end
end

%% delete very short unstable status

[number_piece,pos_array,len_array]=segmentation_cal(machine_status_normal,len_interpolate);
machine_status_post=delete_unstable_status_cal(machine_status_normal, number_piece, pos_array, len_array, threshold_unstable, threshold_stable);

%%
figure(3)
subplot(4,1,1)
plot(ts_real,machine_status);
title('orignal machine status vs time curve');
xlabel('time -> h');
ylabel('machine status 0: unmoving 1: moving');

subplot(4,1,2)
plot(ts_interpolate,status_interpolate);
title('interpolate machine status vs time curve');
xlabel('time -> h');
ylabel('machine status 0: unmoving 1: moving');

subplot(4,1,3)
plot(ts_interpolate,status_slide_wind_acc);
% plot(ts_interpolate,machine_status_normal);
title('slide window accumulate machine status vs time curve');
xlabel('time -> h');
ylabel('slide window accumulate');

subplot(4,1,4)
plot(ts_interpolate,machine_status_normal,'b');
hold on 
plot(ts_interpolate,machine_status_post,'r');
title('post process machine status vs time curve');
xlabel('time -> h');
ylabel('machine status 0: unmoving 1: moving');
% axis([0 max(ts_interpolate) -0.2 1.2]);

%%
figure(4)
subplot(3,1,1)
plot(ts_real,spd_interval);
title('speed vs time curve');
xlabel('time -> h');
ylabel('speed -> km/h');
% axis([0 max(ts_interpolate) 0 100]);

subplot(3,1,2)
plot(ts_interpolate,status_interpolate);
title('real time machine status vs time curve');
xlabel('time -> h');
ylabel('machine status');
legend('1: moving 0: unmoving')
% axis([0 max(ts_interpolate) -0.5 1.5]);


subplot(3,1,3)
plot(ts_interpolate,machine_status_post);
title('daily report machine status vs time curve');
xlabel('time -> h');
ylabel('machine status');
legend('1: moving 0: unmoving')
% axis([0 max(ts_interpolate) -0.5 1.5]);
