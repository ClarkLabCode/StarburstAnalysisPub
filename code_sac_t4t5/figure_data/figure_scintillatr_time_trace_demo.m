function figure_scintillatr_time_trace_demo(resp, directions, polarities, dt, colors, stim_info, left1, left2, top, ax_w, ax_h)
positions = {[left1, top, ax_w, ax_h], ;
    [left2 , top, ax_w, ax_h]};


%% prepare data.
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
stimulus_parameters = stim_info.stimulus_parameters;

legend_str = {'(+,\rightarrow)', '(+,\leftarrow)';
              '(-,\rightarrow)', '(-,\leftarrow)'};
legend_y = [0.4, 0.3];
for pp = 1:1:2
    
    % prepare data and plot
    resp_ave_plot = cell(2, 1);
    resp_sem_plot = cell(2, 1);
    for dd = 1:1:2
        epoch_index = stimulus_parameters.temporal_offset == dt & ...
            stimulus_parameters.spatial_offset == -directions(dd) & ...
            stimulus_parameters.polarity == polarities(pp);
        resp_ave_plot{dd} = resp_ave(:, epoch_index);
        resp_sem_plot{dd} = resp_sem(:, epoch_index);
    end
    
    %% plot.
    axes('Unit', 'point', 'Position', positions{pp});
    plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, colors);
    text(0, legend_y(1), legend_str{pp, 1}, 'FontSize', 10);
    text(0, legend_y(2), legend_str{pp, 2}, 'FontSize', 10);
    
    set(gca, 'YLim', [-0.1, 0.5]);
    set(gca, 'YTick', [0, 0.5],'YTickLabelRotation', 90, 'FontSize', 10);
end

end
