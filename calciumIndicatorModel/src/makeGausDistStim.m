function stim=makeGausDistStim(time,freq,startTime,std,av)
    dt=time(2)-time(1);
    framesPerTimeStep=round((1/freq)*1e3/dt);
    
    stim=1.*(time>=startTime);
    startFrame=find(stim,1,'first');
    count=1;
    newValue=av;
    stim(1:startFrame-1)=av;
    for ii=startFrame:length(time)
        
        stim(ii)=newValue;
        if count==framesPerTimeStep
            newValue=std*randn+av;
            count=0;
        end
        count=count+1;
    end
end