function SAC_AppMot58_Plot_Utils_ApparentBars_BarPlot(resp, data_info, stim_info, epoch_ID, recording_info, plot_max_value, figure_name, plot_center_location_flag)

stim_onset = recording_info.stim_onset;
second_bar_onset = recording_info.second_bar_onset;
dur_second = 1 - second_bar_onset;
%% averaged over time.
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * (second_bar_onset + stim_onset));
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%%
epoch_index = data_info.epoch_index;
n_lag = size(data_info.epoch_index, 4);

%% bar plot, phase.
MakeFigure;
% organize the response, ave, sem, and individual?
bar_width = 0.3;
x_axis = [1:n_lag];
x_lim_plot = [-0.5, n_lag + 0.5];
x_axis_bank = [x_axis - bar_width/2; x_axis + bar_width/2];
color_bank = [214,33,20;
    1,102,164;
    2,44,108;
    248,207,206]/255;
line_style_bank = {'-', '--'};
face_alpha_bank = [1, 0.9];
polarity_string = {'Light-Light', 'Light-Dark', 'Dark-Light', 'Dark-Dark'};
direction_string = {'PD', 'ND'};

for cc_lead = 1:1:2
    for cc_lag = 1:1:2
        which_polarity = (cc_lead-1) * 2 + cc_lag;
        color_this = repmat(color_bank(which_polarity, :), [n_lag, 1]);
        
        subplot(4, 1, which_polarity);
        for dd = 1:1:2
            epoch_this = epoch_index(cc_lead, cc_lag, dd, :);
            xaxis_this = x_axis_bank(dd, :);
            face_alpha_this = face_alpha_bank(dd);
            line_style_this = repmat(line_style_bank{dd}, [n_lag, 1]);
            resp_one_polarity = cellfun(@(x) squeeze(x(epoch_this)), resp_over_time, 'UniformOutput', false);
            
            % get the bar plot. individual
            resp_ind_cell_mat = cat(2, resp_one_polarity{:})';
            
            resp_ave_over_cell = mean(resp_ind_cell_mat, 1);
            resp_std_over_cell = std(resp_ind_cell_mat, 1, 1);
            resp_sem_over_cell = resp_std_over_cell./sqrt(length(resp_one_polarity ));
            
            % first, plot without individual.
            bar_scatter_plot_Juyue(resp_ave_over_cell, resp_sem_over_cell, resp_ind_cell_mat,  color_this,...,
                'link_dots_flag', 0, 'xaxis', xaxis_this, 'bar_width', bar_width,...
                'plot_individual_dot', 0, 'line_style_bank', line_style_this, 'line_width', 2, 'face_alpha', face_alpha_this,'do_sig_test_flag', 1);
            SAC_Plot_Utils_BarPlot_Setup_Axis(x_lim_plot, [-1, 1] * (plot_max_value), x_axis, 0)
        end
        legend(polarity_string{which_polarity},'FontSize', 14, 'Box','off', 'TextColor', color_bank(which_polarity, :));
        if plot_center_location_flag
            set(gca, 'XLim', [3.5, 7.5]);
        end
    end
end
ax_tmp = gca;
ax_tmp.XAxis.Visible = 'on';
set(gca, 'XTick', [1:n_lag]);
xlabel('ring (bar) position (x, x + 1)', 'FontSize', 14);


sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, 'BarPlot', 'nFigSave',2,'fileType',{'png','fig'});

