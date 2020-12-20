function resp_subtract = SAC_T4T5_LD_Utils_AppMot_Subtract_Simultaneous(resp_am, data_info_am,...
    resp_simultaneous, data_info_simultaneous, plot_flag, save_fig, stim_info_am, epoch_ID_am, stim_info_simultaneous, epoch_ID_simultaneous, recording_info, maxValue, figure_name)

%%
epoch_index_simultaneous = data_info_simultaneous.epoch_index;
epoch_index_am = data_info_am.epoch_index;
resp_simultaneous_shifted = T4T5_LD_Utils_ShiftResp(resp_simultaneous, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
%%
n_dir = 2;
n_cont = 2;
n_phase = size(data_info_am.epoch_index, 4);
n_cell = length(resp_am);

resp_subtract = resp_am;
%%
for dd = 1:1:n_dir
    for bar_1_cont = 1:1:n_cont % bar 1 has a smaller spatial index.
        for bar_2_cont = 1:1:n_cont % bar 2 has a smaller spatial index.
            % This should be fine.
            if dd == 1
                % if direction is 1. leading bar is bar 1.
                epoch_am = epoch_index_am(bar_1_cont, bar_2_cont, dd, :);
            else
                % if direction is 1. leading bar is bar 1.
                epoch_am = epoch_index_am(bar_2_cont, bar_1_cont, dd, :);
            end
            epoch_simultaneous = epoch_index_simultaneous(bar_1_cont, bar_2_cont, :);
            for cc = 1:1:n_cell
                resp_subtract{cc}(:,:, epoch_am(:), :) =  resp_am{cc}(:,:, epoch_am(:), :) - resp_simultaneous_shifted{cc}(:, :, epoch_simultaneous(:), :);
            end
        end
    end
    
end

if plot_flag
    % plotting parameter.
    color_bank = [255, 0, 0; 77, 160, 248; 30, 190, 183]/255; % red, cornflower blue, deep koamaru
    second_bar_onset = recording_info.second_bar_onset;
    % epoch_index_single_rep = T4T5_LD_Utils_rep_epoch_index(epoch_index_single,'SingleBar','TwoSimultaneous');
    [~, resp_ave_am, resp_sem_am] = SAC_GetAverageResponse(resp_am);
    [~, resp_ave_simultaneous_shifted, resp_sem_simultaneous_shifted] = SAC_GetAverageResponse(resp_simultaneous_shifted);
    [~, resp_ave_sub, resp_sem_sub] = SAC_GetAverageResponse(resp_subtract);
    
    for dd = 1:1:n_dir
        for bar_1_cont = 1:1:n_cont % bar 1 has a smaller spatial index.
            for bar_2_cont = 1:1:n_cont % bar 2 has a smaller spatial index.
                % This should be fine.
            if dd == 1
                % if direction is 1. leading bar is bar 1.
                epoch_am = epoch_index_am(bar_1_cont, bar_2_cont, dd, :);
            else
                % if direction is 1. leading bar is bar 1.
                epoch_am = epoch_index_am(bar_2_cont, bar_1_cont, dd, :);
            end
            epoch_simultaneous = epoch_index_simultaneous(bar_1_cont, bar_2_cont, :);


                MakeFigure;
                for ll = 1:1:n_phase
                    % first, plot the simultaneous bars.
                    subplot(4, n_phase, ll);
                    epoch_this = epoch_ID_am(epoch_am(ll));
                    stim_cont = stim_info_am.epoch_cont(:, :, epoch_this);
                    T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, color_bank(1, :));
                    
                    subplot(4, n_phase, ll + n_phase);
                    epoch_this = epoch_ID_simultaneous(epoch_simultaneous(ll));
                    stim_cont = stim_info_simultaneous.epoch_cont(:, :, epoch_this);
                    T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, color_bank(2, :));
                    title('shifted')

                    % also plot response.
                    % plot invidiual traces from three stimulus.
                    % plot the subtraction.
                    subplot(4, n_phase, ll + n_phase * 2);
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_am(:, epoch_am(ll)), resp_sem_am(:, epoch_am(ll)), color_bank(1, :),...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_simultaneous_shifted(:, epoch_simultaneous(ll)), resp_sem_simultaneous_shifted(:, epoch_simultaneous(ll)), color_bank(2, :),...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', maxValue, 'accessory', 1); hold on;
                    plot([second_bar_onset, second_bar_onset], get(gca, 'YLim'), 'k--'); 
                    
                    subplot(4, n_phase, ll + n_phase * 3);
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_sub(:,epoch_am(ll)), resp_sem_sub(:,epoch_am(ll)), [0,0,0],...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', 0.4, 'accessory', 1); hold on;
                    plot([second_bar_onset, second_bar_onset], get(gca, 'YLim'), 'k--'); 
                    set(gca, 'YLim', [-0.6, 0.6]);
                    
                end
                sgtitle(figure_name, 'Interpreter', 'none');
                if save_fig
                    MySaveFig_Juyue(gcf, [figure_name, '_apparent_motion_minus_two_simultanous_bars'],[num2str(bar_1_cont), num2str(bar_2_cont), num2str(dd)], 'nFigSave',2,'fileType',{'png','fig'});
                end
                
            end
        end
    end
end