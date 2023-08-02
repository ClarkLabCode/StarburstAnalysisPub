function figure_opponent_time_trace(resp, colors, left, top, ax_w, ax_h)
legend_str = {'(\rightarrow)', '(\leftarrow)', '(\leftarrow + \rightarrow)'};


positions = [left, top, ax_w, ax_h];
n_dir = 3;
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);

resp_ave_plot = cell(n_dir, 1);
resp_sem_plot = cell(n_dir, 1);
for dd = 1:1:n_dir
    resp_ave_plot{dd}  = resp_ave(:, dd);
    resp_sem_plot{dd}  = resp_sem(:, dd);
end
axes('Unit', 'point', 'Position', positions);
plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, colors);
set(gca, 'YLim', [-0.1, 0.6], 'YTick', [0, 0.5],'YTickLabelRotation', 90);

text_y = [0.7, 0.45, 0.575];
for dd = 1:1:n_dir
    text(0.2, text_y(dd), legend_str{dd}, 'FontSize', 10, 'color', colors{dd});
end
end
