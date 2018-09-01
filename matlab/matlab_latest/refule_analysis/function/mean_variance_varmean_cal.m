function [y_mean,y_variance,y_varmean]=mean_variance_varmean_cal(data,dat_len,cal_len)
    y_mean=zeros(dat_len,1);
    y_variance=zeros(dat_len,1);
    y_varmean=zeros(dat_len,1);
    data_buffer=zeros(cal_len,1);
    
    %initial data buffer
    for i=1:cal_len
        data_buffer(i)=data(1);
    end
    
    for j=1:dat_len
        k=mod(j-1,cal_len)+1;
        data_buffer(k)=data(j);
        if j > floor(cal_len/2)
            y_mean(j-floor(cal_len/2))=mean(data_buffer);
            y_variance(j-floor(cal_len/2))=sqrt(var(data_buffer)/cal_len);
        end
    end
    
    for j=dat_len-floor(cal_len/2)+1:dat_len
        y_mean(j) = data(j);
    end
    
    for j=2:dat_len
        y_varmean(j)=y_mean(j)-y_mean(j-1);
    end
    
end