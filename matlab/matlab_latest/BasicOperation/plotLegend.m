%% clear screem
close all
clc
clear
%%  lengend
x = (0:0.01:2*pi)';
y = sin(x);
g = cos(x);
figure();
plot(x, y,'g', x, g, 'r');
legend('Sin(x)', 'Cos(x)');
grid on;

%% 直方图  bar(x,y)
x = 1:10;
y = [75, 58, 90, 87, 50, 85, 92, 75, 60, 95];
figure();
bar(x,y), xlabel('Student'),ylabel('Score'),
title('First Sem:')
print -deps graph.eps

%% 等高线
[x,y] = meshgrid(-5:0.1:5,-5:0.1:5); %independent variables
g = x.^2 + y.^2;                     % our function
figure();
[C, h] = contour(x,y,g);             % call the contour function
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
print -deps graph.eps;

%% 三维图

[x,y] = meshgrid(-2:0.2:2, -4:0.2:4);
g = x .* exp(-x.^2 - y.^2);
figure();
subplot(2,1,1);
surf(x, y, g);
subplot(2,1,2);
mesh(x, y, g);
print -deps graph.eps;
