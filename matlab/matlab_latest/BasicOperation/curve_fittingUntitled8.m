%% clear screem
close all
clc
clear

%% curve fitting
x = [1 2 3 4 5 6]; 
y = [5.5 43.1 128 290.7 498.4 978.67];  %data
p = polyfit(x,y,4);   %get the polynomial
% Compute the values of the polyfit estimate over a finer range, 
% and plot the estimate over the real data values for comparison:
x2 = 1:0.1:6;          
y2 = polyval(p,x2);
plot(x,y,'o',x2,y2)
grid on