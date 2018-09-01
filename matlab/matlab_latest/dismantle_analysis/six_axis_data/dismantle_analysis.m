%% clear screen
clc
close all
clear

%% orignal signal and data down sample
sample_piece=7;
start_piece_idx=1;
end_piece_idx=7;
package_len=256;

dismantle_2s_800Hz_256=load('six_axis_dismantle_2s_800HZ_256pl.txt'); %拆除
dismantle_static_waggle_2s_800Hz_256=load('six_axis_dismantle_static_waggle_2s_800Hz_256pl.txt'); %拆除-静止-晃动
six_axis_drag_2s_800Hz_256=load('six_axis_drag_2s_800HZ_256pl.txt'); %横向拖动
six_axis_fan_work_shake_2s_800Hz_256=load('six_axis_fan_work_shake_2s_800HZ_256pl.txt'); %风扇工作-工作加摇头
six_axis_static_2s_800Hz_256=load('six_axis_static_2s_800Hz_256pl.txt'); %静止
six_axis_waggle_2s_800Hz_256=load('six_axis_waggle_2s_800HZ_256pl.txt'); %晃动
six_axis_walk_2s_800Hz_256=load('six_axis_walk_2s_800HZ_256pl.txt');     %正常走路晃动

for i=start_piece_idx:end_piece_idx
    
select_idx = i;

if select_idx == 1
    data_org=dismantle_2s_800Hz_256;
elseif select_idx == 2
    data_org=dismantle_static_waggle_2s_800Hz_256;
elseif select_idx == 3
    data_org=six_axis_drag_2s_800Hz_256;
elseif select_idx == 4
    data_org=six_axis_fan_work_shake_2s_800Hz_256;
elseif select_idx == 5
    data_org=six_axis_static_2s_800Hz_256;
elseif select_idx == 6
    data_org=six_axis_waggle_2s_800Hz_256;
elseif select_idx == 7
    data_org=six_axis_walk_2s_800Hz_256;
end

data_idx=data_org(:,1);
factor=1/8280*9.8;
data_acc_x=data_org(:,2)*factor;
data_acc_y=data_org(:,3)*factor;
data_acc_z=data_org(:,4)*factor;
data_len=length(data_idx);
data_x=(0:1:data_len-1)';

figure(i)
subplot(4,1,1)
plot(data_x, data_idx);

subplot(4,1,2)
plot(data_x, data_acc_x);

subplot(4,1,3)
plot(data_x, data_acc_y);

subplot(4,1,4)
plot(data_x, data_acc_z);


%三轴加速方差计算
package_number=data_len/package_len;
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

figure(sample_piece+i)
subplot(3,1,1)
plot(variance_t, variance_x);

subplot(3,1,2)
plot(variance_t, variance_y);

subplot(3,1,3)
plot(variance_t, variance_z);

end
