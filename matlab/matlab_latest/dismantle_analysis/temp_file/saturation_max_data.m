function [y]=saturation_max_data(x,dat_len,sat_threshold)
    y=zeros(dat_len,1);
    
    for i=1:dat_len
        if x(i) > sat_threshold
            y(i) = sat_threshold;
        else
            y(i) = x(i);
        end
    end
    
end