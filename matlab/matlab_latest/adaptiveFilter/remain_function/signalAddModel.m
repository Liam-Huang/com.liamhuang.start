function  [y,x] = signalAddModel(y,x,len,data)

    [row,column] = size(y);
    len_org = max(row,column);
    
    if row == 1
        x = x';
        y = y';
    end
    
    for i = len_org + 1 : len_org + len
        x(i) = i - 1;
        y(i) = data;
    end
end