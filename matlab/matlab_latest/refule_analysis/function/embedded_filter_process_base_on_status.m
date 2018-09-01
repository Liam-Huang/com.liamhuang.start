function [refule_embedder_filter_out]=embedded_filter_process_base_on_status(y_mean,machine_status_pre_pro,len_down_sample,status_refule,status_steal)

    alpha0=1/8;
    alpha1=3/8;
    filter_order=4;
    refule_embedder_filter_out=zeros(len_down_sample,1);
    
    for i=1:len_down_sample
        if (i < filter_order) || (machine_status_pre_pro(i) == status_refule) || (machine_status_pre_pro(i) == status_steal)
            refule_embedder_filter_out(i) = y_mean(i);
        elseif (machine_status_pre_pro(i) == status_refule) || (machine_status_pre_pro(i-1) == status_refule) || (machine_status_pre_pro(i-2) == status_refule) || (machine_status_pre_pro(i-3) == status_refule)
            refule_embedder_filter_out(i) = y_mean(i);
        elseif (machine_status_pre_pro(i) == status_steal) || (machine_status_pre_pro(i-1) == status_steal) || (machine_status_pre_pro(i-2) == status_steal) || (machine_status_pre_pro(i-3) == status_steal)
            refule_embedder_filter_out(i) = y_mean(i);
        else
            refule_embedder_filter_out(i) = (y_mean(i) + y_mean(i-3))*alpha0 + (y_mean(i-1) + y_mean(i-2))*alpha1;
        end
    end
   
end