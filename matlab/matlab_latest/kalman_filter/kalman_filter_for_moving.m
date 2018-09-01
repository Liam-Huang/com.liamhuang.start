function y = kalman_filter_for_moving(x)

P = 0.04;
Q = 0.25;
a = 1;
H = 1;

N = length(x);

x_fil = zeros(N,1);
p_fil = zeros(N,1);
x_pre = zeros(N,1);
p_pre = zeros(N,1);
K     = zeros(N,1);

for k=1:N
    if k == 1
        x_fil(k)=x(k);
        p_fil(k)=P;
    else
        x_pre(k) = a * x_fil(k-1);
        p_pre(k) = a * p_fil(k-1) * a' + P;
        K(k) = p_pre(k) * H' * inv(H*p_pre(k)*H' + Q);
        x_fil(k) = x_pre(k) + K(k) * (x(k) - H * x_pre(k));
        p_fil(k) = (1-K(k)*H) * p_pre(k);      
    end
end

y = x_fil;

end