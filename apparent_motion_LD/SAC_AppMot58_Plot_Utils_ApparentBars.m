function SAC_AppMot58_Plot_Utils_ApparentBars(resp, data_info, stim_info, epoch_ID, recording_info, plotting_max_value, figure_name)
second_bar_onset = 0.15;
%% how about not plotting the four 4D? not necessary. just along the dimesion.
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;

n_lag = size(data_info.epoch_index, 4);
color_bank = [[1,0,0];[0,0,1]];
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);%% do averging

%% The leading and laging contrast are the same
MakeFigure;
for cc_lead = 1:1:2
    for cc_lag = 1:1:2
        for ll = 1:1:n_lag
            for dd = 1:1:2
                % plot the stimulus.
                subplot(n_lag * 2, 8,  (ll - 1)*8*2 + ((cc_lead-1)*2 + cc_lag - 1)*2 + dd);
                epoch_this = epoch_ID(epoch_index(cc_lead, cc_lag, dd,ll));
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont(:,:,epoch_this),color_bank(dd,:));
                title(num2str(epoch_this));
                
                % plot response
                subplot(n_lag * 2, 4,  (ll - 1)*4*2 +4+ (cc_lead-1)*2 + cc_lag);
                resp_ave_this = resp_ave(:, epoch_index(cc_lead, cc_lag, dd,ll));
                resp_sem_this = resp_sem(:, epoch_index(cc_lead, cc_lag, dd,ll));
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_this, resp_sem_this, color_bank(dd,:),...
                'stim_onset_sec', recording_info.stim_onset,...,
                'f_resp', recording_info.f_resp, 'limPreSetFlag', 1, 'maxValue', plotting_max_value, 'accessory', 1);
            end
            plot([second_bar_onset, second_bar_onset], get(gca, 'YLim'), 'k--'); % onset of the second bar.
            ConfAxis('fontSize',8, 'LineWidth', 1.5);
        end
    end
end
sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, 'TimeTrace', 'nFigSave',2,'fileType',{'png','fig'});

                