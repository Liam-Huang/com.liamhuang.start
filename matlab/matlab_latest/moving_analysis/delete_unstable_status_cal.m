function [y]=delete_unstable_status_cal(x, x_piece_num, pos_array, len_array, threshold_unstable, threshold_stable)
%该函数删除信号中不稳定的状态
%删除规则: 非加油状态中超短的时间段： 当前持续时间小于等于3min,前后两个状态大于等于6min
%计算的变量：删除不稳定状态的输入信号
%输入：x -> input signal
%输入：x_piece_num -> input signal status piece number
%输入：pos_array -> start position array of every status
%输入：len_array -> length array of every continue status
%输入：threshold_unstable -> unstable threshold
%输入：threshold_stable   -> stable threshold
%输出： y -> input signal after remove unstable status

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