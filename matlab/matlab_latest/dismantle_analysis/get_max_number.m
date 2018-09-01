function [max_point]=get_max_number(x,dat_len,clr_radius,num)

    max_point=zeros(1,2*num);  
    dat_in = x;
    
    for i=1:num
      [dat_out,max_point(1,2*(i-1)+1:2*i)]=get_max_clr(dat_in,dat_len,clr_radius);
      dat_in = dat_out;
    end
   
end