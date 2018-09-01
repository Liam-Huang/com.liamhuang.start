function    [y] = limitAmpFilter(x,threshold)
    len = length(x);
    y = zeros(len,1);
    for i=1:len
        if x(i) >= threshold
            y(i) = 1;
        end
    end
end