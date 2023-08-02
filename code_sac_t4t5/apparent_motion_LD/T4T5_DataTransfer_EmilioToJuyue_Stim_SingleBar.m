function p = T4T5_DataTransfer_EmilioToJuyue_Stim_SingleBar(matDescription, dataset_name)
if strcmp(dataset_name, 'next_neighbor')
    stimDescription =  matDescription(13:14, :);
    n_epoch = 112; % hard coded for now.
elseif strcmp(dataset_name,'neighbor')
    stimDescription =  matDescription(17:18, :);
    n_epoch = 144; % hard coded for now.
end

%%
n_type = 2;
n_pos = 8; %% 10 positions
barPos = [3:10]; % 

p.barCont = zeros(n_epoch, 1);
p.phase = zeros(n_epoch, 1);
p.cont = zeros(60, 10, n_epoch); %% 1 second, 60 Hz as well

%%
for nn = 1:1:n_type
    stim_str = stimDescription{nn, 1};
    ii = stimDescription{nn, 3}; % epoch starting index.
    
    if stim_str(1) == '+'
        p.barCont(ii:ii + n_pos - 1) = 1;
    elseif stim_str(1) == '-'
        p.barCont(ii:ii + n_pos - 1) = -1;
    end
    
    p.phase(ii:ii + n_pos - 1) = barPos;
    
    for ll = 1:1:n_pos
        p.cont(:, barPos(ll), ii + ll - 1) =  p.barCont(ii + ll - 1);
    end
end

end