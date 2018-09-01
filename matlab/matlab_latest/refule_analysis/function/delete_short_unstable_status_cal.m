function [y]=delete_short_unstable_status_cal(x,n,pos_array,len_array,threshold_unstable,threshold_stable,status)
%�ú���ɾ���ź��в��ȶ���״̬
%ɾ������: �Ǽ���״̬�г��̵�ʱ��Σ� a. ��ǰ����ʱ��С��5min,ǰһ��״̬����ʱ�����15min  b. ��ǰ����ʱ��С�ڵ���2min,ǰ������״̬���ڵ���5min
%����ı�����ɾ�����ȶ�״̬�������ź�
%���룺x -> input signal
%���룺n -> input signal status piece number
%���룺pos_array -> start position array of every status
%���룺len_array -> length array of every continue status
%���룺threshold_unstable -> a type unstable threshold
%���룺threshold_stable -> a type stable threshold
%���룺status -> refule status
%����� y -> input signal after remove short unstable status

y=x;

for i=2:n-1
    if ( (y(pos_array(i)) ~= status) && (len_array(i) < threshold_unstable) &&  (len_array(i-1) >= threshold_stable) && (len_array(i+1) >= threshold_stable) )
        for j=0:len_array(i)-1
            y(pos_array(i)+j)=y(pos_array(i)-1);
        end
        len_array(i)=len_array(i)+len_array(i-1);
        if y (pos_array(i)) == y (pos_array(i+1))
            len_array(i+1)=len_array(i+1) + len_array(i);
        end
    end
end