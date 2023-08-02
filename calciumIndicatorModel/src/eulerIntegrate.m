function x=eulerIntegrate(vel,dt,NFrames,x0,startFrame,TempVariables)
    
    x=zeros(NFrames,1);
    x(1:startFrame)=x0;
    
    for i=startFrame:NFrames-1      
        x(i+1)=x(i)+dt*vel(x(i),TempVariables(i,:));
    end
end 
