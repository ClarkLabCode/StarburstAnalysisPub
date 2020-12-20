function T4T5_LD_Utils_SubtractSingleBar(resp_two, data_info_two, resp_single, data_info_single, source, target)

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
epoch_index_single_rep = T4T5_LD_Utils_rep_epoch_index(epoch_index_single, source, target);

%%
n_cont = 2;
n_phase = 8;
phase_bank = 1:n_phase;
for bb = 1:1:2
    bar_phase = mod(phase_bank + phase_offset(bb) - 1, n_phase) + 1;
    
    if (delay_flag(1) == 1)
        resp_use = T4T5_LD_Utils_ShiftResp(resp_single);
    else
        resp_use = resp_single;
    end
    
    %% Which dimension to repeat depends on the bar.
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


% %% resp dim
% function epoch_index_rep = utils_repeat_epoch_index(epoch_index, rep_dim, non_rep_dim,  target_card)
% %% resp dim
% %==== Single bar. [2, 8]
% %==== Two bars, [2,2,8]
% %==== AppMot    [2, 2, 2, 8]
% % repeat a certain dimension.
%
% % turn single bar into AppMot, or Twobars.
% n_dim = length(target_card);
% curr_card = size(epoch_index);
% rep_card = target_card(rep_dim);
%
% tmp = repmat(epoch_index, prod(rep_card));
% tmp = reshape(tmp, [rep_card, curr_card]);
%
% % permutation.
% n_rep_dim = length(rep_dim);
% n_non_rep_dim = length(non_rep_dim);
% permute_dim = zeros(1, n_dim);
% permute_dim(rep_dim) = 1:n_rep_dim;
% permute_dim(non_rep_dim) = 1:n_non_rep_dim;
%
% %
% epoch_index_rep = permute(tmp, permute_dim);
% end
