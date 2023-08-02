function figure_apparent_motion_time_traces(resp, colors, data_info, left, top, ax_w, ax_h)

positions = {[left, top, ax_w, ax_h],;
    [left, top - (ax_h +20), ax_w, ax_h];
    [left, top - (ax_h +20) * 2, ax_w, ax_h];
    [left, top - (ax_h +20) * 3, ax_w, ax_h];
    };

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
epoch_index = data_info.epoch_index;
ll = 2;
ee = 1;
 
% polarity_str = {'+', '-'};
% direction_str = {'\rightarrow', '\leftarrow'};

for cc_bar_1 = 1:1:2
    for cc_bar_2 = 1:1:2
        
        resp_ave_plot = cell(2, 1);
        resp_sem_plot = cell(2, 1);
        for dd = 1:1:2
            resp_ave_plot{dd} = resp_ave(:, epoch_index(cc_bar_1, cc_bar_2, dd, ll));
            resp_sem_plot{dd} = resp_sem(:, epoch_index(cc_bar_1, cc_bar_2, dd, ll));
        end
        axes('Unit', 'point', 'Position', positions{ee});
        plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, colors,'stim_dur', 60);
        
%         % preferred direction str
%         pref_str = ['(', polarity_str{cc_bar_1}', ',', polarity_str{cc_bar_1}', ',', direction_str{1}, ')'];
%         null_str = ['(', polarity_str{cc_bar_1}', ',', polarity_str{cc_bar_1}', ',', direction_str{2}, ')'];
%         text(0.5, 0.6, pref_str, 'FontSize', 10);
%         text(0.5, 0.5, null_str, 'FontSize', 10);
        
        set(gca, 'YLim', [-0.2, 0.7], 'YTick', [0, 0.5], 'YTickLabelRotation', 90, 'XLim', [-0.25, 1.25]);
        hold on; plot([0.25, 0.25], get(gca, 'YLim'), 'k--'); hold off;
        ee = ee + 1;
    end
end
end
