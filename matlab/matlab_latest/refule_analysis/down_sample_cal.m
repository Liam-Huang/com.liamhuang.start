function [y,x,len]=down_sample_cal(data,t_end,fs_org,fs_downsample)
%function complete down sample from orignal signal

% random start sample phase to reduce sample phase error
fs_start_phase=rand_start_sample_phase(1/fs_downsample);

%reduce sample frequency from fs_org to fs_downsample on select datas
fs_step=fs_org/fs_downsample;        %down sample step
data_num=floor(t_end*fs_downsample); %down sample data length
y_down_sample=zeros(data_num,1);  %down sample signal defination

%fetch down sample data from select data
x_down_sample=(0:1/fs_downsample/60:(data_num-1)/fs_downsample/60)';
for i=1:data_num
    j=(i-1)*fs_step + fs_start_phase;
    y_down_sample(i)=data(j);
end

len=data_num;
y=y_down_sample;
x=x_down_sample;

end

function [y]=rand_start_sample_phase(x)

%函数计算随机采样的起始相位，增加抗干扰性测试

%use to adjust first sample position to cover sample error
start_sample_phase_random_array = random('Poisson',1:x,1,x);  
y = mod(start_sample_phase_random_array(floor(x/2))+1,x) + 1; 

end