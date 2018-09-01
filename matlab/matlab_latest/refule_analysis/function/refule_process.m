clc;
clear;
close all;
%%
fs_org=5;

data_20180730=load('ԭʼ�ɼ�����\��λ�������ֳ���������_20180730.txt');
data_20180801=load('ԭʼ�ɼ�����\��λ�������ֳ���������_20180801.txt');
data_20180806=load('ԭʼ�ɼ�����\�Ӵ����̶�����_20180806.txt');
len_1=length(data_20180730);
len_2=length(data_20180801);
len_3=length(data_20180806);
t1=0:1/fs_org:(len_1-1)/fs_org;
t2=0:1/fs_org:(len_2-1)/fs_org;
t3=0:1/fs_org:(len_3-1)/fs_org;

figure(1)
subplot(3,1,1);
plot(t1',data_20180730);
title('20180730����Һѹֵ��ʱ������');
xlabel('ʱ��t/s');
ylabel('����Һѹֵ')

subplot(3,1,2);
plot(t2',data_20180801);
title('20180801����Һѹֵ��ʱ������');
xlabel('ʱ��t/s');
ylabel('����Һѹֵ')

subplot(3,1,3);
plot(t3',data_20180806);
title('20180806����Һѹֵ��ʱ������');
xlabel('ʱ��t/s');
ylabel('����Һѹֵ');
% axis([0 8.3e4 1000 2000]);

%���۹۲죺 
% 20180730 ���߰������
% 20180801 ���߰���1.4e5s֮���ٺ���

%���ߺ����ʱ���ѡȡ��
% 20180730 -> [0, 2.255e5]s 
% 20180801 -> [0, 1.415e5]s 

%%
%�źŴ�����
%����ѡȡ��fs=1Hz, 1min(60)����һ��������ָ�뷽��

%Ƕ��ʽ����:
%step1: ����1min����Һѹֵ��ֵ������
%step2: ���ݷ���ֵ���÷�����ֵ�����жϻ�е��״̬ 0:��ֹ 1������������ 2������
%step3: ���ݻ�е��״̬������Һѹֵ��ֵ��alpha�˲�
%step4: ��step2��е״̬(2bit)��step3ʵʱ����Һѹֵ��8bit���ϴ���������
%����������:
%step5: ����step3״̬���ݶ�ʵʱ����Һѹֵ���зֶ�������ϣ���С����ֱ����ϣ�
%step6: ���ڷֶ���Ϻ�Ĳ�����������ֵ�����˲�����

%%
%step1: �źų�ȡ����ֵ���㣬�������
first_start_sample_random_array = random('Poisson',1:3,1,3);  
%use to provide random data for first sample postion;
first_start_index = mod(first_start_sample_random_array(2)+1,5) + 1;  
%use to adjust first sample position to cover sample error
t1_end=2.255e5; t2_end=1.415e5;t3_end=8.3e4;
%���ߺ����ʱ���ѡȡ��
% 20180730 -> [0, 2.255e5]s 
% 20180801 -> [0, 1.415e5]s 

%ѡȡ20180730�Ĳ�������
data_sel=data_20180730;
t_end_sel=t1_end;

% %ѡȡ20180801�Ĳ�������
% data_sel=data_20180801;
% t_end_sel=t2_end;

% %ѡȡ20180806�Ĳ�������
% data_sel=data_20180806;
% t_end_sel=t3_end;

%�źų�ȡ�����ȡ�Ĳ����������źŵĳ���
fs=1/60; %�źų�ȡƵ��
fs_step=fs_org/fs; %�źų�ȡ����
data_num_fs=floor(t_end_sel*fs); %�źų�ȡ���źŵĳ���
data_down_sample=zeros(data_num_fs,1);%��ȡ�źŵĶ���

%��ȡ�źŵ�ʱ�����ȡ��ѹֵ����
t_x_down_sample=0:1/fs:(data_num_fs-1)/fs;
for i=1:data_num_fs
    j=(i-1)*fs_step + first_start_index;
    data_down_sample(i)=data_sel(j);
end

% fs_mean=1/60; %�����ֵ��Ƶ�� 1min
% N_fs_mean=(1/fs_mean)/(1/fs);
% number_mean=floor(t_end_sel*fs_mean); %��ֵ������
% data_mean=zeros(number_mean,1); %��ֵ�źŵĶ���
% data_variance=zeros(number_mean,1); %�����źŵĶ���
% 
% %��ֵ�źŵ�ʱ����ѹֵ����
% t_x_data_mean=0:1/fs_mean/60:(number_mean-1)/fs_mean/60; %������
% for i=1:number_mean
%     refule_variance_once=0;
%     ds_idx=1+(i-1)*N_fs_mean;
%     de_idx=i*N_fs_mean;
%     data_fetch_mean_once=data_down_sample(ds_idx:de_idx);
%     refule_mean_once=mean(data_fetch_mean_once);
%     for j=1:N_fs_mean
%         refule_variance_once = refule_variance_once + (data_fetch_mean_once(j)-refule_mean_once)*(data_fetch_mean_once(j)-refule_mean_once);
%     end
%     data_mean(i)=refule_mean_once;
%     data_variance(i)=sqrt(refule_variance_once/N_fs_mean);
% end
% 
% 
% figure(2)
% %��ȡ�ź�ʱ����
% subplot(4,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % %��ֵ�ź�ʱ����
% % subplot(4,1,2);
% % plot(t_x_data_mean,data_mean);
% % title('1min����Һѹֵ��ֵ��ʱ������');
% % xlabel('ʱ��t/min');
% % ylabel('����Һѹֵ');
% % axis([0 3760 1000 2200]);
% 
% %��ֵ�ź�ʱ����
% subplot(4,1,3);
% plot(t_x_data_mean,data_variance);
% % title('1min����Һѹֵ��׼����ʱ������');
% % xlabel('ʱ��t/min');
% % ylabel('����Һѹֵ');
% % axis([0 3760 0 60]);
% hold on
% 
% %%
% %step2: �����ж�״̬ 
% %�������ã� 5min��һ�ξ�ֵ ��ֹ(0):[0,5]  �˶�(1):[5:35]-> 20  ����(2):[45:55] -> 50
% %����������������Χ��[5-25] [10-35] => [5-35] ��ֵ���¿���[15-25]
% %���������ļ���ֵ�㣺47.5  żȻ���ֵ���
% %���ͷ�Χ��[46,53] [52,56] => [45,55] -> 50 5min��������ֵ���޴���400
% %�жϼ����빤������ ���ͣ���������>=45 ���� 5min��ֵ > 29  �������������޾�ֵ > 5 ��ֹ��others 
% 
% %���㣺 in: ����  mid: ���� + ���� 5min ��ֵ��overlap: 4�� out: ����״̬
% %������ ����5min overlap ��ֵ���㺯��
% %in: data_variance
% %mid: data_variance_mean
% %out�� machine_status
% 
% fs_variance_mean=1/60/5; %�����ֵ��Ƶ��
% number_overlap=fs_mean/fs_variance_mean; %�����ֵ�ĵ���
% data_variance_mean=overlap_mean_cal(data_variance,number_overlap);%�����ֵ����
% machine_status=zeros(number_mean,1); %machine_status defination
% 
% plot(t_x_data_mean,data_variance_mean,'r')
% title('1min����Һѹֵ��׼����ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 0 60]);
% 
% %�о����޶���
% refule_variance_limit = 50;
% refule_variance_mean_limit = 28;
% work_variance_mean_limit = 3.5;
% 
% 
% %machine_status cal
% for i=1:number_mean
%     if (data_variance(i) >= refule_variance_limit) && (data_variance_mean(i) > refule_variance_mean_limit)
%         machine_status(i) = 2;
%     elseif data_variance_mean(i) >= work_variance_mean_limit
%         machine_status(i) = 1;
%     else
%         machine_status(i) = 0;
%     end
% end
% 
% subplot(4,1,4);
% plot(t_x_data_mean,machine_status,'r')
% title('1min��е����״̬��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����״̬');
% axis([0 3760 -0.5 2.5]);
% %%
% %step3: ���ݻ�е��״̬������Һѹֵ��ֵ��alpha�˲�
% 
% %��ֹ�� alpha = 0.25
% %����+���ͣ� alpha = 0.5
% %���ͣ� data_mean(i)
% %������ 1/6 data_mean(i)+ 1/3 data_mean(i-1) + 1/3 data_mean(i-2) + 1/6 data(i-2)
% alpha0=1/8;
% alpha1=3/8;
% data_mean_alpha=zeros(number_mean,1);
% 
for i=1:number_mean
    if (i <= 3) || (machine_status(i) == 2) || (machine_status(i-1) == 2) ||  (machine_status(i-2) == 2)
        data_mean_alpha(i) = data_mean(i);
    else
%         if machine_status(i) == 2
%             data_mean_alpha(i) = data_mean(i) * alpha0 + data_mean(i-1) * (1 - alpha0);
%         elseif machine_status(i) == 1
%             data_mean_alpha(i) = data_mean(i) * alpha1 + data_mean(i-1) * (1 - alpha1);
%         elseif machine_status(i) == 2
%             data_mean_alpha(i) = data_mean(i) * alpha2 + data_mean(i-1) * (1 - alpha2);
%         end
        data_mean_alpha(i) = alpha0 * (data_mean(i) + data_mean(i-3)) + alpha1 * (data_mean(i-1) + data_mean(i-2));
    end 
end
% 
% % ��ֵ�ź�ʱ����
% subplot(4,1,2);
% plot(t_x_data_mean,data_mean);
% hold on
% plot(t_x_data_mean,data_mean_alpha,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% %%
% %step4: ��step2��е״̬(2bit)��step3ʵʱ����Һѹֵ��8bit���ϴ���������
% %����һ����number_mean * 2������
% data_info=[data_mean_alpha,machine_status];
% upload_refule=data_info(:,1);
% upload_status=data_info(:,2);
% 
% %%
% %����˴���
% %step5: ����step3״̬���ݶ�ʵʱ����Һѹֵ���зֶ�������ϣ���С����ֱ����ϣ�
% %step6: ���ڷֶ���Ϻ�Ĳ�����������ֵ�����˲�����
% 
% %��е״̬���� 
% %a. ����״̬��ʱ2min   
% %b. �Ǽ���״̬����ʱ��С��5min�Ĵ���
% 
% %a: in: upload_status (number_mean) out: status_pre_pro
% status_pre_cl_shift_1=circshift(upload_status,-1); %ѭ������һ������
% status_pre_cr_shift_1=circshift(upload_status,1);  %ѭ������һ������
% status_pre_pro=zeros(number_mean,1);
% 
% for i=1:number_mean
%     if  (upload_status(i) == 2) || (status_pre_cl_shift_1(i) == 2) || (status_pre_cr_shift_1(i) == 2)
%         status_pre_pro(i) = 2;
%     else
%         status_pre_pro(i) = upload_status(i);
%     end
% end
% 
% %b: in: status_pre_pro (number_mean)  out: status_post_pro
% 
% %������״̬�ֶ�ͳ�ƣ���������ÿ����㣬ÿ�γ���
% [status_piece,status_start,status_len]=segmentation_cal(status_pre_pro,number_mean);
% 
% %����Ǽ���״̬�г��̵�ʱ��Σ� a. ��ǰ����ʱ��С��5min,ǰһ��״̬����ʱ�����15min  b��ǰ����ʱ��С��2min,ǰ������״̬���ڵ���5min
% threshold_a_unstable=5;
% threshold_a_stable=15;
% threshold_b_unstable=2;
% threshold_b_stable=5;
% [status_mid_pro]=delete_unstable_status_cal(status_pre_pro,status_piece,status_start,status_len,threshold_a_unstable,threshold_a_stable,threshold_b_unstable,threshold_b_stable);
% 
% %����Ǽ���״̬�н϶̵�ʱ��Σ� �� ������ϵ�׼����
% %c. ������>=30min��,��Ϣ��< 10min��,������>=30min����;��ͣ�ٻ������źŵ�̧�ߣ���Ϣ->����  
% %d. ��Ϣ��>=30min��,������< 10min��,��Ϣ��>=30min����;�Ĺ����������źŵĶ���������->��Ϣ 
% threshold_prepare_match_curve_min=10;
% threshold_prepare_match_curve_max=30;
% threshold_prepare_match_curve_status=2;
% 
% [status_piece_mid,status_start_mid,status_len_mid]=segmentation_cal(status_mid_pro,number_mean);
% [status_normal_pro]=delete_short_unstable_status_cal(status_mid_pro,status_piece_mid,status_start_mid,status_len_mid,threshold_prepare_match_curve_min,threshold_prepare_match_curve_max,threshold_prepare_match_curve_status);
% 
% 
% %������״̬���ηֶ�ͳ�ƣ���������ÿ����㣬ÿ�γ���
% [status_piece_post,status_start_post,status_len_post]=segmentation_cal(status_normal_pro,number_mean);
% 
% figure(3)
% subplot(3,1,1)
% plot(t_x_data_mean,machine_status,'b');
% title('ԭʼ�Ļ�е����״̬��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����״̬');
% axis([0 3760 -0.5 2.5]);
% 
% subplot(3,1,2)
% plot(t_x_data_mean,status_pre_pro,'r');
% title('Ԥ����Ļ�е����״̬��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����״̬');
% axis([0 3760 -0.5 2.5]);
% 
% subplot(3,1,3)
% plot(t_x_data_mean,status_normal_pro,'r');
% title('����Ļ�е����״̬��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����״̬');
% axis([0 3760 -0.5 2.5]);
% 
% figure(4)
% %��ȡ�ź�ʱ����
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% subplot(3,1,3)
% plot(t_x_data_mean,status_normal_pro,'r');
% title('����Ļ�е����״̬��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����״̬');
% axis([0 3760 -0.5 2.5]);
% 
%�������ǰ20���Ӳ��ȶ�״̬��(��������ĸ�������)
%�����ж� ǰ[-20 -10]��ֵ ǰ[-10,0]�Ƿ�����
%in: [data_mean_alpha,status_normal_pro,number_mean] 
%substep1: out: flag_start_pos_array,flag_stop_pos_array, flag_times
flag_status=2;
flag_times=0;
flag_start_pos_array=zeros(number_mean,1);
flag_stop_pos_array=zeros(number_mean,1);

for i=2:number_mean-1
    if (status_normal_pro(i) == flag_status) && (status_normal_pro(i-1) ~= flag_status)
        flag_times = flag_times + 1;
        flag_start_pos_array(flag_times)=i;
    end
    if (status_normal_pro(i) == flag_status) && (status_normal_pro(i+1) ~= flag_status)
        flag_stop_pos_array(flag_times)=i;
    end
end

%mean->[-20,-11],variacne->[-10,-1]��������������Ϊ2.00
flag_pro_len=10; 
flag_variance_limit=2;
flag_search_time_variance_range=flag_pro_len;
flag_search_time_mean_range=2*flag_pro_len;
flag_pos_mean_variance_array = zeros(flag_times,3);
data_refule_pre_pro=upload_refule;


for i=1:flag_times
    flag_signal_mean=upload_refule(flag_start_pos_array(i)-flag_search_time_mean_range:flag_start_pos_array(i)-flag_search_time_variance_range+1);
    flag_signal_varinace=upload_refule(flag_start_pos_array(i)-flag_search_time_variance_range:flag_start_pos_array(i)-1);
    flag_pos_mean_variance_array(i,1)=flag_start_pos_array(i);
    flag_pos_mean_variance_array(i,2)=mean(flag_signal_mean);
    for j=1:flag_pro_len
        flag_pos_mean_variance_array(i,3)=flag_pos_mean_variance_array(i,3) + (flag_signal_varinace(i)-flag_pos_mean_variance_array(i,2))*(flag_signal_varinace(i)-flag_pos_mean_variance_array(i,2));
    end
    flag_pos_mean_variance_array(i,3) = sqrt(flag_pos_mean_variance_array(i,3)/flag_pro_len);
    
    if flag_pos_mean_variance_array(i,3) > flag_variance_limit
        for j=0:flag_pro_len
            data_refule_pre_pro(flag_pos_mean_variance_array(i,1) - j)=flag_pos_mean_variance_array(i,2);
        end
    end
end
% 
% figure(5)
% %��ȡ�ź�ʱ����
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,3);
% plot(t_x_data_mean,data_refule_pre_pro,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% %������>30min��->��ֹ(>1h): ���������Լ������������µ�Һѹֵ�ı仯
% % [status_piece_post,status_start_post,status_len_post]
% %��е������״̬
% status_quiet=0;
% status_move=1;
% status_refule=2;
% refule_mid_pro_move_threshold=10;
% refule_mid_pro_quiet_threshold=70;
% refule_mid_pro_quiet_remove_threshold=50;
% 
% data_refule_mid_pro=amend_move_to_quiet_cal(data_refule_pre_pro,status_normal_pro,status_piece_post,status_start_post,status_len_post,refule_mid_pro_quiet_threshold,refule_mid_pro_quiet_remove_threshold,refule_mid_pro_move_threshold,status_quiet,status_move);
% 
% figure(6)
% subplot(2,1,1)
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% subplot(2,1,2)
% plot(t_x_data_mean,data_refule_pre_pro,'b');
% hold on
% plot(t_x_data_mean,data_refule_mid_pro,'r');
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% %�������
% data_refule_curve_match=data_refule_mid_pro;
% for i=1:status_piece_post
%     if status_normal_pro(status_start_post(i)) ~= status_refule
%         fn_x=t_x_data_mean(status_start_post(i):status_start_post(i) + status_len_post(i) - 1)';
%         fn_y=data_refule_curve_match(status_start_post(i):status_start_post(i) + status_len_post(i) - 1);
%         if status_len_post(i) == 1
%             coe_ab(1) = 0;
%             coe_ab(2) = fn_y(1);
%         else
%             coe_ab = polyfit(fn_x(1: status_len_post(i)), fn_y(1:status_len_post(i)), 1);
% %             if status_normal_pro(status_start_post(i)) == status_move
% %             end
%         end
%         for j=1:status_len_post(i)
%             data_refule_curve_match(status_start_post(i)+j-1) = coe_ab(1)*fn_x(j) + coe_ab(2);
%         end  
%     end
% end
% 
% figure (7)
% %��ȡ�ź�ʱ����
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'b');
% hold on 
% plot(t_x_data_mean,data_refule_curve_match,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,3);
% plot(t_x_data_mean,upload_status,'b');
% hold on 
% plot(t_x_data_mean,status_normal_pro,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 -0.5 2.5]);
% 
% 
% % ��������������չ��
% % ��������� ״̬�仯��ǰ����״̬ʱ�䳤��30min�� + �仯�ڵ���ȴ�10
% 
% %���������ͻ��ڵ��Ƭ�Σ�
% threshold_status_continue_time_range=30;
% threshold_refule_amplitude_vary_range=10;
% threshold_refule_match_time_wind=30;
% data_refule_curve_match_twice=data_refule_curve_match;
% 
% for i=2:status_piece_post
%     if (status_len_post(i) >= threshold_status_continue_time_range) && (status_len_post(i-1) >= threshold_status_continue_time_range) && (abs(data_refule_curve_match(status_start_post(i))-data_refule_curve_match(status_start_post(i)-1)) > threshold_refule_amplitude_vary_range)
%         if status_normal_pro(status_start_post(i)) == status_move
%             extend_directory = 1; %����չ
%         else
%             extend_directory = 0; %����չ
%         end
%         if extend_directory ==1 %������չ
%             for j=0:threshold_refule_match_time_wind-1
%                 if data_refule_curve_match_twice(status_start_post(i)+j) > data_refule_curve_match_twice(status_start_post(i)-1)
%                     data_refule_curve_match_twice(status_start_post(i)+j)= data_refule_curve_match_twice(status_start_post(i)-1);
%                 end
%             end
%         else %������չ
%             for j=0:threshold_refule_match_time_wind-1
%                 if data_refule_curve_match_twice(status_start_post(i)) > data_refule_curve_match_twice(status_start_post(i)-j-1)
%                     data_refule_curve_match_twice(status_start_post(i)-j-1)= data_refule_curve_match_twice(status_start_post(i));
%                 end
%             end
%         end
%     end
% end
% 
% figure (8)
% %��ȡ�ź�ʱ����
% subplot(2,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(2,1,2);
% plot(t_x_data_mean,data_refule_curve_match,'b');
% hold on 
% plot(t_x_data_mean,data_refule_curve_match_twice,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% figure (9)
% %��ȡ�ź�ʱ����
% subplot(3,1,1);
% plot(t_x_down_sample/60,data_down_sample);
% title('����Һѹֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,2);
% plot(t_x_data_mean,upload_refule,'b');
% hold on
% plot(t_x_data_mean,data_refule_curve_match_twice,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 1000 2200]);
% 
% % ��ֵ�ź�ʱ����
% subplot(3,1,3);
% plot(t_x_data_mean,upload_status,'b');
% hold on 
% plot(t_x_data_mean,status_normal_pro,'r');
% title('1min����Һѹֵ��ֵ��ʱ������');
% xlabel('ʱ��t/min');
% ylabel('����Һѹֵ');
% axis([0 3760 -0.5 2.5]);



