function T4T5_LD_Utils_Subtract_Two_SingleBar(resp_two, data_info_two, resp_single, data_info_single, mode)

%% parameters for subtraction.
% delay_flag = 1: The single bar response has to be shifted before
% subtraction.

% phase_offset: For the bar (in the two) with phase x, the correspoding
% single bar has x + phase_offset.

% There is always two bars. Set the bar with smaller index to be bar 1.
switch mode
    case 'AppMot'
        %======= for apparent motion.
        % if direction is 1. the second bar has to be delayed.
        % if direction is -1. the first bar has to be delayed.
        delay_flag = [0,1; 1,0];
        
        % if direction is 1.
        % The leading bar is bar 1, and it has the same phase as the epoch phase.
        %The lagging bar phase is epoch phase + 1.
        
        % if direction is -1.
        % The lagging bar is bar 1, and it has the same phase as the epoch phase.
        %The leading bar phase is epoch phase + 1.
        
        phase_offset = [0, 1; 0, 1];
        
    case 'TwoSimultaneous'
        %======= for simultaneous bar.
        % bar_1 has the smaller index. phase of bar_1 is epoch phase.
        % bar_2 has the larger index. phase of bar_2 is epoch phase + 1.
        delay_flag = [0, 0];
        phase_offset = [0, 1]; % two bars.
end

%%
epoch_index_two = data_info_two.epoch_index;
epoch_index_single = data_info_single.epoch_index;
epoch_index_single_rep = T4T5_LD_Utils_rep_epoch_index(epoch_index_single,'single',mode);

%%
n_cont = 2;
n_phase = 8;
phase_bank = 1:n_phase;

%%
for bb = 1:1:2
    bar_phase = mod(phase_bank + phase_offset(bb) - 1, n_phase) + 1;
    
    if (delay_flag(1) == 1)
        resp_use = T4T5_LD_Utils_ShiftResp(resp_single);
    else
        resp_use = resp_single;
    end
    
    % Which dimension to repeat depends on the bar.
    for cc = 1:1:n_cont
        if bb == 1
            epoch_two = epoch_index_two(cc, :, :, :); 
            epoch_single_rep = epoch_index_single_rep(cc, :, :, bar_phase);               
        elseif bb == 2
            epoch_two = epoch_index_two(:, cc, :, :);
            epoch_single_rep =  epoch_index_single_rep(:, cc, :, bar_phase);
        end
        resp_two{cc}(epoch_two(:)) = resp_two{cc}(epoch_two(:)) - resp_use{cc}(epoch_single_rep(:));
    end
end
end