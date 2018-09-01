close all
clc
clear
%%
% random_int_dat = randi([0 1], 4*60, 1);
alphabet = [0 1]; prob = [0.7 0.3];
random_int_dat=randsrc(100,1,[alphabet; prob]);

dat_len = length(random_int_dat);

fx_time  = (0:1:dat_len-1)';
fy_randi = random_int_dat;

figure(1)
plot(fx_time,fy_randi);
axis([0 dat_len -0.5 1.5]);

%% generate test for java
data_len = 18;
pack_len = 20;
%data_format: 
%[idx0, dat_array0, sum0]
%[idx1, dat_array1, sum1]
%[idxn, dat_arrayn, sumn]
package_info = zeros(pack_len,data_len+2);
data_idx = 0;
data_sum = 0;
data_array = zeros(1,data_len);

for i=1:pack_len
    data_idx = i-1;
    data_array = randi([0 1], 1, data_len);
    data_sum = sum(data_array);
    package_info(i,:)=[data_idx,data_array,data_sum];
end
filename = 'package_info.xls';
delete(filename);
xlswrite(filename,package_info);