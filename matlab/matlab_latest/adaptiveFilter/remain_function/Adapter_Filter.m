%% clear screen
close all
clear
clc

%% 
%signal generator model generate
data_select_idx = 1;
windRadius=14;
weight_len = 7;
weight_coe = 50;
threshold = 0.010;
threshold_unstable = 1;
threshold_stable = 2;
threshold_unstable_len = 5;

if data_select_idx == 1
    [y,x] = signalGenerator();
elseif data_select_idx == 2
    alphabet = [0 1]; prob = [0.7 0.3];
    y=randsrc(500,1,[alphabet; prob]);
    x=(0:1:length(y)-1)';
end

figure(1)
plot(x,y);
axis ([0 max(x) -0.5 1.5]);

%% adaptive partial Filter Process
[y_pro] = slideWindAdaptiveFilter(y,windRadius,weight_len,weight_coe);
y_post_pro = limitAmpFilter(y_pro,threshold);

[number_piece_post,pos_array_post,len_array_post]=segmentation_cal_step_two(y_post_pro,length(y_pro));
[y_pro_post]=delete_unstable_status_cal(y_post_pro, number_piece_post, pos_array_post, len_array_post, threshold_unstable, threshold_stable);

[number_piece_post2,pos_array_post2,len_array_post2]=segmentation_cal_step_two(y_pro_post,length(y_pro));
y_pro_post2 = y_pro_post;
for i=1:number_piece_post2
    if (y_pro_post(pos_array_post2(i))) == 1 && (len_array_post2(i) < threshold_unstable_len)
        for j=1:len_array_post2(i)
            y_pro_post2(pos_array_post2(i)+j-1) = 0;
        end
    end
end

figure(2)
subplot(2,1,1);
plot(x,y);
axis ([0 max(x) -0.2 1.2]);
subplot(2,1,2);
plot(x,y_pro);

figure(3)

plot(x,y);
hold on 
plot(x,y_pro,'r');
axis ([0 max(x) -0.2 1.2]);


figure(4)
plot(x,y);
hold on 
plot(x,y_pro,'r');
hold on 
plot(x,y_post_pro,'g');
axis ([0 max(x) -0.2 1.2]);


figure(5)
plot(x,y);
hold on 
plot(x,1.1 * y_pro_post,'r');
axis ([0 max(x) -0.2 1.2]);

figure(6)
plot(x,y);
hold on 
plot(x,1.1 * y_pro_post2,'r');
axis ([0 max(x) -0.2 1.2]);




