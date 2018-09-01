function  [y] = StatusTimeWindSegmentationProcess(x,acc_time_wind_len,acc_value_threshold,status_exception,status_static,status_move)
    
    dat_len     = length(x);
    package_num = floor(dat_len/acc_time_wind_len);
    
    data_buffer   = zeros(acc_time_wind_len);
    y = zeros(dat_len,1);
    
    for i = 1 : package_num
        signal_buffer = x(1 + (i-1)*acc_time_wind_len : i*acc_time_wind_len );
        status_max = max(signal_buffer);
        if (status_max >= status_exception) % add and steal value status
            data_buffer(1:acc_time_wind_len) = signal_buffer;    
        else
            signal_sum_val = sum(signal_buffer);
            if signal_sum_val >= acc_value_threshold
                data_buffer(1:acc_time_wind_len) = status_move;
            else
                data_buffer(1:acc_time_wind_len) = status_static;
            end
        end
        y(1 + (i-1)*acc_time_wind_len : i*acc_time_wind_len ) = data_buffer(1:acc_time_wind_len);
    end
end