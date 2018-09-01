%%
clc
close all
clear

%% orignal signal and data down sample
sample_piece=3;
start_piece_idx=1;
end_piece_idx=3;
package_len=256;
picture_num=2;

data_0=load('Record_0_pl.txt');  
data_1=load('Record_1_pl.txt');
data_2=load('Record_2_pl.txt');

for i=start_piece_idx:end_piece_idx
    
select_idx = i;

if select_idx == 1
    data_org=data_0;
elseif select_idx == 2
    data_org=data_1;
elseif select_idx == 3
    data_org=data_2;
end

data_idx=data_org(:,1);
factor=1;
data_acc_x=data_org(:,2)*factor;
data_acc_y=data_org(:,3)*factor;
data_acc_z=data_org(:,4)*factor;
data_len=length(data_idx);
data_x=(0:1:data_len-1)';

figure(picture_num*(i-1)+1)
subplot(4,1,1)
plot(data_x, data_idx);

subplot(4,1,2)
plot(data_x, data_acc_x);

subplot(4,1,3)
plot(data_x, data_acc_y);

subplot(4,1,4)
plot(data_x, data_acc_z);


%三轴加速方差计算
package_number=floor(data_len/package_len);
variance_t=(0:1:package_number-1)';
variance_x=zeros(package_number,1);
variance_y=zeros(package_number,1);
variance_z=zeros(package_number,1);

for j=1:package_number
    signal_x=data_acc_x((j-1)*package_len+1:j*package_len);
    signal_y=data_acc_y((j-1)*package_len+1:j*package_len);
    signal_z=data_acc_z((j-1)*package_len+1:j*package_len);
    variance_x(j)=var(signal_x);
    variance_y(j)=var(signal_y);
    variance_z(j)=var(signal_z);
end

figure(picture_num*(i-1)+2)
subplot(3,1,1)
plot(variance_t, variance_x);

subplot(3,1,2)
plot(variance_t, variance_y);

subplot(3,1,3)
plot(variance_t, variance_z);

end