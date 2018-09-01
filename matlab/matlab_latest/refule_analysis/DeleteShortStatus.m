function [y]=DeleteShortStatus(x,n,pos_array,len_array,threshold_unstable,threshold_stable, status_refule, status_steal)
%�ú���ɾ���ź��в��ȶ���״̬
%ɾ������: �Ǽ���״̬�г��̵�ʱ��Σ� a. ��ǰ����ʱ��С��5min,ǰһ��״̬����ʱ�����15min  b. ��ǰ����ʱ��С�ڵ���2min,ǰ������״̬���ڵ���5min
%����ı�����ɾ�����ȶ�״̬�������ź�
%���룺x -> input signal
%���룺n -> input signal status piece number
%���룺pos_array -> start position array of every status
%���룺len_array -> length array of every continue status
%���룺threshold_a_unstable -> a type unstable threshold
%���룺threshold_a_stable -> a type stable threshold
%���룺threshold_b_unstable -> b type unstable threshold
%���룺threshold_b_stable -> b type stable threshold
%����� y -> input signal after remove unstable status

y=x;

for i=2:n-1
    if (len_array(i) <= threshold_unstable) && (len_array(i-1) >= threshold_stable) && (len_array(i+1) >= threshold_stable) && (y(pos_array(i)) ~= status_refule) && (y(pos_array(i)) ~= status_steal)
        for j=0:len_array(i)-1
            y(pos_array(i)+j)=y(pos_array(i)-1);
        end
        len_array(i)=len_array(i)+len_array(i-1);
        if y(pos_array(i)) == y(pos_array(i+1))
            len_array(i+1)=len_array(i+1) + len_array(i);
        end
    end
end