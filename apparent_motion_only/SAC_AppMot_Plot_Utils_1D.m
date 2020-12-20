function SAC_AppMot_Plot_Utils_1D(resp, data_info, stim_info, epoch_ID, recording_info, maxValue, figure_name)
%% SAC_AverageResponse_By works only if the resp has been reorganized.

%% data_info.epoch_index = [leadCont, ladCont, Direction, lagPos]
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;
n_phase = size(data_info.epoch_index, 1);

%%
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);%% do averging
[resp_over_X, ~, ~] = SAC_AverageResponse_By(resp, data_info, 'phase','mean',epoch_ID);
[~, resp_over_X_ave, resp_over_X_sem] = SAC_GetAverageResponse(resp_over_X);

%%
color_bank = flipud(brewermap(n_phase, 'GnBu'));
MakeFigure;
subplot(n_phase + 2, 1, n_phase + 2);
T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_over_X_ave, resp_over_X_sem, [0,0,0],...
    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
    'limPreSetFlag', 1, 'maxValue', maxValue, 'accessory', 0); hold on;

set(gca, 'YLim', [-0.3, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
plot_utils_shade([0,0 + recording_info.stim_dur_sec], get(gca,'YLim'));
plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
xlabel('time (sec)');
title('averaged across four phases');
ConfAxis('fontSize',10);

for ll = 1:1:n_phase
    epoch_this = epoch_index(ll);
    epoch_ID_this = epoch_ID(epoch_this,:); % epoch_ID_this has two dimensions.
    color_use = color_bank(ll,:);
    subplot(n_phase + 2, 1,  n_phase + 1);
    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_this), resp_sem(:, epoch_this), color_use,...
        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
        'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
    if ll == n_phase
        set(gca, 'YLim', [-0.3, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
        plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
        plot_utils_shade([0,0 + recording_info.stim_dur_sec], get(gca,'YLim'));
        title('invidiual phases');
        ConfAxis('fontSize',10);
        
    end
    for ss = 1:length(epoch_ID_this)
        subplot(n_phase + 2, 8, (ll - 1) * 8 + ss)
        epoch_ID_one_epoch = epoch_ID_this(ss);
        stim = stim_cont(:,:,abs(epoch_ID_one_epoch));
        T4T5_Plot_Utils_PlotStimCont_YReverse(stim, color_use)
        title(num2str(epoch_ID_one_epoch));
    end
end


sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});
end
