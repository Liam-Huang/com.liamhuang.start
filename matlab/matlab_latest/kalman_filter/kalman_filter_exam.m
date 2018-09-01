%%
close all
clear
clc


%%
N=100;
x(1)=0;
P = 0.04;
Q = 0.25;
a = 1;
H = 1;
for k=2:N
    x(k) = a*x(k-1) + sqrt(P) * randn;
    y(k) = H*x(k) + sqrt(Q) *randn;
end

x_fil(1) = x(1);
p_fil(1) = 0.04;

for k=2:N
    x_pre(k) = a * x_fil(k-1);
    p_pre(k) = a * p_fil(k-1) * a' + P;
    K(k) = p_pre(k) * H' * inv(H*p_pre(k)*H' + Q);
    x_fil(k) = x_pre(k) + K(k) * (y(k) - H * x_pre(k));
    p_fil(k) = (1-K(k)*H) * p_pre(k);
end

t=1:N;
plot(t,x_fil,'r',t,y,'g',t,x,'b');
