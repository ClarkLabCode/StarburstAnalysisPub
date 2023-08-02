function h=hillFunction
    hillFunc=@(c,n,kd) (c.^n)./(kd.^n+c.^n);

    [KdG,nG,tauG,DrG]=getConstants("GCaMP");
    
    [KdO,nO,tauO,DrO]=getConstants("OBG");
    maxC=50;
    minC=0;
    X=linspace(minC,maxC,1000*(maxC-minC))';
    YG=hillFunc(X,nG,KdG);
    YO=hillFunc(X,nO,KdO);
    
    h.X=X;
    h.YG=YG;
    h.YO=YO;


end