%% clear screen
close all
clear 
clc
%% signal generator
    %signal1: standard quadratic curve
    %signal2: signal scale, translation and noise inject
    
    snr = 43;
    x = (0 : 4 : 1000)';
    x1 = x(1:50);
    signal1 = power(x1,2);
    signal1 = noisegen(signal1,snr)/500;
    x2 = x(50:125);
    signal2 = power(0.5*(x2),2);
    signal2 = noisegen(signal2,snr)/500;
    plot(x1,signal1,'g',x2,signal2,'r');
    signal1MaxMin=[max(signal1),min(signal1)];
    signal2MaxMin=[max(signal2),min(signal2)];
    
    % hypothesis1:  min(signal1) < min(signal2) < max(signal1) < max(signal2)
    % hypothesis2:  min(signal2) < min(signal1) < max(signal2) < max(signal1) 
    % hypothesis3:  min(signal1) < min(signal2) < max(signal2) < max(signal1)
    
    % hypothesis1 && 2: two signal have common and independent part
    % hypothesis3: signal1 has included signal1
    
    %Test hypothesis1:
    %part1: [min(signal1),min(signal2)] -> signal1
    %part2: [min(signal2),max(signal1)] -> signal1 && signal2
    %part3: [max(signal1),max(signal2)] -> signal2