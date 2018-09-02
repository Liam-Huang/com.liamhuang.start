%% clear screem
close all
clc
clear

%% Matlab calculate equation root
%method1: solve
%method2: root

%% method1:
eq = 'x^2 -7*x + 12 = 0';
s = solve(eq);

eq1 = '5*x + 9*y = 5';
eq2 = '3*x - 6*y = 4';
s = solve(eq1,eq2);
x = s.x;
y = s.y;

%% method2:
eq = [1,-7,12];
s = roots(eq);

A = [5, 9; 3, -6];
B = [5;4];
C = A \ B;