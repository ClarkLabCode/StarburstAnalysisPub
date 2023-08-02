function SAC_AppMot_Plot_Utils_2D_BarPlot_Phase(resp, data_info, stim_info, epoch_ID,recording_info, plot_max_value, figure_name)
%% SAC_AverageResponse_By works only if the resp has been reorganized.

%% data_info.epoch_index = [leadCont, ladCont, Direction, lagPos]
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;
n_phase = size(data_info.epoch_index, 2);

%% plotting parameters/
color_bank = [[1,0,0];[0,0,1]];
bar_width = 0.3;
x_axis = 0:(n_phase - 1);
x_axis_bank = [x_axis - bar_width/2; x_axis + bar_width/2];
x_lim_plot = [-0.5, n_phase - 0.5];

%% average over response.
resp_over_time = SAC_AppMot_Plot_Utils_BarPlot_GerAverageResponse_OverTime(resp, recording_info);
[resp_ave_ind, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_time);
[resp_over_X, data_info_over_X, ~] = SAC_AverageResponse_By(resp_over_time, data_info,'dirVal','sub',epoch_ID);
epoch_index_over_X = data_info_over_X.epoch_index;
[resp_over_X_ave_ind, resp_over_X_ave, resp_over_X_sem] = SAC_GetAverageResponse(resp_over_X);

%% It is important that the for loop is the same as the
MakeFigure;
%% determine the structure. should be consistent with function name.
block_idx = 1; %% plot it somewhere.
subplot_idx_two_resp  = 2;
subplot_idx_diff_resp = 3;

%% plot stimulus,
for dd = 1:1:2
    epoch_this = epoch_index(dd, 1); % this has to be the original...
    epoch_ID_this = epoch_ID(epoch_this,:); % epoch_ID_this has two dimensions.
    epoch_ID_this_reshape = reshape( epoch_ID_this, 2, 2);
    color_use = color_bank(dd,:);
    for cc_lead = 1:1:2
        for cc_lag = 1:1:2
            %% get the position of the subplot.
            block_idx_mega = (block_idx - 1) * 2 + dd;
            block_idx_tmp = (block_idx_mega - 1) * 2 + cc_lead;
            subplot_idx_stim  = floor((block_idx_tmp - 1)/ 4) * 16 + (block_idx_tmp - 1) * 2 + cc_lag; % read dd = 1, blue dd = 2;
            epoch_ID_one_epoch = epoch_ID_this_reshape(cc_lag, cc_lead);
            
            %% trial this would be two dimensionalll.
            subplot(3,8, subplot_idx_stim); % you also want to plot the
            stim = stim_cont(:,:,abs(epoch_ID_one_epoch));
            T4T5_Plot_Utils_PlotStimCont_YReverse(stim, color_use)
            title(num2str(epoch_ID_one_epoch));
        end
    end
end

%% plot response before subtraction.
for dd = 1:1:2
    xaxis_this = x_axis_bank(dd, :);
    [resp_ave_this, resp_sem_this, resp_ind_this, color_this] = ...
        SAC_AppMot_Plot_Utils_BarPlot_GetResponsesAtDifferentPhases(resp_ave, resp_sem, resp_ave_ind, epoch_index(dd, :), color_bank(dd,:));
    subplot(3, 1,  subplot_idx_two_resp);
    bar_scatter_plot_Juyue(resp_ave_this, resp_sem_this, resp_ind_this',  color_this,...,
        'link_dots_flag', 0, 'xaxis', xaxis_this, 'bar_width', bar_width,...
        'plot_individual_dot', 0, 'do_sig_test_flag', 1, 'plot_max_value',  plot_max_value);
end
SAC_Plot_Utils_BarPlot_Setup_Axis(x_lim_plot, [-plot_max_value, plot_max_value], x_axis, 0);

%% plot the response after subtraction.
[resp_ave_this, resp_sem_this, resp_ind_this, color_this] = ...
    SAC_AppMot_Plot_Utils_BarPlot_GetResponsesAtDifferentPhases(resp_over_X_ave, resp_over_X_sem,  resp_over_X_ave_ind, epoch_index_over_X, [0,0,0]);
subplot(3, 1,  subplot_idx_diff_resp);
bar_scatter_plot_Juyue(resp_ave_this, resp_sem_this, resp_ind_this',  color_this,...,
    'link_dots_flag', 0, 'xaxis', x_axis, 'bar_width', bar_width,...
    'plot_individual_dot', 0, 'do_sig_test_flag', 1, 'plot_max_value',  plot_max_value);
SAC_Plot_Utils_BarPlot_Setup_Axis(x_lim_plot, [-plot_max_value, plot_max_value], x_axis, 1);


%% plot the response.


sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});
end