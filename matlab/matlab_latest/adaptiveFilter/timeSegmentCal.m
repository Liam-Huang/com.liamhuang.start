function y = timeSegmentCal(x,validThreshold,connectableLength,validLength)
    %validThreshold = 0.01 connectableLength = 5 unvalidLength = 5
    %element = [counter,start,stop] 1x3 array
    %y       = [element1;element2;...;elementn]
    len = length(x);
    element = zeros(1,3);
    y = [];
    for i = 1 : len
        if x(i) >= validThreshold
            if ~initedElement(element)
                element = initElement(element,i);
            elseif connectableElement(element,i,connectableLength)
                element = updateElement(element,i);
            else
                y = addElement(y,element);
                element = clearElement(element);
                element = initElement(element,i);
            end
        end
    end
    y = addElement(y,element);    
    y = deleteUnvalidElement(y,validLength);
       
end



function element = clearElement(element)
    %element: 1 x 3
    if element(1) ~= 0
        element = [0,0,0];
    end
end

function element = initElement(element,start)
    %element: 1 x 3
    if element(1) == 0
        element = [1,start,start];
    end
end

function flag = initedElement(element)
    %element: 1 x 3
    if element(1) == 0
        flag = 0;
    else
        flag = 1;
    end
end

function flag = connectableElement(element,Ts, connectableLength)
    %element: 1 x 3
    stop = element(3);
    if Ts - stop < connectableLength
        flag = 1;
    else
        flag = 0;
    end
end

function element = updateElement(element,stop)
    %element: 1 x 3
    if initedElement(element)       
        element(1) = element(1) + 1;
        element(3) = stop;   
    end
end

function y = addElement(y,element)
    %element: 1 x 3
    if initedElement(element)
        y = [y;element];
    end
end

function y = deleteUnvalidElement(x,validLength)
    %x = [element1;element2;...;elementn]
    %process: delete elements which meet (stop-start < unvalidLength)
    %y = [element11;element22;...;elementnn]
    sizeX = size(x); % matrix: n x 3    [1]: row [2]: column
    j = 0;
    y = [];
    for i = 1 : sizeX(1)
        if x(i,1) >= validLength
            j = j + 1;
            requireElement = x(i,:);
            y = [y;requireElement];
        end  
    end
end