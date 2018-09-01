%% clear screen
close all
clear
clc

%% 
%signal generator model generate
data_select_idx = 2;
windRadius=14;
weight_len = 7;
weight_coe = 50;
dis_order = 1;
width_order = 3;
validThreshold = 0.010;
connectableLength = 5;
validLength = 5;


if data_select_idx == 1
    [y,x] = signalGenerator();
elseif data_select_idx == 2
    alphabet = [0 1]; prob = [0.8 0.2];
    y=randsrc(500,1,[alphabet; prob]);
    x=(0:1:length(y)-1)';
end

%% adaptive partial Filter Process
[y_filter] = slideWindAdaptiveFilter(y,windRadius,weight_len,weight_coe,dis_order,width_order);
yTimeSegment = timeSegmentCal(y_filter,validThreshold,connectableLength,validLength);
[fy,fx] = fillUnvalidSection(yTimeSegment,length(y_filter));

figure(1)
plot(x,y);
axis ([0 max(x) -0.5 1.5]);

figure(2)
subplot(2,1,1);
plot(x,y,'b');
axis ([0 max(x) -0.2 1.2]);
subplot(2,1,2);
plot(x,y_filter,'g');
hold on
plot(fx,fy,'r');
axis ([0 max(x) -0.2 1.2]);

figure(3)
plot(x,y);
hold on 
plot(x,y_filter,'r');
hold on
plot(fx,fy,'g');
axis ([0 max(x) -0.2 1.2]);







