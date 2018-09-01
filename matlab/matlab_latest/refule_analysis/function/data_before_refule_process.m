function   [data_refule_pre_pro]=data_before_refule_process(upload_refule,flag_times,flag_start_pos_array,flag_pro_len,flag_variance_limit)

    flag_search_time_variance_range=flag_pro_len;
    flag_search_time_mean_range=2*flag_pro_len;
    flag_pos_mean_variance_array = zeros(flag_times,3);
    data_refule_pre_pro=upload_refule;

    for i=1:flag_times
        flag_signal_mean=upload_refule(flag_start_pos_array(i)-flag_search_time_mean_range:flag_start_pos_array(i)-flag_search_time_variance_range+1);
        flag_signal_varinace=upload_refule(flag_start_pos_array(i)-flag_search_time_variance_range:flag_start_pos_array(i)-1);
        flag_pos_mean_variance_array(i,1)=flag_start_pos_array(i);
        flag_pos_mean_variance_array(i,2)=mean(flag_signal_mean);
        for j=1:flag_pro_len
            flag_pos_mean_variance_array(i,3)=flag_pos_mean_variance_array(i,3) + (flag_signal_varinace(i)-flag_pos_mean_variance_array(i,2))*(flag_signal_varinace(i)-flag_pos_mean_variance_array(i,2));
        end
        flag_pos_mean_variance_array(i,3) = sqrt(flag_pos_mean_variance_array(i,3)/flag_pro_len);
    
        if flag_pos_mean_variance_array(i,3) > flag_variance_limit
            for j=0:flag_pro_len
                data_refule_pre_pro(flag_pos_mean_variance_array(i,1) - j)=flag_pos_mean_variance_array(i,2);
            end
        end
    end
end