function T4T5_SineWave_KF_Plot_FinalFigure(resp, sf_str, tf_str, left, top, ax_w, ax_h)
%% figure specs
positions = {[left, top, ax_w, ax_h]; [left, top - (ax_h + 100), ax_w, ax_h]};

%% 
n_f = length(tf_str); n_k = length(sf_str); 
c_max = max(resp(:));
sf_str_null_direction = fliplr(cellfun(@(x) ['-', x], sf_str, 'UniformOutput', false));
resp_reshape_together = [resp(:,:,1), zeros(size(resp, 1), 1), fliplr(resp(:,:,2))];
sf_str_together = [sf_str, {''}, sf_str_null_direction];

axes('Unit', 'point', 'Position', positions{1});
SAC_SineWave_Plot_Utils_KFPlot(resp_reshape_together, 1, c_max, ...
    'spatial_frequency_str', sf_str_together , 'spatial_frequency_unit', '{1/\mu}m', ...
    'temporal_frequency_str', tf_str);
xlabel('');
colorbar;

%% plot the DSI as well. only one direction.
% calculate DSI. in order to use SAC_AverageResponse_By, the input has to
% be a cell.
resp_ave_DSI_average_first = squeeze((resp(:, :, 1) - resp(:, :, 2))./(resp(:, :, 1) + resp(:, :, 2)));

axes('Unit', 'point', 'Position', positions{2});
SAC_SineWave_Plot_Utils_KFPlot(resp_ave_DSI_average_first, 1, 1, ...
    'spatial_frequency_str', sf_str, 'spatial_frequency_unit', '{1/\circ}', ...
    'temporal_frequency_str', tf_str);
title('DSI', 'FontSize', 10);
colorbar;
end
