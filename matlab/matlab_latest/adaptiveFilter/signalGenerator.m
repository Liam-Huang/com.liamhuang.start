function  [y,x] = signalGenerator()

x=[];
y=[];
%stage1
[y,x] = signalAddModel(y,x,50,0);
[y,x] = signalAddModel(y,x,50,1);
[y,x] = signalAddModel(y,x,50,0);

[y,x] = signalAddModel(y,x,50,0);
[y,x] = signalAddModel(y,x,50,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,50,1);
[y,x] = signalAddModel(y,x,50,0);

[y,x] = signalAddModel(y,x,60,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,30,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,60,0);


[y,x] = signalAddModel(y,x,60,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,10,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,10,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,10,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,10,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,30,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,60,0);

%stage2
[y,x] = signalAddModel(y,x,60,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,15,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,60,0);

[y,x] = signalAddModel(y,x,50,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,10,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,10,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,50,0);


%stage3
[y,x] = signalAddModel(y,x,60,0);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,2,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,3,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,4,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,5,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,6,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,7,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,8,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,1,1);
[y,x] = signalAddModel(y,x,9,0);
[y,x] = signalAddModel(y,x,60,0);


end

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