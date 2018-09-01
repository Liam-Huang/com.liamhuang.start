function [y]=rand_start_sample_phase(x)
%函数计算随机采样的起始相位，增加抗干扰性测试

%use to adjust first sample position to cover sample error
start_sample_phase_random_array = random('Poisson',1:x,1,x);  
y = mod(start_sample_phase_random_array(floor(x/2))+1,x) + 1; 

end