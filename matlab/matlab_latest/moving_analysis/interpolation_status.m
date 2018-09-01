function  [y_out,x_out,len_out] = interpolation_status(y,x,x_wind_len)


      
    dat_len1 = length(x);
    dat_len2 = length(y);
    dat_len  = min(dat_len1,dat_len2);
    
    for i=1:dat_len
        if i == 1
            end_idx = 1;
        else
            deta_N = floor((x(i) - x(i-1))/x_wind_len - 1);
            deta_x = (x(i) - x(i-1))/(deta_N + 1);          
            
            start_idx = end_idx;
            
            for j = 0 : deta_N
                  x_out(start_idx + j) =  x(i-1) + j * deta_x;
                  if j == 0
                      y_out(start_idx + j) =  y(i-1);
                  elseif y(i-1) == y(i)
                      y_out(start_idx + j) = y(i-1);
                  else
                      y_out(start_idx + j) = 0;
                  end              
            end
            
            end_idx  = start_idx + deta_N + 1;
        end        
    end
    
    x_out = x_out';
    y_out = y_out';
    len_out = end_idx-1;
   
end