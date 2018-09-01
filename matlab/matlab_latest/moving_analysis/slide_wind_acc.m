function y = slide_wind_acc(x,acc_wind_len)
    x_len = length(x);
    y     = zeros(x_len);
    for i=1:x_len
        if (i >= acc_wind_len+1 ) && ( i <= x_len-acc_wind_len)
            for j = -acc_wind_len:acc_wind_len
                y(i) = y(i) + x(i+j);
            end  
        else
            y(i) = x(i);
        end
    end
end