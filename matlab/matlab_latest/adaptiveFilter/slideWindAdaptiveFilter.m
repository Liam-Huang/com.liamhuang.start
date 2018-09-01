function   [y] = slideWindAdaptiveFilter(x,windRadius,weight_len,weight_coe,dis_order,width_order)
 
    len = length(x);
    y = zeros(len,1);
    
    for i=1:len
        if  i >= windRadius+1 && i <= len - windRadius
            signal_pro = x(i-windRadius:i+windRadius);
            [number_piece,vld_piece_idx,array_start,array_len,array_state]=segmentation_cal(signal_pro,windRadius);
            array_central   = array_start + (array_len - 1)/2;
            current_central = array_central(vld_piece_idx);
            array_distance  = zeros(number_piece,1);
            array_slope     = zeros(number_piece,1);
            for j=1:number_piece
                if j == vld_piece_idx
                    array_distance(j) = abs(array_central(j) - windRadius - 1)+0.5;
                else
                    array_distance(j) = abs(array_central(j) - current_central);
                end
            end
            if array_len(vld_piece_idx) >= weight_len
                weigh = weight_coe;
            else
                weigh = 1;
            end
            for j = 1 : number_piece
                if j == vld_piece_idx
                    array_slope(j) = weigh * array_len(j)^width_order/array_distance(j)^dis_order;
                else
                    array_slope(j) = array_len(j)^width_order/array_distance(j)^dis_order;
                end
            end
            array_coe = array_slope/sum(array_slope);
            for j=1:number_piece
                y(i) = y(i) + array_coe(j) * array_state(j);
            end
        else
            y(i) = x(i);
        end
    end
    
end

function [number_piece,vld_piece_idx,pos_array,len_array,state_array]=segmentation_cal(x,windRadius)

%�ú���������ź�������ͬ״̬���зֶ�
%����ı�����״̬�仯�Ĵ����� ״̬�仯����ʼ�㣬��ͬ״̬�ĳ���ʱ��
%���룺x -> input signal
%���룺n -> input signal length
%�����number_piece -> status vary times
%�����pos_array -> start position array of every status
%�����len_array -> length array of every continue status

status_piece = 0;
status_start = zeros(2*windRadius+1,1);
status_len = ones(2*windRadius+1,1);

for i=1:2*windRadius+1
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
        
        if i == windRadius+1
            vld_piece_idx = status_piece;
        end
    end 
end

state_array = zeros(status_piece,1);
for i=1:status_piece
    state_array(i) = x(status_start(i));
end
number_piece=status_piece;
pos_array=status_start(1:number_piece);
len_array=status_len(1:number_piece);

end
