function SAC_T4T5_TwoSimultaneousBars_Plot_Utils_BarPlot(resp, data_info, stim_info, epoch_ID, recording_info, maxValue, emphasize_negative, figure_name)
%%
stim_onset = recording_info.stim_onset;
dur_second = 1;
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * (stim_onset));
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%% how about not plotting the four 4D? not necessary. just along the dimesion.
epoch_index = data_info.epoch_index;
n_lag = size(data_info.epoch_index, 3);

%% bar plot, phase.
MakeFigure;
% organize the response, ave, sem, and individual?
bar_width = 0.3;
color_bank = [214,33,20;
    1,102,164;
    2,44,108;
    248,207,206]/255;
polarity_string = {'Light-Light', 'Light-Dark', 'Dark-Light', 'Dark-Dark'};


for cc_lead = 1:1:2
    for cc_lag = 1:1:2
        which_polarity = (cc_lead-1) * 2 + cc_lag;
        color_this = repmat(color_bank(which_polarity, :), [n_lag, 1]);
        
        subplot(4, 1, which_polarity);
        epoch_this = epoch_index(cc_lead, cc_lag, :);

        resp_one_polarity = cellfun(@(x) squeeze(x(epoch_this)), resp_over_time, 'UniformOutput', false);
        
        % get the bar plot. individual
        resp_ind_cell_mat = cat(2, resp_one_polarity{:})';
        resp_ave_over_cell = mean(resp_ind_cell_mat, 1);
        resp_std_over_cell = std(resp_ind_cell_mat, 1, 1);
        resp_sem_over_cell = resp_std_over_cell./sqrt(length(resp_one_polarity ));
        
        % first, plot without individual.
        bar_scatter_plot_Juyue(resp_ave_over_cell, resp_sem_over_cell, resp_ind_cell_mat,  color_this,...,
            'link_dots_flag', 0, 'bar_width', bar_width,...
            'plot_individual_dot', 0 ,'do_sig_test_flag', 1, 'plot_max_value', maxValue);
        ax_tmp = gca;
        ax_tmp.XAxis.Visible = 'off';
        ax_tmp.XLim = [0.5, n_lag + 0.5];
        ylabel('\Delta F/F');
        
        ax_tmp.YLim = [-1, 1] * maxValue;
        ConfAxis('fontSize',10, 'LineWidth', 1.5);
        legend(polarity_string{which_polarity},'FontSize', 14, 'Box','off', 'TextColor', color_bank(which_polarity, :));
    end
end
ax_tmp = gca;
ax_tmp.XAxis.Visible = 'on';
set(gca, 'XTick', [1:n_lag]);
xlabel('ring (bar) position (x, x + 1)', 'FontSize', 14);

sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});
end