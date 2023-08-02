function figure_sinewave_time_trace_fix_spatial(resp, tfs, dir, colors, sw, stim_info, left, top, ax_w, ax_h)

%%% time traces for sinewave sweep. spatial frequncy is fixed. change
%%% temporal frequency.


%
% visualization spec
positions = [left, top, ax_w, ax_h];
n_temporal = round(length(tfs)/2);
colors = mat2cell([flipud(brewermap(n_temporal, 'Blues'));brewermap(n_temporal, 'Reds')], ones(n_temporal * 2, 1), [3]);


%% prepare data.
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
n_epoch = length(tfs);
resp_ave_plot = cell(n_epoch, 1);
resp_sem_plot = cell(n_epoch, 1);
stimulus_parameters = stim_info.stimulus_parameters;
tol = 1e-3;
for ee = 1:1:n_epoch
    epoch_index = stimulus_parameters.direction == dir(ee) & ...
        abs(stimulus_parameters.temporal_frequency - tfs(ee)) < tol & ...
        stimulus_parameters.spatial_wavelength == sw;
    resp_ave_plot{ee} = resp_ave(:, epoch_index);
    resp_sem_plot{ee} = resp_sem(:, epoch_index);

end

%% plot.
axes('Unit', 'point', 'Position', positions);
plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, colors)
end


