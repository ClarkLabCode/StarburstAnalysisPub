function SAC_SineWave_KF_Plot_FinalFigure(resp, data_info, epoch_ID, stim_info, signal_type, sf_str, tf_str, left, top, ax_w, ax_h)
%% figure specs
positions = {[left, top, ax_w, ax_h]; [left, top - (ax_h + 100), ax_w, ax_h]};

%% calculate over time.
if strcmp(signal_type, 'mean')
    [on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param_vec.fVals);
    [resp_over_time] = SAC_AverageResponseOverTime(resp, on_idx(:), off_idx(:));
elseif strcmp(signal_type, 'F1')
    [resp_over_time] = SAC_SineWave_Utils_GetF1Signal(resp, stim_info.param_vec.fVals);
end

[~, resp_ave, ~] = SAC_GetAverageResponse(resp_over_time);

%% plot colorplot. get the color map later on...
n_f = length(tf_str); n_k = length(sf_str); n_d = 2;
resp_reshape = reshape(resp_ave, n_f, n_k, n_d);
c_max = max(resp_ave);



sf_str_null_direction = fliplr(cellfun(@(x) ['-', x], sf_str, 'UniformOutput', false));
resp_reshape_together = [resp_reshape(:,:,1), zeros(size(resp_reshape, 1), 1), fliplr(resp_reshape(:,:,2))];
sf_str_together = [sf_str, {''}, sf_str_null_direction];

axes('Unit', 'point', 'Position', positions{1});
SAC_SineWave_Plot_Utils_KFPlot(resp_reshape_together, 1, c_max, ...
    'spatial_frequency_str', sf_str_together , 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
colorbar;

%% plot the DSI as well. only one direction.
% calculate DSI. in order to use SAC_AverageResponse_By, the input has to
% be a cell.
resp_ave_tmp = cell(1, 1);
resp_ave_tmp{1} = zeros(1, 1, length(resp_ave)); resp_ave_tmp{1}(1,1,:) = resp_ave;
[resp_ave_DSI_average_first_tmp, ~, ~] = SAC_AverageResponse_By(resp_ave_tmp, data_info, 'dirVal','sub_norm_by_sum', epoch_ID);
resp_ave_DSI_average_first = squeeze(resp_ave_DSI_average_first_tmp{1});

axes('Unit', 'point', 'Position', positions{2});
SAC_SineWave_Plot_Utils_KFPlot(reshape(resp_ave_DSI_average_first, n_f, n_k), 1, 1, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('DSI', 'FontSize', 10);
colorbar;
end
