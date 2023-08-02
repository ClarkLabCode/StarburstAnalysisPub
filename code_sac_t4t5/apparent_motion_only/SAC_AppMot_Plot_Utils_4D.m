function SAC_AppMot_Plot_Utils_4D(resp, data_info, stim_info, epoch_ID, recording_info, maxValue, figure_name)
%% how about not plotting the four 4D? not necessary. just along the dimesion.
epoch_index = data_info.epoch_index;
stim_cont = stim_info.epoch_cont;

n_phase = size(data_info.epoch_index, 4);
color_bank = [[1,0,0];[0,0,1]];
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);%% do averging

%% The leading and laging contrast are the same
MakeFigure;
for ll = 1:1:n_phase
    for cc_lead = 1:1:2
        for cc_lag = 1:1:2
            for dd = 1:1:2
                
                % plot the stimulus.
                subplot(n_phase * 2,8,  (ll - 1)*8*2 + ((cc_lead-1)*2+cc_lag - 1)*2 + dd);
                epoch_this = epoch_index(cc_lead, cc_lag, dd,ll);
                epoch_ID_this = epoch_ID(epoch_this);
                stim_cont_this = stim_cont(:,:,epoch_ID_this);
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont_this, [0,0,0]);
                set(gca, 'XColor', color_bank(dd,:),'YColor', color_bank(dd,:));
                box on
                title(num2str(epoch_ID_this));
                
                % plot response
                subplot(n_phase * 2, 4,  (ll - 1)*4*2 +4+ (cc_lead-1)*2+cc_lag);
                resp_this_mean = resp_ave(:, epoch_this);
                resp_this_std = resp_sem(:, epoch_this);
                
                %%
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_this_mean, resp_this_std, color_bank(dd,:),...
                    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                    'limPreSetFlag', 1, 'maxValue', maxValue, 'accessory', 1); hold on;
                if dd == 2
                    set(gca, 'YLim', [-0.2, maxValue], 'YTick', [0,0.5], 'XTick', [0, recording_info.second_bar_onset, 1]);
                    plot(ones(2, 1) * recording_info.second_bar_onset, get(gca, 'YLim'), 'k--');
                    ConfAxis('fontSize',10);
                end
            end
        end
    end
end


sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, '', 'nFigSave',2,'fileType',{'png','fig'});