function  y = reverse(x)
    
    x_len=length(x);
    y = zeros(x_len,1);
    
    for i = 1:x_len
        j = x_len + 1- i;
        y(j) = x(i);
    end
    
end