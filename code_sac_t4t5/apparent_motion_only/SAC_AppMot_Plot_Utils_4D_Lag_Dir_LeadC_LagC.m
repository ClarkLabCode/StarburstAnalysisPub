function SAC_AppMot_Plot_Utils_4D_Lag_Dir_LeadC_LagC(resp, data_info, stim_info, epoch_ID, recording_info, maxValue,figure_name)

%% SAC_AverageResponse_By works only if the resp has been reorganized.
%% plotting parameters/
color_bank = [[1,0,0];[0,0,1]];

%% data_info.epoch_index = [leadCont, ladCont, Direction, lagPos]
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;
n_phase = size(data_info.epoch_index, 4);

%% average response.
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
[resp_over_X, data_info_over_X, ~] = SAC_AverageResponse_By(resp, data_info,'lagCont','sub',epoch_ID);
epoch_index_over_X = data_info_over_X.epoch_index;
[~, resp_over_X_ave, resp_over_X_sem] = SAC_GetAverageResponse(resp_over_X);


%% It is important that the for loop is the same as the
MakeFigure;
for cc_lead = 1:1:2 %  Lef and Right Pannel.
    for ll = 1:1:n_phase
        for dd = 1:1:2
            
            %% organize the the index. (see slides in log.)
            block_row = ll;
            block_mega_col = dd;
            block_smaller_col = cc_lead; % direction...
            %%
            block_idx = (block_row - 1) * 4 + (block_mega_col - 1) * 2 + block_smaller_col; %% plot it somewhere.
            subplot_idx_diff_resp = floor((block_idx - 1) / 4) * 8 + 8 + block_idx;
            subplot_idx_two_resp  = floor((block_idx - 1) / 4) * 8 + 4 + block_idx ;
            
            %%
            epoch_over_X = epoch_index_over_X(cc_lead, dd, ll);
            resp_ave_this = resp_over_X_ave(:, epoch_over_X);
            resp_sem_this = resp_over_X_sem(:, epoch_over_X);
            
            
            %% the diff has been calculated across rois.
            subplot(n_phase * 3, 4, subplot_idx_diff_resp);
            T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, [0,0,0],...
                'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
            set(gca, 'YLim', [-0.3, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
            plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
            plot_utils_shade([0,0 + recording_info.stim_dur_sec], get(gca,'YLim'));
            ConfAxis('fontSize',10);
            
            %% do something to the label.
            if ll == n_phase
                xlabel('time (s)');
            end
            
            for cc_lag = 1:1:2
                epoch_this = epoch_index(cc_lead, cc_lag, dd, ll);
                epoch_ID_this = epoch_ID(epoch_this,:); % epoch_ID_this has two dimensions.
                resp_ave_this = resp_ave(:, epoch_this);
                resp_sem_this = resp_sem(:, epoch_this);
                color_use = color_bank(cc_lag,:);
                
                %% plot stimulus
                subplot_idx_stim  = floor((block_idx - 1)/ 4) * 16 + (block_idx - 1) * 2 + cc_lag; % read dd = 1, blue dd = 2;                
                subplot(n_phase * 3,8, subplot_idx_stim); % you also want to plot the
                stim_cont_this = stim_cont(:,:,abs(epoch_ID_this));
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont_this, color_use);
                title(num2str(epoch_ID_this));
                
                %% plot response.
                subplot(n_phase * 3, 4,  subplot_idx_two_resp);
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, color_use,...
                    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                    'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
                
                if cc_lag == 2
                    set(gca, 'YLim', [-0.2, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
                    plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
                    plot_utils_shade([0,0 + recording_info.stim_dur_sec], get(gca,'YLim'));
                    ConfAxis('fontSize',10);
                end
                

            end
        end
    end
end

sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});