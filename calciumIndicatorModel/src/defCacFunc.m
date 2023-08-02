function func=defCacFunc(parameters,start,width,type)
    
    if strcmp(type,'step')
        h1=parameters(1);       % uM of Ca
        h2=parameters(2);       % uM of Ca
        h3=parameters(3);       % uM of Ca
        func=@(x) (h2-h1)*heaviside(x-start)+h1+(h3-h2)*heaviside(x-start-width);
    elseif strcmp(type,'cos')
        amp=parameters(1);      % uM of Ca
        freq=parameters(2);     % Hz
        phase=parameters(3);    % ms  
        height=parameters(4);   % uM of Ca
        omega=2*pi*freq/1e3;   % rad/ms
        func=@(x) amp.*(heaviside(x-start)-heaviside(x-(start+width))).*(1-cos(omega*(x-(start+phase))))+height;
    end
end