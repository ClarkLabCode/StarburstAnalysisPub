function SAC_AppMot_Plot_Utils_2D_Phase(resp, data_info, stim_info, epoch_ID,recording_info, maxValue, figure_name)
%% SAC_AverageResponse_By works only if the resp has been reorganized.
color_bank = [[1,0,0];[0,0,1]];

%% data_info.epoch_index = [leadCont, ladCont, Direction, lagPos]
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;
n_phase = size(data_info.epoch_index, 2);

%%
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);%% do averging
[resp_over_X, data_info_over_X, ~] = SAC_AverageResponse_By(resp, data_info, 'dirVal','sub',epoch_ID);
epoch_index_over_X = data_info_over_X.epoch_index;
[~, resp_over_X_ave, resp_over_X_sem] = SAC_GetAverageResponse(resp_over_X);

%% It is important that the for loop is the same as the
MakeFigure;
for ll = 1:1:n_phase
    %% determine the structure. should be consistent with function name.
    block_idx = ll; %% plot it somewhere.
    subplot_idx_diff_resp = block_idx * 3 ;
    subplot_idx_two_resp  = block_idx * 3 - 1;
    
    %% response averaged over X.
    epoch_over_X = epoch_index_over_X(ll);
    resp_ave_this = resp_over_X_ave(:, epoch_over_X);
    resp_sem_this = resp_over_X_sem(:, epoch_over_X);
    
    
    %% plot response averaged over X.
    subplot(n_phase * 3, 1, subplot_idx_diff_resp);
    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, [0,0,0],...
        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
        'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
    set(gca, 'YLim', [-0.3, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
    plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
    plot_utils_shade([0,0 + recording_info.stim_dur_sec], get(gca,'YLim'));
    ConfAxis('fontSize',10);
    
    if (ll == n_phase)
        xlabel('time (sec)');
    end
    
    %% plot stimulus and response before averaging.
    for dd = 1:1:2
        epoch_this = epoch_index(dd, ll);
        
        epoch_ID_this = epoch_ID(epoch_this,:); % epoch_ID_this has two dimensions.
        epoch_ID_this_reshape = reshape( epoch_ID_this, 2, 2);
        
        resp_ave_this = resp_ave(:, epoch_this);
        resp_sem_this = resp_sem(:, epoch_this);
        color_use = color_bank(dd,:);
        subplot(n_phase * 3, 1,  subplot_idx_two_resp);
        T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, color_use,...
            'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
            'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
        
        if dd == 2
            set(gca, 'YLim', [-0.3, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
            plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
            plot_utils_shade([0,0 + recording_info.stim_dur_sec], get(gca,'YLim'));
            ConfAxis('fontSize',10);
        end
        
        for cc_lead = 1:1:2
            for cc_lag = 1:1:2
                %% get the position of the subplot.
                block_idx_mega = (block_idx - 1) * 2 + dd;
                block_idx_tmp = (block_idx_mega - 1) * 2 + cc_lead;
                subplot_idx_stim  = floor((block_idx_tmp - 1)/ 4) * 16 + (block_idx_tmp - 1) * 2 + cc_lag; % read dd = 1, blue dd = 2;
                epoch_ID_one_epoch = epoch_ID_this_reshape(cc_lag,cc_lead);
                
                %% trial this would be two dimensionalll.
                subplot(n_phase * 3,8, subplot_idx_stim); % you also want to plot the
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