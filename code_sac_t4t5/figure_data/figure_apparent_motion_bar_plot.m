function figure_apparent_motion_bar_plot(resp, colors, data_info, recording_info, plot_center_location_flag, plot_max_value, left, top, ax_w, ax_h, legend_flag)

% left = 36 + 312;
positions = {[left, top, ax_w, ax_h],;
    [left, top - (ax_h +20), ax_w, ax_h];
    [left, top - (ax_h +20) * 2, ax_w, ax_h];
    [left, top - (ax_h +20) * 3, ax_w, ax_h];
    };


%%
stim_onset = recording_info.stim_onset;
second_bar_onset = recording_info.second_bar_onset;
dur_second = 1 - second_bar_onset;

% averaged over time.
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * (stim_onset));
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%
epoch_index = data_info.epoch_index;
n_lag = size(data_info.epoch_index, 4);


% organize the response, ave, sem, and individual?
bar_width = 0.3;
x_axis = [1:n_lag];
x_lim_plot = [0.5, n_lag + 0.5];
x_axis_bank = [x_axis - bar_width/2; x_axis + bar_width/2] ;


polarity_str = {'+', '-'};
direction_str = {'\rightarrow', '\leftarrow'};

ee = 1;
for cc_lead = 1:1:2
    for cc_lag = 1:1:2
        
        axes('Unit', 'point', 'Position', positions{ee});
        for dd = 1:1:2
            epoch_this = epoch_index(cc_lead, cc_lag, dd, :);
            xaxis_this = x_axis_bank(dd, :);
            color_this = repmat(colors{dd}, [n_lag, 1]);
            resp_one_polarity = cellfun(@(x) squeeze(x(epoch_this)), resp_over_time, 'UniformOutput', false);
            
            % get the bar plot. individual
            resp_ind_cell_mat = cat(2, resp_one_polarity{:})';
            resp_ave_over_cell = mean(resp_ind_cell_mat, 1);
            resp_std_over_cell = std(resp_ind_cell_mat, 1, 1);
            resp_sem_over_cell = resp_std_over_cell./sqrt(length(resp_one_polarity ));
            
            % first, plot without individual. plot individual points.
            bar_scatter_plot_Juyue(resp_ave_over_cell, resp_sem_over_cell, resp_ind_cell_mat,  color_this,...,
                'link_dots_flag', 0, 'xaxis', xaxis_this, 'bar_width', bar_width,...
                'plot_individual_dot', 0, 'line_width', 1, 'face_alpha', 1,'do_sig_test_flag', 1, 'plot_max_value', plot_max_value + 0.1, 'sig_bonferroni_n', n_lag * 2);
        end
        
        if legend_flag
            pref_str = ['(', polarity_str{cc_lead}', ',', polarity_str{cc_lag}', ',', direction_str{1}, ')'];
            null_str = ['(', polarity_str{cc_lead}', ',', polarity_str{cc_lag}', ',', direction_str{2}, ')'];
            
            text(n_lag * 2/3, plot_max_value - 0.2, pref_str, 'FontSize', 10);
            text(n_lag * 2/3, plot_max_value - 0.35, null_str, 'FontSize', 10);
        end
        
        SAC_Plot_Utils_BarPlot_Setup_Axis(x_lim_plot, [-0.2, 1] * (plot_max_value + 0.1), x_axis, 0)
        set(gca, 'YTick', [0,0.5, 1], 'YTickLabelRotation', 90);
        ee = ee + 1;
        if plot_center_location_flag
            set(gca, 'XLim', [2.5, 7.5]);
        end
    end
end
ax_tmp = gca;
ax_tmp.XAxis.Visible = 'on';
set(gca, 'XTick', [1:n_lag]);
