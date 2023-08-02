function SAC_T4T5_TwoSimultaneousBars_Plot_Utils_RawResp(resp, data_info, stim_info, epoch_ID, recording_info, maxValue, emphasize_negative, figure_name)
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
epoch_index = data_info.epoch_index;
n_phase = size(epoch_index, 3);
%% do not like color plot. could not see the sem.
MakeFigure;
for cc_bar_1 = 1:1:2
    for cc_bar_2 = 1:1:2
        block_idx = (cc_bar_1 - 1) * 2 + cc_bar_2; %% 1, 2, 3, 4
        for ll = 1:1:n_phase
            stim_plot_idx = (block_idx - 1) * n_phase * 2 + ll;
            resp_plot_idx = (block_idx - 1) * n_phase * 2 + ll + n_phase;
            resp_ave_this = resp_ave(:, epoch_index(cc_bar_1, cc_bar_2, ll));
            resp_sem_this = resp_sem(:, epoch_index(cc_bar_1, cc_bar_2, ll));
            epoch_ID_this = epoch_ID(epoch_index(cc_bar_1, cc_bar_2, ll));
            
            %% plot response time traces
            subplot(8, n_phase, resp_plot_idx);
            T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, [0,0,0],...
                'stim_onset_sec', recording_info.stim_onset,...,
                'f_resp', recording_info.f_resp,...
                'limPreSetFlag', 1, 'maxValue',maxValue, 'accessory', 1);
            if emphasize_negative
                set(gca,'YLim', [-maxValue, min(maxValue * 0.5, 0.2)]);
            else
                set(gca,'YLim', [-min(maxValue * 0.5, 0.2), maxValue]);
            end
            
            %% plot stimulus
            subplot(8, n_phase , stim_plot_idx)
            stim_cont = stim_info.epoch_cont(:, :, epoch_ID_this);
            T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, [0,0,0]);
        end
    end
end
sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '_two_simultanous_bars', 'nFigSave',2,'fileType',{'png','fig'});
end