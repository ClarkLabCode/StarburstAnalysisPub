function p = T4T5_DataTransfer_EmilioToJuyue_Stim_TwoSimultaneousBar(matDescription, cell_type)
stimDescription =  matDescription(13:16,:);
n_epoch = 144;

%% There are two bars. 8 directions.
p.bar_1_cont = zeros(n_epoch, 1);
p.bar_2_cont = zeros(n_epoch, 1);
n_type = 4; %% four types;
n_pos = 8;
pos = [2:9];
% phase is determined by the bar with smaller spatial index.
p.phase = zeros(n_epoch, 1); 

p.cont = zeros(60, 10, n_epoch);

%% harded code from Emilio's description.
% column wise: ++, +-, -+, --.
bar_1_offset = [-1, 0, -1, 0; %T4 Progressive.
    0, 0, -1, -1;
    0, -1, 0, -1;
    -1, -1, 0, 0]; % read this from

%% start 
for nn = 1:1:n_type
    stim_str = stimDescription{nn, 1};
    ii = stimDescription{nn, 3}; % epoch starting index.
    
    if stim_str(1) == '+'
        p.bar_1_cont(ii:ii + n_pos - 1) = 1;
    elseif stim_str(1) == '-'
        p.bar_1_cont(ii:ii + n_pos - 1) = -1;
    end
    
    if stim_str(2) == '+'
        p.bar_2_cont(ii:ii + n_pos - 1) = 1;
    elseif stim_str(2) == '-'
        p.bar_2_cont(ii:ii + n_pos - 1) = -1;
    end
    
    
    if (stim_str(1) == '+' && stim_str(2) == '+')
        offset = bar_1_offset(cell_type, 1);
    elseif (stim_str(1) == '+' && stim_str(2) == '-')
        offset = bar_1_offset(cell_type, 2);
    elseif (stim_str(1) == '-' && stim_str(2) == '+')
        offset = bar_1_offset(cell_type, 3);
    elseif (stim_str(1) == '-' && stim_str(2) == '-')
        offset = bar_1_offset(cell_type, 4);
    end
    
    
    p.phase(ii:ii + n_pos - 1) = pos + offset;
    
    for ll = 1:1:n_pos
        p.cont(:, pos(ll) + offset, ii + ll - 1) = p.bar_1_cont(ii + ll - 1);
        p.cont(:, pos(ll) + offset + 1, ii + ll - 1) = p.bar_2_cont(ii + ll - 1);
    end
end
end
