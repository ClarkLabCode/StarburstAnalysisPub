function SAC_SineWave_KF_Plot(resp, data_info, epoch_ID, stim_info, signal_type, sf_str, tf_str, title_name)
f_resp = 15.625;
%%
fVals = data_info.stim_param.fVals; %% 
kVals = data_info.stim_param.kVals;

%% calculate over time.
if strcmp(signal_type, 'mean')
    [on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param_vec.fVals);
    [resp_over_time] = SAC_AverageResponseOverTime(resp, on_idx(:), off_idx(:));
elseif strcmp(signal_type, 'F1')
    [resp_over_time] = SAC_SineWave_Utils_GetF1Signal(resp, stim_info.param_vec.fVals);
end

%% average response
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_time);
[resp_over_dir, data_info_over_dir, epoch_ID_over_dir] = SAC_AverageResponse_By(resp_over_time, data_info, 'dirVal','sub', epoch_ID);
[~, resp_ave_over_dir, resp_sem_over_dir] = SAC_GetAverageResponse(resp_over_dir);

% individual_dir_tmp = cellfun(@(x) x(5), resp_over_dir);
resp_ave_tmp = cell(1, 1);
resp_ave_tmp{1} = zeros(1, 1, length(resp_ave)); resp_ave_tmp{1}(1,1,:) = resp_ave;
[resp_ave_DSI_average_first_tmp, ~, ~] = SAC_AverageResponse_By(resp_ave_tmp, data_info, 'dirVal','sub', epoch_ID);
resp_ave_DSI_average_first = squeeze(resp_ave_DSI_average_first_tmp{1});

%% DSI
[resp_DSI, data_info_DSI, epoch_ID_DSI] = SAC_AverageResponse_By(resp_over_time, data_info, 'dirVal','sub_norm_by_sum', epoch_ID);
[resp_ind_cell_mat_DSI, resp_ave_DSI, resp_sem_DSI] = SAC_GetAverageResponse(resp_DSI);

%% averaged DSI.



%% plot colorplot. get the color map later on...
n_f = length(fVals); n_k = length(kVals); n_d = 2;
resp_reshape = reshape(resp_ave, n_f, n_k, n_d);
c_max = max(resp_ave);

%% two directions.
MakeFigure;
subplot(1,4,1);
SAC_SineWave_Plot_Utils_KFPlot(resp_reshape(:,:,1), 1, c_max, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('preferred direction');

% plot them together. how?
subplot(1,4,2);
SAC_SineWave_Plot_Utils_KFPlot(resp_reshape(:,:,2), 1, c_max, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('null direction');

subplot(1,4,3);
SAC_SineWave_Plot_Utils_KFPlot(reshape(resp_ave_over_dir, n_f, n_k), 0, c_max, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('preferred - null');

sgtitle([title_name, ': ', signal_type]);
% MySaveFig_Juyue(gcf, 'Sinewave_KF','color', 'nFigSave',2,'fileType',{'png','fig'});

%% simulate what's in Matt's paper.

% plot them together.
MakeFigure;
subplot(1,4, 1:2);
sf_str_null_direction = fliplr(cellfun(@(x) ['-', x], sf_str, 'UniformOutput', false));
resp_reshape_together = [resp_reshape(:,:,1), zeros(size(resp_reshape, 1), 1), fliplr(resp_reshape(:,:,2))];
sf_str_together = [sf_str, {''}, sf_str_null_direction];
SAC_SineWave_Plot_Utils_KFPlot(resp_reshape_together, 1, c_max, ...
    'spatial_frequency_str', sf_str_together , 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('           null direction & preferred direction');

% 
subplot(1,4,3);
SAC_SineWave_Plot_Utils_KFPlot(reshape(resp_ave_over_dir, n_f, n_k), 0, c_max, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('preferred - null');
sgtitle([title_name, ': ', signal_type]);

subplot(1,4,4);

%resp_ave_DSI
SAC_SineWave_Plot_Utils_KFPlot(reshape(resp_ave_DSI_average_first, n_f, n_k), 1, 1, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('DSI = (pref-null)/(pref + null)');

sgtitle([title_name, ': ', signal_type]);


end
