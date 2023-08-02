function resp_ind_cell_mat = figure_opponent_barplot_prepare_response_SAC(resp, stim_info, left)
%% visualizatio specs


%% prepare data
% calculate over time.
[on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param.temporal_frequency);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_idx(:), off_idx(:));
[resp_ind_cell_mat, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_time);
resp_ind_cell_mat = squeeze(resp_ind_cell_mat);

% compare with preferred direciton, compare opponency with preferred
% direction.

end