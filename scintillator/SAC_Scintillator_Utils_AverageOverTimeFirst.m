function SAC_Scintillator_Utils_AverageOverTimeFirst(resp, data_info, epoch_ID, on_set_second, dur_second, recording_info, SPLT)
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
% [resp_over_dir_pol, data_info_over_dir_pol, epoch_ID_over_dir_pol] = ...
%     SAC_AverageResponse_By(resp_over_dir, data_info_over_dir,'pol','sub', epoch_ID_over_dir);
[resp_over_dir_dt,  ~, ~] =  ...
    SAC_AverageResponse_By(resp_over_dir, data_info_over_dir,'dt','mean', epoch_ID_over_dir);
% [resp_over_dir_pol_dt, data_info_over_dir_pol_dt, epoch_ID_over_dir_pol_dt] = ...
%     SAC_AverageResponse_By(resp_over_dir_pol, data_info_over_dir_pol,'dt','mean', epoch_ID_over_dir_pol);

%%
n_time = 6;
x_axis_dt = ((1:n_time)'-1)*SPLT;
n_dir = 2;
n_par = 2;
epoch_index = data_info.epoch_index;
[resp_ind_cell_mat, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_time);
color_bank = [[1,0,0];[0,0,1]]; % for positive and negative.
lineStyle_bank = {':','-.'}; % for prefered and null
title_str = {'Positive', 'Negative'};

%% special treatment for dt = 0; actually the same stimulus, calculate th
pos_epoch_individiual_response = squeeze(mean(resp_ind_cell_mat(epoch_index(1, :, 1),:,:), 1)); % for each fly, calculate the average response over 2 trials;
neg_epoch_individiual_response =  squeeze(mean(resp_ind_cell_mat(epoch_index(1, :, 2),:,:), 1)); 
resp_ave_dt_0 = zeros(2, 1); 
resp_sem_dt_0  = zeros(2, 1); 
[resp_ave_dt_0(1), resp_sem_dt_0(1)] = get_ave_sem(pos_epoch_individiual_response);
[resp_ave_dt_0(2), resp_sem_dt_0(2)] = get_ave_sem(neg_epoch_individiual_response);
 
%%

MakeFigure;
for pp = 1:1:n_par
    % two directions.
    subplot(2, 4, pp);
    color_use = color_bank(pp,:);
    for dd = 1:1:n_dir
        epoch_this = epoch_index(:, dd, pp);
        resp_ave_this = resp_ave(epoch_this);
        resp_sem_this = resp_sem(epoch_this);
        
        resp_ave_this(1) = resp_ave_dt_0(pp);
        resp_sem_this(1) = resp_sem_dt_0(pp);
        lineStyle_use = lineStyle_bank{dd};
        
        PlotXY_Juyue(x_axis_dt, resp_ave_this,'errorBarFlag',1,'sem',resp_sem_this,...
            'colorMean', color_use, 'colorError',color_use, 'lineStyle', lineStyle_use); hold on;
        %         set(gca,'YLim',[0,0.2]);
    end
    xlabel('\Delta t (ms)');
    ylabel('\DeltaF /F');
    title(title_str{pp});
    legend('preferred', 'null');
    ConfAxis('fontSize', 12);
    
    subplot(2, 4, pp + 4);
    for dd = 1:1:n_dir
        epoch_this = epoch_index(:, dd, pp);
        plot(x_axis_dt, get_individiual_recording(resp_over_time, epoch_this), 'LineStyle', lineStyle_bank{dd});
        hold on;
    end
    xlabel('\Delta t (ms)');
    ylabel('\DeltaF /F');
    title([title_str{pp}, '  individual recordings (colors)']);
    ConfAxis('fontSize', 12);
end

%% next, averaged the polarity first. add significant point.
epoch_index = data_info_over_dir.epoch_index;
[resp_ind_cell_mat, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_dir);

[~, p_sig, ~, ~] = ttest(squeeze(resp_ind_cell_mat)');
subplot(2, 4,3);
for pp = 1:1:n_par
    color_use = color_bank(pp,:);
    epoch_this = epoch_index(:,pp);
    resp_ave_this = resp_ave(epoch_this);
    resp_sem_this = resp_sem(epoch_this);
    
    %% put the dt = 0 into 0.
    resp_ave_this(1) = 0;
    resp_sem_this(1) = 0; % since they are the same stimulus.
    
    %%
    p_value_this = p_sig(epoch_this);
    PlotXY_Juyue(x_axis_dt,resp_ave_this,'errorBarFlag',1,'sem',resp_sem_this,...
        'colorMean', color_use, 'colorError',color_use); hold on;
    SAC_Plot_Utils_PlotSigPoint(x_axis_dt,resp_ave_this,p_value_this,alpha,false);
%     FigPlot_SK_Utils_GliderSignificance(x_axis_dt,p_value_this, alpha, maxValue ,false);
end
xlabel('\Delta t (ms)');
ylabel('\DeltaF /F');
legend('positive', 'negative');
title('preferred - null');
ConfAxis('fontSize', 12);
% set(gca, 'YLim', [-0.1, 0.1]);

%% plot the individual traces on top of mean.
epoch_index = data_info_over_dir.epoch_index;
subplot(2, 4, 7);
for pp = 1:1:n_par
    epoch_this = epoch_index(:,pp);
    plot(x_axis_dt, get_individiual_recording(resp_over_dir, epoch_this), 'color', color_bank(pp, :));
    hold on;
end
plot(get(gca, 'XLim'), [0,0], 'k--');
xlabel('\Delta t (ms)');
ylabel('\DeltaF /F');
title('preferred - null');
ConfAxis('fontSize', 12);

%% over all dt as well...
[resp_ind_cell_mat, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_dir_dt);
subplot(2, 4, 4);
resp_ind_cell_mat_plot = squeeze(resp_ind_cell_mat)';
bar_scatter_plot_Juyue(resp_ave, resp_sem, resp_ind_cell_mat_plot, color_bank);
% set(gca, 'YLim', [-0.02, 0.02]);
legend('positive', 'negative');
title('preferred - null (average over \Delta t)');
ylabel('\DeltaF /F');
ConfAxis('fontSize', 12);
end

function resp_individual = get_individiual_recording(resp, epoch_this)
resp_individual = cellfun(@(x) mean(x(:, :, epoch_this), 2), resp, 'UniformOutput', false);
resp_individual = squeeze(cat(1, resp_individual{:}));
end

function [mean_value, sem_value] = get_ave_sem(resp)
mean_value = mean(resp);
n_fly = length(resp);
sem_value = std(resp, 1)/sqrt(n_fly);
end