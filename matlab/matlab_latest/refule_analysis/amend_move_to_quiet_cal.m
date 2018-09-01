function [y]=amend_move_to_quiet_cal(x,x_status,n,pos_array,len_array,refule_mid_pro_quiet_threshold,refule_mid_pro_quiet_remove_threshold,refule_mid_pro_move_thresholde,status_quiet,status_move)

y=x;
for i=2:n
    if ((x_status(pos_array(i-1)) == status_move) && (x_status(pos_array(i)) == status_quiet) && (len_array(i-1) >= refule_mid_pro_move_thresholde) && (len_array(i) >= refule_mid_pro_quiet_threshold))
        signal_mean=y(pos_array(i)+refule_mid_pro_quiet_remove_threshold:pos_array(i)+len_array(i)-1);
        mean_value=mean(signal_mean);
        for j=0:refule_mid_pro_quiet_remove_threshold-1
            y(pos_array(i)+j)=mean_value;
        end
    end
end