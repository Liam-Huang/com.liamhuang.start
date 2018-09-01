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

