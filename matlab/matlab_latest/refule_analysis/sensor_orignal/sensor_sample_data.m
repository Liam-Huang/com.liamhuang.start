close all
clear
clc
%% 提升与放入传感器进入液体的液压测试数据
fs=5;
y=load('缓慢放入油箱数据.txt');
len=length(y);
x=(0:1/fs:(len-1)/fs)';
figure(1)
plot(x,y);
title('传感器液压值与时间关系');
xlabel('时间/s');
ylabel('传感器液压值');

%% 匀速传感器进入液体的液压测试数据

y = importfile('安装前测试.xlsx','Sheet1',1,362);
len=length(y);
x=(0:1/fs:(len-1)/fs)';
figure(2)
plot(x,y);
title('传感器液压值与时间关系');
xlabel('时间/s');
ylabel('传感器液压值');

%% 不同深度的水对应的液压值
%   传感器的测试有效深度范围： 0 ~ 100 cm
%   液压公式： P = R（密度） * G （重力加速度）* H (高度)
%   水： 1.0000 kg/m^3（4摄氏度）
%   柴油：0.840 kg/m^3 (0.82~0.86)

fs=0.1;
y = load('ADC.txt');
len=length(y);
x=(0:1/fs:(len-1)/fs)';
figure(3)
plot(x,y);
title('传感器液压值与时间关系');
xlabel('时间/s');
ylabel('传感器液压值');

slope_water = (y(len-1) - y(1))/((x(len-1) - x(1)));
slope_diesel = slope_water * 0.84 ;

y = slope_diesel * x + 580;
figure(4)
plot(x,y);
title('传感器液压值与时间关系');
xlabel('时间/s');
ylabel('传感器液压值');

% 柴油油压值（1m深度）合理范围： 580 ~ 2500
x=(y-580)/slope_diesel;  
figure(5)
plot(y,x);
title('柴油液面高度与传感器液压值的关系');
xlabel('传感器液压值');
ylabel('液面高度');
