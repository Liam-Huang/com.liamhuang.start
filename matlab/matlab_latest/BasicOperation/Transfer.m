%% clear screem
close all
clc
clear

%% Transfer
%laplace, ilaplace
%fourier, ifourier

%% laplace
syms s t a b w
laplace(a)
laplace(t^2)
laplace(t^9)
laplace(exp(-b*t))
laplace(sin(w*t))
laplace(cos(w*t))

%% ilaplace
syms s t a b w
ilaplace(1/s^7)
ilaplace(2/(w+s))
ilaplace(s/(s^2+4))
ilaplace(exp(-b*t))
ilaplace(w/(s^2 + w^2))
ilaplace(s/(s^2 + w^2))

%% fourier transfer
syms x 
f = exp(-2*x^2);  %our function
figure();
ezplot(f,[-2,2]);  % plot of our function
FT = fourier(f);    % Fourier transform

%% ifourier transfer
figure()
f = ifourier(-2*exp(-abs(w)));
ezplot(f,[-2,2]); 
