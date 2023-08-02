function [Kd,n,tau,dr]=getConstants(type)
    if strcmp(type,'OBG')
        tau=7;     % ms -- Sun et al., 7 ms reported
        n=1;        % hill coefficient, Sun et al. graph, but 1.5 in vivo according to Hendel... Reiff (2008)
        Kd=0.24;    % uM from Reiff paper
        dr=15;      % Sun et al. graph
    elseif strcmp(type,'GCaMP')
        tau=250;    % ms, 250 Chen et al.; 200 Badura 2014 (at 25C)
        n=2.27;      % hill coefficient, 2.27 Chen et al.; 2.7 Badura 2014
        Kd=0.375;    % uM, 0.375 Chen et al.; 0.29 Badura 2014 CHECK IF THIS IS REALLY GCMP6F or 5F!!!!!!!!
        dr=29.2;      % 50 Chen et al., 2013; 29.2 Badura 2014
    else
        error('INVALID INDICATOR TYPE')
    end
end