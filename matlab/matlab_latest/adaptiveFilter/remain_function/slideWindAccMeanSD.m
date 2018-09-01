function   [yMean,yStDev] = slideWindAccMeanSD(x,windradius)
 
    len = length(x);
    yMean   = zeros(len,1);
    yStDev  = zeros(len,1);
    
    for i=1:len
        if  i >= windradius+1 && i <= len - windradius
            startIdx = i - windradius;
            stopIdx  = i + windradius;
            signal   = x(startIdx:stopIdx);
            yMean(i)  = sum(signal)/(2*windradius+1);
            yStDev(i) = 10*sqrt(var(signal)/(2*windradius+1));
        else
            yMean(i) = x(i);
            yStDev(i) = 0;
        end
    end
    
end