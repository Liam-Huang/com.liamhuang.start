clc;
clear;
close all;
%%
data=load('data.txt');
len=length(data);
fs=5;

figure(1);
t=0:1/fs:(len-1)/fs;
subplot(2,2,1);
plot(t,data);
title('整体油量的液压值与时间曲线');
xlabel('时间t/s')
ylabel('油量的液压值');

subplot(2,2,2);
plot(t,data);
title('局部一：异常油量的液压值段');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([7.5e4 8.3e4 1250 1550]);

subplot(2,2,3);
plot(t,data);
title('局部二：加油段负向脉冲');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([1.35e5 1.40e5 1200 2200]);

subplot(2,2,4);
plot(t,data);
title('局部三：机械正常工作耗油阶段');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([1.40e5 1.85e5 1200 2200]);

%%
%选取机械正常工作耗油阶段分析
N2_start1=1.40e5*5;
N2_start2=1.80e5*5;
data_work=data(N2_start1:N2_start2);
len_work=length(data_work);

figure(2);
t_work=N2_start1/fs:1/fs:(N2_start1+len_work-1)/fs;
subplot(2,2,1);
plot(t_work,data_work);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');

fft_y_work=fftshift(abs(fft(data_work,len_work)));
fft_x_work=-fs/2:fs/len_work:fs/2-fs/len_work;
subplot(2,2,2);
plot(fft_x_work,fft_y_work);
title('机械工作阶段油量的液压值频谱图');
xlabel('频率f/Hz')
ylabel('频率幅度');

%高通滤波处理
As=80;
fstop=0.15;
fpass=0.4;
sat_limit=3;
data_filter_work=fir_hpf(data_work,fs,As,fpass,fstop);
data_filter_work_sat=data_filter_work;
for i=1:length(data_filter_work_sat)
    if data_filter_work_sat(i) > sat_limit
        data_filter_work_sat(i) = sat_limit;
    end
    if data_filter_work_sat(i) < - sat_limit
        data_filter_work_sat(i) = -sat_limit;
    end
end

subplot(2,2,3);
plot(t_work,data_filter_work_sat);
title('高通滤波后油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');

fft_filter_y_work=fftshift(abs(fft(data_filter_work_sat,len_work)));
subplot(2,2,4);
plot(fft_x_work,fft_filter_y_work);
title('滤波后油量的液压值频谱图');
xlabel('频率f/Hz')
ylabel('频率幅度');

%%
N_special=695500;
%N_special=1.40e5*5;
N_fft=256;
data_special_1min=data(N_special:N_special+N_fft-1);

figure(3);
t_special_1min=N_special/fs:1/fs:(N_special+N_fft-1)/fs;
subplot(2,2,1);
plot(t_special_1min,data_special_1min);
title('1min内油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');

fft_y_special_1min=fftshift(abs(fft(data_special_1min,N_fft)));
fft_x_special_1min=-fs/2:fs/N_fft:fs/2-fs/N_fft;
subplot(2,2,2);
plot(fft_x_special_1min,fft_y_special_1min);
title('1min内油量的液压值频谱图');
xlabel('频率f/Hz')
ylabel('频率幅度');

data_special_1min_mean=mean(data_special_1min);
data_special_1min_sub_mean=data_special_1min-data_special_1min_mean;
subplot(2,2,3);
plot(t_special_1min,data_special_1min_sub_mean);
title('1min内去除直流分量后油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');

fft_y_special_1min_sub_mean=fftshift(abs(fft(data_special_1min_sub_mean,N_fft)));
subplot(2,2,4);
plot(fft_x_special_1min,fft_y_special_1min_sub_mean);
title('1min内去除直流分量后油量的液压值频谱图');
xlabel('频率f/Hz')
ylabel('频率幅度');

%%
%每256点研究最大频率与时间的关系: [1.40e5,1.80e5]s

N_Start=1.40e5*5;
N_package=780;
fm_y_x=zeros(N_package,1);
fm_y_y=zeros(N_package,1);

f_t_work=1.40e5:1/fs:1.40e5+(N_package*N_fft-1)/fs;
f_data_work=data(N_Start:N_Start+N_package*N_fft-1);

figure(4);
subplot(2,2,1);
plot(f_t_work,f_data_work);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');


for i=1:N_package
    Start_valid=N_Start+(i-1)*N_fft;
    End_valid=N_Start+i*N_fft-1;
    fft_valid_data=data(Start_valid:End_valid);
    fft_valid_data_mean=mean(fft_valid_data);
    fft_valid_data_sub_mean=fft_valid_data-fft_valid_data_mean;
    fft_y_valid_data=abs(fft(fft_valid_data_sub_mean,N_fft));
    [max_y,max_x]=max(fft_y_valid_data(1:N_fft/2));
    fm_y_x(i)=(max_x-1)*fs/N_fft;
    fm_y_y(i)=max_y;
end
fm_x=1.40e5:1/fs*N_fft:1.40e5+(N_package-1)/fs*N_fft;
subplot(2,2,2);
plot(fm_x,fm_y_x);
title('每256点最大频谱的频率与时间关系');
xlabel('时间t/s');
ylabel('频率f/Hz');

subplot(2,2,4);
plot(fm_x,fm_y_y);
title('每256点最大频谱的幅度与时间关系');
xlabel('时间t/s');
ylabel('幅度');

%低通滤波处理噪声，前半段存在大部分低频噪声，后半段存在一定量高频噪声
coe_flp_struct=load('filter_coe_flp_fp_0p2_fs_0p8_5Hz.mat');
filter_coe_flp_fp_0p2_fs_0p8_5Hz=coe_flp_struct.filter_coe_flp_fp_0p2_fs_0p8_5Hz;
f_data_work_flp=filter(filter_coe_flp_fp_0p2_fs_0p8_5Hz,1,f_data_work);
subplot(2,2,3);
plot(f_t_work,f_data_work_flp);
title('低通滤波后油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
%%
N_Start_all=1;
N_package_all=floor(len/N_fft);
f_t_work_all=0:1/fs:(N_package_all*N_fft-1)/fs;
f_data_work_all=data(N_Start_all:N_Start_all+N_package_all*N_fft-1);

fm_y_x_all=zeros(N_package_all,1);
fm_y_y_all=zeros(N_package_all,1);

figure(5);
subplot(3,1,1);
plot(f_t_work_all,f_data_work_all);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);


for i=1:N_package_all
    Start_valid=N_Start_all+(i-1)*N_fft;
    End_valid=N_Start_all+i*N_fft-1;
    fft_valid_data=data(Start_valid:End_valid);
    fft_valid_data_mean=mean(fft_valid_data);
    fft_valid_data_sub_mean=fft_valid_data-fft_valid_data_mean;
    fft_y_valid_data=abs(fft(fft_valid_data_sub_mean,N_fft));
    [max_y,max_x]=max(fft_y_valid_data(1:N_fft/2));
    fm_y_x_all(i)=(max_x-1)*fs/N_fft;
    fm_y_y_all(i)=max_y;
end
fm_x_all=0:1/fs*N_fft:(N_package_all-1)/fs*N_fft;
subplot(3,1,2);
plot(fm_x_all,fm_y_x_all);
title('每256点最大频谱的频率与时间关系');
xlabel('时间t/s');
ylabel('频率f/Hz')
axis([0 N_package_all*N_fft/fs -0.2 1]);

subplot(3,1,3);
plot(fm_x_all,fm_y_y_all);
title('每256点最大频谱的幅度与时间关系');
xlabel('时间t/s');
ylabel('幅度');
axis([0 N_package_all*N_fft/fs 0 8000]);

%%
%加油： 额外分析频域曲线 一： [1.373e5,1.376e5] 二： [2.242e5,2.244e5]
N_refule_one = 1.372e5*fs;
N_refule_two = 2.240e5*fs;
N_package_refule = 20;
data_refule_one = data(N_refule_one: N_refule_one + N_package_refule*N_fft-1);
data_refule_two = data(N_refule_two: N_refule_two + N_package_refule*N_fft-1);
t_refule_one = N_refule_one/fs:1/fs:(N_refule_one + N_package_refule*N_fft-1)/fs;
t_refule_two = N_refule_two/fs:1/fs:(N_refule_two + N_package_refule*N_fft-1)/fs;

fm_y_x_refule_one=zeros(N_package_refule,1);
fm_y_y_refule_one=zeros(N_package_refule,1);
fm_y_x_refule_two=zeros(N_package_refule,1);
fm_y_y_refule_two=zeros(N_package_refule,1);

for i=1:N_package_refule
    Start_valid=N_refule_one+(i-1)*N_fft;
    End_valid=N_refule_one+i*N_fft-1;
    fft_valid_data=data(Start_valid:End_valid);
    fft_valid_data_mean=mean(fft_valid_data);
    fft_valid_data_sub_mean=fft_valid_data-fft_valid_data_mean;
    fft_y_valid_data=abs(fft(fft_valid_data_sub_mean,N_fft));
    [max_y,max_x]=max(fft_y_valid_data(1:N_fft/2));
    fm_y_x_refule_one(i)=(max_x-1)*fs/N_fft;
    fm_y_y_refule_one(i)=max_y;
end
fm_x_refule_one=N_refule_one/fs:1/fs*N_fft:N_refule_one/fs + (N_package_refule-1)/fs*N_fft;

for i=1:N_package_refule
    Start_valid=N_refule_two+(i-1)*N_fft;
    End_valid=N_refule_two+i*N_fft-1;
    fft_valid_data=data(Start_valid:End_valid);
    fft_valid_data_mean=mean(fft_valid_data);
    fft_valid_data_sub_mean=fft_valid_data-fft_valid_data_mean;
    fft_y_valid_data=abs(fft(fft_valid_data_sub_mean,N_fft));
    [max_y,max_x]=max(fft_y_valid_data(1:N_fft/2));
    fm_y_x_refule_two(i)=(max_x-1)*fs/N_fft;
    fm_y_y_refule_two(i)=max_y;
end
fm_x_refule_two=N_refule_two/fs:1/fs*N_fft:N_refule_two/fs + (N_package_refule-1)/fs*N_fft;
figure(6);
subplot(3,2,1);
plot(t_refule_one,data_refule_one);
subplot(3,2,2);
plot(t_refule_two,data_refule_two);

subplot(3,2,3);
plot(fm_x_refule_one,fm_y_x_refule_one);
subplot(3,2,4);
plot(fm_x_refule_two,fm_y_x_refule_two);

subplot(3,2,5);
plot(fm_x_refule_one,fm_y_y_refule_one);
subplot(3,2,6);
plot(fm_x_refule_two,fm_y_y_refule_two);

close all
%%
%频域分析工作状态：

%状态：静止 0 ，工作 1，加油 2

%频率量：  累计最大值 5min -> fx
%频谱幅度：均值计算   5min -> fy

%频率门限 -> fx1:0.4 fx2:0.02  频谱幅度门限 -> fy1:400 fy2:5000
%加油状态： fy >= fy2, fx <= fx2
%工作状态:  fy1 <= fy <= fy2, fx <= fx1
%静止状态： fy <= fy1, fx > fx1( 长时间累计，不是必须量)

%门限设置：
fx1_limit=0.4;
fx2_limit=0.02;
fy1_limit=400;
fy2_limit=5000;

%N_package_all
%fm_y_x_all
%fm_y_y_all
%fm_x_all

buffer_len=5;
fx_y_x_buffer=zeros(buffer_len,1);
fx_y_y_buffer=zeros(buffer_len,1);

f_state=zeros(N_package_all,1);

for i=1:N_package_all
    j=mod(i-1,buffer_len)+1;
    fx_y_x_buffer(j)=fm_y_x_all(i);
    fx_y_y_buffer(j)=fm_y_y_all(i);
    fx_y_x_max=max(fx_y_x_buffer);
    fx_y_y_mean=mean(fx_y_y_buffer);
    if (fx_y_y_mean >= fy2_limit) && (fx_y_x_max < fx2_limit )
        f_state(i)=2;
    end
    if (fx_y_y_mean >= fy1_limit) && (fx_y_y_mean < fy2_limit) && (fx_y_x_max < fx1_limit )
        f_state(i)=1;
    end
end

figure(7);

subplot(4,1,1);
plot(f_t_work_all,f_data_work_all);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(4,1,2);
plot(fm_x_all,fm_y_x_all);
title('每256点最大频谱的频率与时间关系');
xlabel('时间t/s');
ylabel('频率f/Hz')
axis([0 N_package_all*N_fft/fs -0.2 1]);

subplot(4,1,3);
plot(fm_x_all,fm_y_y_all);
title('每256点最大频谱的幅度与时间关系');
xlabel('时间t/s');
ylabel('幅度');
axis([0 N_package_all*N_fft/fs 0 8000]);

subplot(4,1,4);
plot(fm_x_all,f_state);
axis([0 N_package_all*N_fft/fs 0 3]);

%%
%均值处理油量
%油量处理根据机械的状态采用简单一阶alpha滤波器： alpha * x(n) + (1-alpha) * x(n-1)
%静止： alpha = 0.25
%工作+加油： alpha = 0.5
alpha0=0.25;
alpha1=0.5;
alpha2=0.5;

%N_package_all
%fm_y_x_all
%fm_y_y_all
%fm_x_all
%f_state: 0 1 2

fy_refule_mean=zeros(N_package_all,1);
fy_refule_mean_alpha_flt=zeros(N_package_all,1);
fy_refule_mean_alpha_flt_pro=zeros(N_package_all,1);
fy_refule_mean_alpha_flt_pro_teminal=zeros(N_package_all,1);

for i=1:N_package_all
    Start_valid=N_Start_all+(i-1)*N_fft;
    End_valid=N_Start_all+i*N_fft-1;
    fft_valid_data=data(Start_valid:End_valid);
    fy_refule_mean(i)=mean(fft_valid_data);
end

figure(8);
subplot(5,1,1);
plot(f_t_work_all,f_data_work_all);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);


subplot(5,1,2);
plot(fm_x_all,fy_refule_mean);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);


for i=1:N_package_all
    if i == 1
        fy_refule_mean_alpha_flt(i) = fy_refule_mean(i);
    else
        if f_state(i) == 0
            fy_refule_mean_alpha_flt(i) = fy_refule_mean(i) * alpha0 + fy_refule_mean(i-1) * (1 - alpha0);
        elseif f_state(i) == 1
            fy_refule_mean_alpha_flt(i) = fy_refule_mean(i) * alpha1 + fy_refule_mean(i-1) * (1 - alpha1);
        elseif f_state(i) == 2
            fy_refule_mean_alpha_flt(i) = fy_refule_mean(i) * alpha2 + fy_refule_mean(i-1) * (1 - alpha2);
        end
    end 
end



subplot(5,1,3);
plot(fm_x_all,fy_refule_mean_alpha_flt);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

for i=1:N_package_all
    if i <= 1
        fy_refule_mean_alpha_flt_pro(i) = fy_refule_mean(i);
    else
        if f_state(i) == 0
            fy_refule_mean_alpha_flt_pro(i) = fy_refule_mean(i) * alpha0 + fy_refule_mean_alpha_flt_pro(i-1) * (1 - alpha0);
        else
            fy_refule_mean_alpha_flt_pro(i) = fy_refule_mean(i) * alpha1 + fy_refule_mean_alpha_flt_pro(i-1) * (1 - alpha1);
        end
    end 
end

subplot(5,1,4);
plot(fm_x_all,fy_refule_mean_alpha_flt_pro);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

%filter pro process: 5 order 低通滤波
factor = 3.65;
coe0=0.003 * factor;
coe1=0.065 * factor;
coe2=0.136 * factor;
for i=1:N_package_all
    if i <= 1 
        fy_refule_mean_alpha_flt_pro_teminal(i) = fy_refule_mean_alpha_flt_pro(i);
    elseif i <= 4
        fy_refule_mean_alpha_flt_pro_teminal(i) = alpha0 * fy_refule_mean_alpha_flt_pro(i) + (1-alpha0) * fy_refule_mean_alpha_flt_pro(i-1);
    else
        fy_refule_mean_alpha_flt_pro_teminal(i) = (fy_refule_mean_alpha_flt_pro(i) + fy_refule_mean_alpha_flt_pro(i-4))*coe0 + (fy_refule_mean_alpha_flt_pro(i-1) + fy_refule_mean_alpha_flt_pro(i-3))*coe1 + fy_refule_mean_alpha_flt_pro(i-2)*coe2;
    end
end

subplot(5,1,5);
plot(fm_x_all,fy_refule_mean_alpha_flt_pro_teminal);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

%%
%f_state: 0 1 2
%fy_refule_mean_alpha_flt_pro
%N_package_all
%deta_t=N_fft/fs
%fy_refule_terminal

fy_refule_terminal=zeros(N_package_all,1);
n_piece = 0;
n_start = zeros(N_package_all,1);
n_len = ones(N_package_all,1);
deta_t=N_fft/fs;
X=fm_x_all';
Y=fy_refule_mean_alpha_flt_pro;

fn_x=zeros(N_package_all,1);
fn_y=zeros(N_package_all,1);
fn_z=zeros(N_package_all,1);
fn_z_plus=zeros(N_package_all,1);

for i=1:N_package_all
    if i == 1
        n_piece = 1;
        n_start(n_piece) = 1;
        n_len(n_piece) = 1;
    else
        if f_state(i) == f_state(i-1)
            n_len(n_piece) = n_len(n_piece) + 1 ;
        else
            n_piece = n_piece + 1;
            n_start(n_piece) = i;
        end
    end 
end

for i=1:n_piece
    fn_x=X(n_start(i):n_start(i) + n_len(i) - 1);
    fn_y=Y(n_start(i):n_start(i) + n_len(i) - 1);
    if n_len(i) == 1
        coe_ab(1) = 0;
        coe_ab(2) = fn_y(1);
    else
        coe_ab = polyfit(fn_x(1: n_len(i)), fn_y(1:n_len(i)), 1);
    end
    for j=0:n_len(i)-1
        fn_z(n_start(i)+j) = coe_ab(1)*X(n_start(i)+j) + coe_ab(2);
    end  
end

fn_z_plus=fn_z;

fn_z_extend_time1=30; fn_z_extend_coe1=6; %状态持续>30min
fn_z_extend_time2=10; fn_z_extend_coe2=3; %5min<状态持续<30min
fn_z_extend_coe3=2; %5min<状态持续
fn_z_extend_coe=2;
n_len_real=0;

for i=3:n_piece-2
    if n_len(i) >= fn_z_extend_time1
        n_len_real= n_len(i) + 2 * fn_z_extend_coe1;
        fn_x=X(n_start(i)-fn_z_extend_coe1:n_start(i) + n_len(i) - 1 + fn_z_extend_coe1);
        fn_y=Y(n_start(i)-fn_z_extend_coe1:n_start(i) + n_len(i) - 1 + fn_z_extend_coe1);
    elseif n_len(i) <= fn_z_extend_time2
        n_len_real= n_len(i) + 2 * fn_z_extend_coe2;
        fn_x=X(n_start(i)-fn_z_extend_coe2:n_start(i) + n_len(i) - 1 + fn_z_extend_coe2);
        fn_y=Y(n_start(i)-fn_z_extend_coe2:n_start(i) + n_len(i) - 1 + fn_z_extend_coe2);
    else
        n_len_real= n_len(i) + 2 * fn_z_extend_coe3;
        fn_x=X(n_start(i)-fn_z_extend_coe3:n_start(i) + n_len(i) - 1 + fn_z_extend_coe3);
        fn_y=Y(n_start(i)-fn_z_extend_coe3:n_start(i) + n_len(i) - 1 + fn_z_extend_coe3);
    end
    if n_len(i) == 1
        coe_ab(1) = 0;
        coe_ab(2) = fn_y(1);
    else
        coe_ab = polyfit(fn_x(1: n_len_real), fn_y(1:n_len_real), 1);
    end
    for j=0:n_len(i)-1
        fn_z_plus(n_start(i)+j) = coe_ab(1)*X(n_start(i)+j) + coe_ab(2);
    end  
%     for j=-fn_z_extend_coe:n_len(i)-1+fn_z_extend_coe
%         if j < fn_z_extend_coe
%             fn_z_plus(n_start(i)+j) = (fn_z_plus(n_start(i)+j) + coe_ab(1)*X(n_start(i)+j) + coe_ab(2))/2;
%         else
%             fn_z_plus(n_start(i)+j) = coe_ab(1)*X(n_start(i)+j) + coe_ab(2);
%         end
%     end  
end

figure (9);
subplot(5,1,1);
plot(f_t_work_all,f_data_work_all);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(5,1,2);
plot(fm_x_all,fy_refule_mean);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(5,1,3);
plot(fm_x_all,fy_refule_mean_alpha_flt_pro);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(5,1,4);
plot(fm_x_all,fn_z);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(5,1,5);
plot(fm_x_all,fn_z_plus);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

% subplot(5,1,5);
% plot(fm_x_all,f_state);
% axis([0 N_package_all*N_fft/fs 0 3]);

%%
%process f_state change within 5min
% n_piece
% n_start 
% n_len 

f_state_unstable_limit = 5;
f_state_unstable_width = 10;

% for i=1:n_piece
%     if (n_len(i) <= f_state_unstable_limit) && (f_state(n_start(i)) ~= 2)
%         sum = 0;
%         for j=1:f_state_unstable_width
%             sum=sum + f_state(n_start(i)-j) + f_state(n_start(i)+n_len(i)-1+j);
%         end
%         if sum == 0 || sum == 2 * f_state_unstable_width
%         end
%     end  
% end


figure(10)

subplot(2,1,1);
plot(f_t_work_all,f_data_work_all);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(2,1,2);
plot(fm_x_all,fn_z_plus);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

%%
factor=1;
coef18=0.0097*factor;
coef27=0.0405*factor;
coef36=0.0885*factor;
coef45=0.1268*factor;

f_out_terminal=fn_z_plus;

for i=8:N_package_all
    if f_state ~= 2
        f_out_terminal(i) = coef18 * (fn_z_plus(i)+fn_z_plus(i-7)) + coef27 * (fn_z_plus(i-1)+fn_z_plus(i-6)) + coef36 * (fn_z_plus(i-2)+fn_z_plus(i-5)) + + coef45 * (fn_z_plus(i-3)+fn_z_plus(i-4));
    end
end

figure(11)

subplot(3,1,1);
plot(f_t_work_all,f_data_work_all);
title('机械工作阶段油量的液压值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(3,1,2);
plot(fm_x_all,fn_z_plus);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);

subplot(3,1,3);
plot(fm_x_all,f_out_terminal);
title('机械工作阶段油量的液压值均值和时间关系');
xlabel('时间t/s')
ylabel('油量的液压值');
axis([0 N_package_all*N_fft/fs 1200 2200]);
