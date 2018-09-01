function  [times,start_pos]=cal_refule_boundry(machine_status,dat_len,status_refule)
    
    times = 0;
    for i=1:dat_len
        if (machine_status(i) == status_refule) && (machine_status(i-1) ~= status_refule)
            times = times + 1;
        end
    end
    
    start_pos=zeros(times,1);
    
    j=0;  
    for i=1:dat_len
        if (machine_status(i) == status_refule) && (machine_status(i-1) ~= status_refule)
            j = j + 1;
            start_pos(j)=i;
        end
    end
    
end