function [y,max_point]=get_max_clr(x,dat_len,clr_radius)

    y=zeros(dat_len,1);
    
    [y_max,x_max]=max(x(1:floor(dat_len/2)));
    max_point=[x_max,y_max];
    
    for i=1:dat_len
        if (i < x_max - clr_radius) || (i > x_max + clr_radius)
            y(i) = x(i);
        else
            y(i) = 0;
        end
    end
   
end