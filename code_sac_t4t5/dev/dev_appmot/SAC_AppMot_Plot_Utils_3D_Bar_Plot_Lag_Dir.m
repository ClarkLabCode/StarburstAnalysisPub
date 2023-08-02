function SAC_AppMot_Plot_Utils_3D_BarPlot_Lag_Dir(resp, data_info, stim_info, epoch_ID, recording_info, maxValue, figure_name)
%% SAC_AverageResponse_By works only if the resp has been reorganized.

%% data_info.epoch_index = [leadCont, ladCont, Direction, lagPos]
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;
n_lag = size(data_info.epoch_index, 3);

%% plotting parameters/
color_bank = [[1,0,0];[0,0,1]];
bar_width = 0.3;
x_axis = 0:(n_phase - 1);
x_axis_bank = [x_axis - bar_width/2; x_axis + bar_width/2];
x_lim_plot = [-0.5, n_phase + 0.5];

%% average over response.
resp_over_time = SAC_AppMot_Plot_Utils_BarPlot_GerAverageResponse_OverTime(resp, recording_info);
[resp_ave_ind, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_time);
[resp_over_X, data_info_over_X, ~] = SAC_AverageResponse_By(resp_over_time, data_info,'leadCont','sub',epoch_ID);
epoch_index_over_X = data_info_over_X.epoch_index;
[resp_over_X_ave_ind, resp_over_X_ave, resp_over_X_sem] = SAC_GetAverageResponse(resp_over_X);



%% It is important that the for loop is the same as the
MakeFigure;
for dd = 1:1:2 %  Lef and Right Pannel.
    for ll = 1:1:n_lag
        %% determine the structure. should be consistent with function name.
        block_mega_col = dd;
        
        %%
        block_idx = block_mega_col; %% plot it somewhere.
        subplot_idx_diff_resp = 2 + block_idx;
        subplot_idx_two_resp  = 4 + block_idx;
        
        %% response averaged over X.
        epoch_over_X = epoch_index_over_X(dd, ll);
        resp_ave_this = resp_over_X_ave(:, epoch_over_X);
        resp_sem_this = resp_over_X_sem(:, epoch_over_X);
        
        
        %% plot response averaged over X.
        subplot(n_lag * 3, 2, subplot_idx_diff_resp);
        T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, [0,0,0],...
            'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
            'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
        
        set(gca, 'YLim', [-1, 1] * maxValue * 0.75, 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1], 'XTickLabel', []);
        plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
        ConfAxis('fontSize',10);
        
        if (ll == n_lag)
            xlabel('time (sec)');
        end
        
        %% plot stimulus and response before averaging.
        for cc_lead = 1:1:2
            epoch_this = epoch_index(cc_lead,dd, ll);
            
            epoch_ID_this = epoch_ID(epoch_this,:); % epoch_ID_this has two dimensions.
            resp_ave_this = resp_ave(:, epoch_this);
            resp_sem_this = resp_sem(:, epoch_this);
            color_use = color_bank(cc_lead,:);
            
            %% plot response of individual traces.
            subplot(n_lag * 3, 2,  subplot_idx_two_resp);
            T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, color_use,...
                'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
            if cc_lead == 2
                set(gca, 'YLim', [-0.2, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1], 'XTickLabel', []);
                plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
                ConfAxis('fontSize',10);
            end
            
            %% plot stimulus
            for cc_lag = 1:1:2
                %% get the position of the subplot.
                block_idx_tmp = (block_idx - 1) * 2 + cc_lead;
                subplot_idx_stim  = floor((block_idx_tmp - 1)/ 4) * 16 + (block_idx_tmp - 1) * 2 + cc_lag; % read dd = 1, blue dd = 2;
                
                subplot(n_lag * 3,8, subplot_idx_stim); % you also want to plot the
                
                %% epoch_ID_this has two values.
                epoch_ID_one_epoch = epoch_ID_this(cc_lag);
                stim = stim_cont(:,:,abs(epoch_ID_one_epoch));
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim, color_use)
                title(num2str(epoch_ID_one_epoch));
            end
        end
    end
end

sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});
end