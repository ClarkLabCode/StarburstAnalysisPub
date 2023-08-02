function SAC_T4T5_SingleBar_Plot_Utils_BarPlot(resp, data_info, stim_info, epoch_ID, recording_info, plotting_max_value, figure_name, plot_center_location_flag)
%% collect the integrated response.
stim_onset = recording_info.stim_onset;
dur_second = 1;
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * (stim_onset));
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%% how about not plotting the four 4D? not necessary. just along the dimesion.
epoch_index = data_info.epoch_index;
n_lag = size(data_info.epoch_index, 2);

%% bar plot, phase.
MakeFigure;
% organize the response, ave, sem, and individual?
bar_width = 0.3;
xaxis = (1:n_lag);
color_bank = [214,33,20;
    2,44,108]/255;
polarity_string = {'Light', 'Dark'};

MakeFigure;
for cc = 1:1:2
    color_this = repmat(color_bank(cc, :), [n_lag, 1]);
    subplot(4, 1, cc);
    epoch_this = epoch_index(cc, :);
    
    % how could you clean this up?
    resp_one_polarity = cellfun(@(x) squeeze(x(epoch_this)), resp_over_time, 'UniformOutput', false);
    resp_one_polarity = cellfun(@(x) x(:), resp_one_polarity, 'UniformOutput', false);
    % get the bar plot. individual
    resp_ind_cell_mat = cat(2, resp_one_polarity{:})';
    resp_ave_over_cell = mean(resp_ind_cell_mat, 1);
    resp_std_over_cell = std(resp_ind_cell_mat, 1, 1);
    resp_sem_over_cell = resp_std_over_cell./sqrt(length(resp_one_polarity ));
    
    % first, plot without individual.
    bar_scatter_plot_Juyue(resp_ave_over_cell, resp_sem_over_cell, resp_ind_cell_mat,  color_this,...,
        'link_dots_flag', 0, 'xaxis', xaxis, 'bar_width', bar_width,...
        'plot_individual_dot', 0, 'do_sig_test_flag', 1, 'plot_max_value',  plotting_max_value);
    
    ax_tmp = gca;
    ax_tmp.YLim = [-1, 1] * plotting_max_value;
    ax_tmp.XAxis.Visible = 'off';
    ax_tmp.XLim = [0.5, n_lag + 0.5];
    ylabel('\Delta F/F');
    ConfAxis('fontSize',10, 'LineWidth', 1.5);
    legend(polarity_string{cc},'FontSize', 14, 'Box','off', 'TextColor', color_bank(cc, :));
    if plot_center_location_flag
        set(gca, 'XLim', [3.5, 7.5]);
    end
end
ax_tmp = gca;
ax_tmp.XAxis.Visible = 'on';
set(gca, 'XTick', [1:n_lag]);
xlabel('ring (bar) position (x, x + 1)', 'FontSize', 14);

sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});
end