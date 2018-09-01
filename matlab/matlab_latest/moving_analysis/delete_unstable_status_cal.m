function [y]=delete_unstable_status_cal(x, x_piece_num, pos_array, len_array, threshold_unstable, threshold_stable)
%�ú���ɾ���ź��в��ȶ���״̬
%ɾ������: �Ǽ���״̬�г��̵�ʱ��Σ� ��ǰ����ʱ��С�ڵ���3min,ǰ������״̬���ڵ���6min
%����ı�����ɾ�����ȶ�״̬�������ź�
%���룺x -> input signal
%���룺x_piece_num -> input signal status piece number
%���룺pos_array -> start position array of every status
%���룺len_array -> length array of every continue status
%���룺threshold_unstable -> unstable threshold
%���룺threshold_stable   -> stable threshold
%����� y -> input signal after remove unstable status

y=x;

for i=2:x_piece_num-1
    if ( (len_array(i) <= threshold_unstable) && (len_array(i-1) >= threshold_stable) && (len_array(i+1) >= threshold_stable) ) 
        for j=0:len_array(i)-1
            y(pos_array(i)+j)=y(pos_array(i)-1);
        end
        pos_array(i)+j
%         len_array(i)=len_array(i)+len_array(i-1);
%         if y (pos_array(i)) == y (pos_array(i+1))
%             len_array(i+1)=len_array(i+1) + len_array(i);
%         end
    end
end

end