function  p = T4T5_DataTransfer_EmilioToJuyue_Stim_AppMot(matDescription)
stimDescription = matDescription(1:8, :);
n_epoch = 144; % hard coded for now.

%% parameters for this stimulus
stim_onset_idx = 16; % 
n_lead_cont = 2;
n_lag_cont = 2;
n_dir = 2;
n_lag = 8;
lagPos = [2:9]; % position. first, 8.

%% for each epoch, record what's lagCont, leadCont, dirVal, and lagPos, also do phase and reproduce cont.
% n_epoch = n_lead_cont * n_lag_cont * n_dir * n_lag;
n_type = n_lead_cont * n_lag_cont * n_dir;
p.leadCont = zeros(n_epoch, 1);
p.lagCont = zeros(n_epoch, 1);
p.dirVal = zeros(n_epoch, 1);

p.lagPos = zeros(n_epoch, 1);
p.leadPos = zeros(n_epoch, 1);
p.phase = zeros(n_epoch, 1); %% This is overlapping with direction.

p.cont = zeros(60, 10, n_epoch); %% 1 second, 60 Hz as well
%%
for nn = 1:1:n_type
    stim_str = stimDescription{nn, 1};
    ii = stimDescription{nn, 3}; % epoch starting index.
    
    if stim_str(1) == '+'
        p.leadCont(ii:ii + n_lag - 1) = 1;
    elseif stim_str(1) == '-'
        p.leadCont(ii:ii + n_lag - 1) = -1;
    end
    
    if stim_str(2) == '+'
        p.lagCont(ii:ii + n_lag - 1) = 1;
    elseif stim_str(2) == '-'
        p.lagCont(ii:ii + n_lag - 1) = -1;
    end
    
    p.lagPos(ii:ii + n_lag - 1) = lagPos;
    if contains(stim_str, 'Pref')
        p.dirVal(ii:ii + n_lag - 1) = 1;
        p.leadPos(ii:ii + n_lag - 1) = lagPos - 1;
        % progressive direction. use the preferred bar position.
        p.phase(ii:ii + n_lag - 1)  = p.leadPos(ii:ii + n_lag - 1);
    elseif contains(stim_str, 'Null')
        p.dirVal(ii:ii + n_lag - 1) = -1;
        p.leadPos(ii:ii + n_lag - 1) = lagPos + 1;
        % regressive direction. use the lagging bar position.
        p.phase(ii:ii + n_lag - 1) = p.lagPos(ii:ii + n_lag - 1);
    end
    
    
    for ll = 1:1:n_lag
        % assign leading bar.
        p.cont(:, p.leadPos(ii + ll - 1), ii + ll - 1) = p.leadCont(ii + ll - 1); %% progressive, 1->2->3...
        % assign lagging bar.
        p.cont(stim_onset_idx:end, p.lagPos(ii + ll - 1), ii + ll - 1) =  p.lagCont(ii + ll - 1);
    end
end
end