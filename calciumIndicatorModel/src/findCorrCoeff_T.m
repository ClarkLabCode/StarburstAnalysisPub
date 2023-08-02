function [coeff,lagTime]=findCorrCoeff_T(dt,stim,dF,filtLength,save,saveDir,tag)

    stim=stim-mean(stim);
    dF=dF-mean(dF);
    lagTime = [filtLength:-dt:0];
    loopLength=length(lagTime);
    lagList=[loopLength:-1:0];
    
    for ii = 1:loopLength
        LL=-1*lagList(ii);
        coeff(ii)=regress(circshift(dF,LL),stim);
    end

    if save==1    
        Data=[timeLag,coeff];
        mkdir('data');
        mkdir('data',saveDir);
        file_name = ['data/',saveDir,'/', type,'_',tag,'.txt'];
        save (file_name, Data)
    end 

end