Fs = 2;

X = [1 -1 1 -1  1 -1 1 -1 1 0 0 0 0 0 0 0]
Y = fft(X);

L = length(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1);

clear;
