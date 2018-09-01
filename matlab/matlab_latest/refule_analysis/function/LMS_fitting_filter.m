   %递归最小均方算法-----利用瞬时值估计梯度矢量
clc;
clear all;
close all;
%************************生成仿真信号**************************************
Fs = 10000;                                                     %设置采样频率
t = 0:1/Fs:7;  
t = t';
Size_t = size(t,1);
F1 = 2;
F2 = 10;
F3 = 20;
F4 = 500;
Signal = sin(2*pi*F1*t) + 0.5*sin(2*pi*F2*t) + 0.25*sin(2*pi*F3*t); %生成信号
noise_amp = 1;                                           %定义噪声的标准差
noise1 = noise_amp*randn(Size_t,1);                        %生成高斯白噪声
noise2 = noise_amp*randn(Size_t,1);
noise3 = 5*sin(2*pi*F4*t+pi/2);

noise = noise2;
Signal_noise = Signal + 0.2*noise;                           %加入高斯白噪声
Signal_noise(2:end) = Signal_noise(2:end) + 0.15*noise(1:end-1);
Signal_noise(3:end) = Signal_noise(3:end) + 0.1*noise(1:end-2);

subplot(2,1,1);
plot(t,Signal);
title('原始信号');
subplot(2,1,2);
plot(t,Signal_noise);
title('加入干扰噪声的信号');
%*************************************************************************
M = 3;         %定义FIR滤波器阶数
Signal_Len = Size_t - M -1;   %定义信号数据的个数
niu = 0.00041;      %算法调节步长控制因子
y_out = zeros(Signal_Len,1);
error_out = zeros(Signal_Len,1);
Exp_out = zeros(Signal_Len,1);
w_out = zeros(Signal_Len,M);
for i=1:Signal_Len
    %数据输入
    if i == 1           %如果是第一次进入
        w = zeros(M,1); %初始化滤波器抽头系数
    end
    d = Signal_noise(i+M-1);                 %输入新的期望信号
    x = noise((M + i -1):-1:i,1);            %输入新的信号矢量
    %算法正体
    y = x' * w;                              %计算滤波器输出
    error = d - y;                           %计算误差
    w_forward = w + niu * error * x;         %计算滤波器系数向量
    %变量更替
    w = w_forward;
    %滤波结果存储
    y_out(i) = y;
    error_out(i) = error;
    w_out(i,:) = w';
end
figure;
subplot(2,1,1);
plot(y_out);
title('滤波器输出');
subplot(2,1,2);
plot(error_out);
title('输出误差');

figure;
plot(t(1:Signal_Len),w_out(:,1),'r',t(1:Signal_Len),w_out(:,fix(M/2)+1),'b',t(1:Signal_Len),w_out(:,M),'y');
title('自适应滤波器系数');