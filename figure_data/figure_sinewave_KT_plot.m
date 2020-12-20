function figure_sinewave_KT_plot(resp, data_info, epoch_ID, stim_info, signal_type, sf_str, tf_str, title_name)
f_resp = 15.625;
%%
fVals = data_info.stim_param.fVals; %% 
kVals = data_info.stim_param.kVals;

%% calculate over time.
[on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param_vec.fVals);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_idx(:), off_idx(:));

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
SAC_SineWave_Plot_Utils_KFPlot(reshape(resp_ave_DSI, n_f, n_k), 1, 1, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
title('DSI = (pref-null)/(pref + null)');

sgtitle([title_name, ': ', signal_type]);


end
