function figure_scintillator_average_over_time_T4T5(resp, colors, left, top, ax_w, ax_h)

%% visualization specs
position = [left, top, ax_w, ax_h];

%% significance point.
alpha = 0.05;
significance_test_side = {'right', 'left'};

%% prepara data
x_axis_dt = ([0:6 12]')/60*1000;
polarities = [1, -1];
axes('Unit', 'point', 'Position', position);
for pp = 1:1:2
    color_use = colors{pp};
    
    resp_ave_this = resp{pp}{3}.resp_ave;
    resp_sem_this = resp{pp}{3}.resp_sem;
%     [~, p_value_this,~] = ttest(squeeze(resp{pp}{3}.resp_ind)');
    p_value_this = SAC_Scintillator_utils_do_sign_rank(squeeze(resp{pp}{3}.resp_ind)', significance_test_side{pp});
    PlotXY_Juyue(x_axis_dt,resp_ave_this,'errorBarFlag',1,'sem',resp_sem_this,...
        'colorMean', color_use, 'colorError',color_use); hold on;
    SAC_Plot_Utils_PlotSigPoint(x_axis_dt, p_value_this, 0.05, 0.01, 0.001, polarities(pp) * 0.17, false);
end

set(gca, 'YLim', [-0.2, 0.2], 'YTick', [-0.2, 0, 0.2], 'YTickLabelRotation', 90);
set(gca, 'XLim', [0, 210], 'XTick', [0, 50, 200]);
xlabel('\Deltat (ms)');
ylabel('\DeltaF/F');
%% in the end, wright text.
text(60, 0.12, '(+,\rightarrow-\leftarrow)', 'color',  colors{1});
text(60, -0.12, '(-,\rightarrow-\leftarrow)', 'color',  colors{2});
ConfAxis('fontSize', 10, 'LineWidth', 1);


end