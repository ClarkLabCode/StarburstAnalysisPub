function SAC_T4T5_SingleBar_Plot_Utils_RawResp(resp, data_info, stim_info, epoch_ID, recording_info, maxValue, figure_name)

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
epoch_index = data_info.epoch_index;
n_phase = size(epoch_index, 2);
%% do not like color plot. could not see the sem.
MakeFigure;
for cc = 1:1:2
    for ll = 1:1:n_phase
        stim_plot_idx = (cc - 1) * n_phase * 2 + ll;
        resp_plot_idx = (cc - 1) * n_phase * 2 + ll + n_phase;
        resp_ave_this = resp_ave(:, epoch_index(cc, ll));
        resp_sem_this = resp_sem(:, epoch_index(cc, ll));
        epoch_ID_this = epoch_ID(epoch_index(cc, ll));

        %% plot time traces.
        subplot(4, n_phase, resp_plot_idx);
        T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, [0,0,0],...
            'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp, ...
            'limPreSetFlag', 1, 'maxValue', maxValue, 'accessory', 1);
        plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k-');
        set(gca,'YLim', [-0.2, maxValue]);
        
        %% plot stimulus
        subplot(4, n_phase, stim_plot_idx)
        stim_cont = stim_info.epoch_cont(:, :, epoch_ID_this);
        T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, [0,0,0]);
    end
end
sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, 'single_bars_time_traces', 'nFigSave',2,'fileType',{'png','fig'});
end