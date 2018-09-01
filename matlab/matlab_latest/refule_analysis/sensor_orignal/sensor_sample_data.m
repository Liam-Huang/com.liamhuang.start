close all
clear
clc
%% ��������봫��������Һ���Һѹ��������
fs=5;
y=load('����������������.txt');
len=length(y);
x=(0:1/fs:(len-1)/fs)';
figure(1)
plot(x,y);
title('������Һѹֵ��ʱ���ϵ');
xlabel('ʱ��/s');
ylabel('������Һѹֵ');

%% ���ٴ���������Һ���Һѹ��������

y = importfile('��װǰ����.xlsx','Sheet1',1,362);
len=length(y);
x=(0:1/fs:(len-1)/fs)';
figure(2)
plot(x,y);
title('������Һѹֵ��ʱ���ϵ');
xlabel('ʱ��/s');
ylabel('������Һѹֵ');

%% ��ͬ��ȵ�ˮ��Ӧ��Һѹֵ
%   �������Ĳ�����Ч��ȷ�Χ�� 0 ~ 100 cm
%   Һѹ��ʽ�� P = R���ܶȣ� * G ���������ٶȣ�* H (�߶�)
%   ˮ�� 1.0000 kg/m^3��4���϶ȣ�
%   ���ͣ�0.840 kg/m^3 (0.82~0.86)

fs=0.1;
y = load('ADC.txt');
len=length(y);
x=(0:1/fs:(len-1)/fs)';
figure(3)
plot(x,y);
title('������Һѹֵ��ʱ���ϵ');
xlabel('ʱ��/s');
ylabel('������Һѹֵ');

slope_water = (y(len-1) - y(1))/((x(len-1) - x(1)));
slope_diesel = slope_water * 0.84 ;

y = slope_diesel * x + 580;
figure(4)
plot(x,y);
title('������Һѹֵ��ʱ���ϵ');
xlabel('ʱ��/s');
ylabel('������Һѹֵ');

% ������ѹֵ��1m��ȣ�����Χ�� 580 ~ 2500
x=(y-580)/slope_diesel;  
figure(5)
plot(y,x);
title('����Һ��߶��봫����Һѹֵ�Ĺ�ϵ');
xlabel('������Һѹֵ');
ylabel('Һ��߶�');
