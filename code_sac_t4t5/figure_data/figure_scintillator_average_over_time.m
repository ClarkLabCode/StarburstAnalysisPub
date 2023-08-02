function figure_scintillator_average_over_time(resp, colors, data_info, epoch_ID, on_set_second, dur_second, recording_info, SPLT, left, top, ax_w, ax_h)
%data_info, epoch_ID, on_set_second, dur_second, recording_info, SPLT)
position = [left, top, ax_w, ax_h];

%% significance point.
alpha = 0.05;

%% averaged over time.
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * on_set_second);
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%% direction. first - second.
[resp_over_dir, data_info_over_dir, epoch_ID_over_dir] = ...
    SAC_AverageResponse_By(resp_over_time, data_info,'dx','sub',epoch_ID);
n_time = 6;
x_axis_dt = ((1:n_time)'-1)*SPLT;

%% next, averaged the polarity first. add significant point.
epoch_index = data_info_over_dir.epoch_index;
[resp_ind_cell_mat, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_dir); resp_ind_cell_mat = squeeze(resp_ind_cell_mat)';
% calculate p value.
polarities  = [1, -1];
axes('Unit', 'point', 'Position', position);

significance_test_side = {'right', 'left'};
for pp = 1:1:2
    color_use = colors{pp};
    epoch_this = epoch_index(:,pp);
    resp_ave_this = resp_ave(epoch_this);
    resp_sem_this = resp_sem(epoch_this);
    data_this = resp_ind_cell_mat(:, epoch_this);
    %% put the dt = 0 into 0.
    resp_ave_this(1) = 0;
    resp_sem_this(1) = 0; % since they are the same stimulus.
    
    %%
    PlotXY_Juyue(x_axis_dt,resp_ave_this,'errorBarFlag',1,'sem',resp_sem_this,...
        'colorMean', color_use, 'colorError',color_use); hold on;
    
    p_values = SAC_Scintillator_utils_do_sign_rank(data_this, significance_test_side{pp});
    SAC_Plot_Utils_PlotSigPoint(x_axis_dt, p_values, 0.05, 0.01, 0.001, polarities(pp) * 0.1, 0);
    
end

set(gca, 'YLim', [-0.12, 0.12], 'YTick', [-0.1, 0, 0.1], 'YTickLabelRotation', 90);
set(gca, 'XLim', [0, 260], 'XTick', [0, 50, 200]);
xlabel('\Deltat (ms)');
ylabel('\DeltaF/F');

%% in the end, wright text.
text(60, 0.08, '(+,\rightarrow-\leftarrow)', 'color',  colors{1});
text(60, -0.08, '(-,\rightarrow-\leftarrow)', 'color',  colors{2});

ConfAxis('fontSize', 10, 'LineWidth', 1);
end
