function [F,dF]=caToF(CaData,dt,startFrame,type,save,saveDir,tag)
    %saveTime=datetime('now','Format','yyyy-MM-dd_HH:mm:ss.SSS');
    % Set Relevant constants
    NFrame=length(CaData);

    % set indicator specific constants
    [Kd,n,tau,Dr]=getConstants(type);
    
    % set alpha=(tau*K^n)^-1
    alpha=1./(tau*Kd.^n);  
    % set beta =tau^-1 
    beta=1./tau;

    % Set rate equation
    rateFunc= @(x,CaMat) alpha*(1-x)*CaMat.^n-beta*x;

    C0=calcStartValue(CaData,startFrame,Kd,n);
    

    % Integrate the equation
    %                    vel,     dt,NFrames,x0,startFrame,TempVariables
    CaInt=eulerIntegrate(rateFunc,dt,NFrame,C0,startFrame,CaData);
    
    % Scale to the Dynamic Range 
    %%%%%%%%%%%%%%%%%%%%%%FIGURE THIS SHIT OUT!!!!!!!!!!!!!!!!!!!!!!
    F=(1-CaInt+Dr*CaInt);
%     
    % Find df/F 
    F0=mean(F(1:startFrame-1));
    dF=(F-F0)./F0;
%     dF=(Dr-1).*CaInt;
%     dF=dF-dF(1,1);
    % save text file
    if save==1    
        Data=[time,f,df];
        mkdir('data');
        mkdir('data',saveDir);
        file_name = ['data/',saveDir,'/', type,'_',tag,'.txt'];
        save (file_name, Data)
    end 
end