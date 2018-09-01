function [fy,fx] = fillUnvalidSection(x,len)
    %x: n x 3  valid emements: element [count start stop]
    sizeX = size(x);
    fy = zeros(len,1);
    fx = zeros(len,1);
    
    for i = 1 : sizeX(1)
        element_cur = x(i,:);
        if i == 1
            for j = 1 : element_cur(2)-1
                fy(j) = 0;
            end
            for j = element_cur(2) : element_cur(3)
                fy(j) = 1;
            end
        else
            for j = element_pre(3) + 1 : element_cur(2) - 1
                fy(j) = 0;
            end
            for j = element_cur(2) : element_cur(3)
                fy(j) = 1;
            end         
        end
        element_pre = element_cur;
    end
    
    for j = element_cur(3) + 1 : len
        fy(j) = 0;
    end
    
    for j = 1 : len
        fx(j) = j - 1;
    end
end
    