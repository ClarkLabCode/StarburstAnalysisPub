function x0=calcStartValue(CaMat,start,Kd,n) 

    % choose our starting Ca value         
    c1=mean(CaMat(round(0.5*start):start-1));         
    
    % calculate the initial b from the c1 
    % value and the hill function
    x0=power(c1,n)/(power(Kd,n)+power(c1,n));

end