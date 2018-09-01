function [machine_status_pre_pro]=machine_status_pre_process(dat_len,status_static,status_move,status_refule,status_steal,y_variance,y_varmean,refule_add_mean_threshold,refule_add_var_threshold,cal_len_steal,refule_steal_mean_5min_threshold,refule_steal_var_threshold,refule_move_var_threshold)
    
    y_varmean_cal_len_steal=zeros(dat_len,1);
    machine_status_pre_pro=zeros(dat_len,1);
    
    for i=1:dat_len
        if i == 1
            y_varmean_cal_len_steal(i) = y_varmean(i);
        elseif i < cal_len_steal
            y_varmean_cal_len_steal(i) = y_varmean_cal_len_steal(i-1) + y_varmean(i);
        else
            y_varmean_cal_len_steal(i) = y_varmean_cal_len_steal(i-1) + y_varmean(i) - y_varmean(i-cal_len_steal+1);
        end
    end
    
    for i=1:dat_len
        if (y_varmean(i) >= refule_add_mean_threshold) && (y_variance(i) >= refule_add_var_threshold)
            machine_status_pre_pro(i) = status_refule;
        elseif (y_varmean_cal_len_steal(i) <= refule_steal_mean_5min_threshold) && (y_variance(i) >= refule_steal_var_threshold)
            machine_status_pre_pro(i) = status_steal;
        elseif (y_variance(i) >= refule_move_var_threshold)
            machine_status_pre_pro(i) = status_move;
        else
            machine_status_pre_pro(i) = status_static;
        end
    end
    
end
