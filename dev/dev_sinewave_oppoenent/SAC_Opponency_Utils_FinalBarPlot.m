function SAC_Opponency_Utils_FinalBarPlot(resp, stim_info)
color_use_bank = [[1,0,0];[0,0,1];[0.5,0.5,0.5]];

%% calculate over time.
[on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param.temporal_frequency);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_idx(:), off_idx(:));
[resp_ind_cell_mat, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_time);
resp_ind_cell_mat = squeeze(resp_ind_cell_mat);

% compare with preferred direciton, compare opponency with preferred
% direction.
pref = resp_ind_cell_mat(1,:);
oppo = resp_ind_cell_mat(3,:);
null = resp_ind_cell_mat(2,:);
[p_pref_opp] = ranksum(pref, oppo);
[p_pref_null] = ranksum(pref, null);
[p_null_oppo] = ranksum(null, oppo);
%% compare
max_plot_value = 1;
MakeFigure;
subplot(2,2,1)
bar_scatter_plot_Juyue(resp_ave, resp_sem, resp_ind_cell_mat',  color_use_bank,...,
    'plot_individual_dot', 1, 'link_dots_flag', 0, 'xaxis', [0,1,2], 'bar_width', 0.5,...
    'line_style_bank', ['-';'-';'-'], 'line_width', 2, 'face_alpha', 0.5, 'do_sig_test_flag', 0);

% plot significance.
hold on;
plot([0,2], [max_plot_value, max_plot_value], 'k-'); text(1, max_plot_value+ 0.1, ['p : ', num2str(p_pref_opp, 4)], 'fontSize',15);
plot([0,1], [max_plot_value, max_plot_value] * 0.8, 'k-'); text(0.5, max_plot_value * 0.8 + 0.1, ['p : ', num2str(p_pref_null, 4)], 'fontSize',15);
plot([1,2], [max_plot_value, max_plot_value] * 0.6, 'k-'); text(1.5, max_plot_value * 0.6 + 0.1, ['p : ', num2str(p_null_oppo, 4)], 'fontSize',15);


set(gca, 'YLim', [0,max_plot_value], 'XLim', [-1,3]);
ylabel('\Delta F/F');
ConfAxis('fontSize',15, 'LineWidth', 1.5);
set(gca, 'XTick', [0,1,2], 'XTickLabel', {'pref', 'null', 'oppo'});
end