function  [y] = overlap_mean_cal(x,dat_len,overlap_len)
    
    y=zeros(dat_len,1);
    y_sum=zeros(dat_len,1);
    
    for i=1:dat_len
        if i ==1
            y_sum(i) = x(i);
            y(i) = x(i);
        elseif i <= overlap_len
            y_sum(i) = y_sum(i-1) + x(i);
            y(i) = x(i);         
        else
            y_sum(i) = y_sum(i-1) + x(i) - x(i-overlap_len);
            y(i) = y_sum(i)/overlap_len;
        end
    end
    
end