function  [status_extend,steal_flag]=status_extend_refule_steal_stage(machine_status,dat_len,status_refule,status_steal)

    machine_status_cl_shift=circshift(machine_status,-1);
    machine_status_cr_shift=circshift(machine_status,1);
    status_extend=machine_status;
    steal_flag=zeros(dat_len,1);
    
    for i=1:dat_len
        
        if ((machine_status_cl_shift(i) == status_refule) && (machine_status(i) ~= status_refule)) || ((machine_status_cr_shift(i) == status_refule) && (machine_status(i) ~= status_refule))
            status_extend(i) = status_refule;
        elseif ((machine_status_cl_shift(i) == status_steal) && (machine_status(i) ~= status_steal)) || ((machine_status_cr_shift(i) == status_steal) && (machine_status(i) ~= status_steal))
            status_extend(i) = status_steal;
        else
            status_extend(i) = machine_status(i);
        end
        
        if (machine_status_cr_shift(i) ~= status_steal) && (machine_status(i) == status_steal)
            steal_flag(i)=1;
        else
            steal_flag(i)=0;
        end
        
    end
    
end