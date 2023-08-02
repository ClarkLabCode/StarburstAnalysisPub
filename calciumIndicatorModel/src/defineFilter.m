function filt=defineFilter(time,filtTime_in_ms,filtFunc)
    timeStepSize=time(2)-time(1);
    t=[0:timeStepSize:filtTime_in_ms];
    filt=filtFunc(t);
    filt=filt/sqrt(sum(filt.^2));
end