function [y]=rand_start_sample_phase(x)
%�������������������ʼ��λ�����ӿ������Բ���

%use to adjust first sample position to cover sample error
start_sample_phase_random_array = random('Poisson',1:x,1,x);  
y = mod(start_sample_phase_random_array(floor(x/2))+1,x) + 1; 

end