function [y]=delete_short_unstable_status_cal(x,n,pos_array,len_array,threshold_unstable,threshold_stable,status)
%该函数删除信号中不稳定的状态
%删除规则: 非加油状态中超短的时间段： a. 当前持续时间小于5min,前一个状态持续时间大于15min  b. 当前持续时间小于等于2min,前后两个状态大于等于5min
%计算的变量：删除不稳定状态的输入信号
%输入：x -> input signal
%输入：n -> input signal status piece number
%输入：pos_array -> start position array of every status
%输入：len_array -> length array of every continue status
%输入：threshold_unstable -> a type unstable threshold
%输入：threshold_stable -> a type stable threshold
%输入：status -> refule status
%输出： y -> input signal after remove short unstable status

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