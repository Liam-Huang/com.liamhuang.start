function [y]=overlap_mean_cal(x,n)
%该函数计算重叠均值
%输入：x input signal
%输出：n number of overlap
%输出：y output mean

%initial signals
len=length(x);
y=zeros(len,1);
sum_n=zeros(len,1);

for i=1:len
    %cal sum of n
    if i == 1
        sum_n(i)=x(i);
    elseif i <= n
        sum_n(i)= sum_n(i-1)+x(i);
    else
        sum_n(i)= sum_n(i-1)+x(i)-x(i-n+1);
    end
    %cal mean of sum
    if i < n
        y(i)=sum_n(i)/i;
    else
        y(i)=sum_n(i)/n;
    end
end

% zz=[x,sum_n,y];
                           
