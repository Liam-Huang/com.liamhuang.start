function [ts_out,gpsDatalatitude_out,gpsDatalongitude_out] = GPSDataShortTimeWindowDelete(ts,gpsDatalatitude,gpsDatalongitude,time_wind_min)
    
    dat_len_org = length(ts);
    time_interval = zeros(dat_len_org-1,1);
    delete_cnt  = 0;
    
    for i=2:dat_len_org
        time_interval(i-1) = ts(i) - ts(i-1);
        if time_interval(i-1) < time_wind_min
            delete_cnt = delete_cnt + 1;
        end 
    end
    
    ts_out = zeros(dat_len_org-delete_cnt,1);
    gpsDatalatitude_out = zeros(dat_len_org-delete_cnt,1);
    gpsDatalongitude_out = zeros(dat_len_org-delete_cnt,1);
    
    
    for i=1:dat_len_org
        if i == 1
            j = 1;
            ts_out(j) = ts(i);
            gpsDatalatitude_out(j) = gpsDatalatitude(i);
            gpsDatalongitude_out(j) = gpsDatalongitude(i);
        else
            if time_interval(i-1) >= time_wind_min
                j=j+1;
                ts_out(j) = ts(i);
                gpsDatalatitude_out(j) = gpsDatalatitude(i);
                gpsDatalongitude_out(j) = gpsDatalongitude(i);
            end    
        end
    end

end