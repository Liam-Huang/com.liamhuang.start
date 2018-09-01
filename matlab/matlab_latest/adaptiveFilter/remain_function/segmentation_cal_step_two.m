function [number_piece,pos_array,len_array]=segmentation_cal_step_two(x,n)

%该函数计算对信号连续相同状态进行分段
%计算的变量：状态变化的次数， 状态变化的起始点，相同状态的持续时间
%输入：x -> input signal
%输入：n -> input signal length
%输出：number_piece -> status vary times
%输出：pos_array -> start position array of every status
%输出：len_array -> length array of every continue status

status_piece = 0;
status_start = zeros(n,1);
status_len = ones(n,1);

for i=1:n
    if i == 1
        status_piece = 1;
        status_start(status_piece) = 1;
        status_len(status_piece) = 1;
    else
        if x(i) == x(i-1)
            status_len(status_piece) = status_len(status_piece) + 1 ;
        else
            status_piece = status_piece + 1;
            status_start(status_piece) = i;
        end
    end 
end

number_piece=status_piece;
pos_array=status_start(1:number_piece);
len_array=status_len(1:number_piece);

end