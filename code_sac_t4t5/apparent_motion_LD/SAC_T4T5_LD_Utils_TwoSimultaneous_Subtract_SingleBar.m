function resp_subtract = SAC_T4T5_LD_Utils_TwoSimultaneous_Subtract_SingleBar(resp_two, data_info_two,...
    resp_single, data_info_single, plot_flag, save_fig, stim_info_two, epoch_ID_two, stim_info_single, epoch_ID_single, recording_info, phase_type, maxValue, figure_name)
%% parameters for subtraction.
% phase_offset: For the bar (in the two) with phase x, the correspoding
% single bar has x + phase_offset.
maxValue_subtraction = 1;
phase_offset = [0, 1]; % two bars.
color_bank = [255, 0, 0; 77, 160, 248; 30, 190, 183]/255; % red, cornflower blue, deep koamaru
%%
epoch_index_two = data_info_two.epoch_index;
epoch_index_single = data_info_single.epoch_index;

%%
n_cont = 2;
n_phase = size(data_info_two.epoch_index, 3);
n_cell = length(resp_two);

phase_bank = 1:n_phase;
resp_subtract = resp_two;
%%
for bar_1 = 1:1:n_cont
    for bar_2 = 1:1:n_cont
        
        % c1 is bar_1. c2 is bar_2.
        epoch_two = epoch_index_two(bar_1, bar_2, :);
        bar_phase_1 =  phase_bank;
        epoch_single_rep_1 = epoch_index_single(bar_1, bar_phase_1);
        bar_phase_2 = mod(phase_bank + 1 - 1, n_phase + phase_type) + 1;
        epoch_single_rep_2 = epoch_index_single(bar_2, bar_phase_2);
        for cc = 1:1:n_cell
            resp_1 = resp_single{cc}(:, :, epoch_single_rep_1, :);
            resp_2 = resp_single{cc}(:, :, epoch_single_rep_2, :);
            resp_subtract{cc}(:,:, epoch_two(:), :) = resp_two{cc}(:, :, epoch_two(:), :) - resp_1 - resp_2;
        end
    end
end


if plot_flag
    %%
    [~, resp_ave_two, resp_sem_two] = SAC_GetAverageResponse(resp_two);
    [~, resp_ave_single, resp_sem_single] = SAC_GetAverageResponse(resp_single);
    [~, resp_ave_sub, resp_sem_sub] = SAC_GetAverageResponse(resp_subtract);
    
    for bar_1 = 1:1:n_cont
        for bar_2 = 1:1:n_cont
            
            % c1 is bar_1. c2 is bar_2.
            epoch_two = epoch_index_two(bar_1, bar_2, :);
            bar_phase_1 =  phase_bank;
            epoch_single_rep_1 = epoch_index_single(bar_1, bar_phase_1);
            bar_phase_2 = mod(phase_bank + 1 - 1, n_phase + phase_type) + 1;
            epoch_single_rep_2 = epoch_index_single(bar_2, bar_phase_2);
            
            %% you also want the final result. do you?
            MakeFigure;
            for ll = 1:1:n_phase
                % first, plot the simultaneous bars.
                subplot(7, n_phase, ll);
                epoch_this = epoch_ID_two(epoch_two(ll));
                stim_cont = stim_info_two.epoch_cont(:, :, epoch_this);
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, color_bank(1, :));
                
                subplot(7, n_phase, ll + n_phase);
                epoch_this = epoch_ID_single(epoch_single_rep_1(ll));
                stim_cont = stim_info_single.epoch_cont(:, :, epoch_this);
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, color_bank(2, :));
                
                
                subplot(7, n_phase, ll + 2 * n_phase);
                epoch_this = epoch_ID_single(epoch_single_rep_2(ll));
                stim_cont = stim_info_single.epoch_cont(:, :, epoch_this);
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, color_bank(3, :));
                
                % also plot response.
                % plot invidiual traces from three stimulus.
                % plot the subtraction.
                subplot(4, n_phase, ll + n_phase * 2);
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_two(:, epoch_two(ll)), resp_sem_two(:, epoch_two(ll)), color_bank(1, :),...
                    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                    'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_single(:, epoch_single_rep_1(ll)), resp_sem_single(:, epoch_single_rep_1(ll)), color_bank(2, :),...
                    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                    'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_single(:, epoch_single_rep_2(ll)), resp_sem_single(:, epoch_single_rep_2(ll)), color_bank(3, :),...
                    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                    'limPreSetFlag', 1, 'maxValue', maxValue, 'accessory', 1); hold on;
                set(gca, 'YLim', [-0.2, maxValue]);
                
                subplot(4, n_phase, ll + n_phase * 3);
                T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_sub(:, epoch_two(ll)), resp_sem_sub(:, epoch_two(ll)), [0,0,0],...
                    'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                    'limPreSetFlag', 1, 'maxValue', maxValue_subtraction, 'accessory', 1); hold on;
            end
            sgtitle(figure_name, 'Interpreter', 'none');
            if save_fig
                MySaveFig_Juyue(gcf, [figure_name, '_two_simultanous_bars_minus_single_bars'],[num2str(bar_1), num2str(bar_2)], 'nFigSave',2,'fileType',{'png','fig'});
            end
        end
    end
end
% Interesting... 8 phases together...
% for bb = 1:1:2
%     for cc = 1:1:n_cont
%         bar_phase = mod(phase_bank + phase_offset(bb) - 1, n_phase) + 1;
%         if bb == 1
%             epoch_two = epoch_index_two(cc, :, :);
%             epoch_single_rep = epoch_index_single_rep(cc, :, bar_phase);
%         elseif bb == 2
%             epoch_two = epoch_index_two(:, cc, :);
%             epoch_single_rep =  epoch_index_single_rep(:, cc, bar_phase);
%         end
%         resp_two{cc}(epoch_two(:)) = resp_two{cc}(epoch_two(:)) - resp_single{cc}(epoch_single_rep(:));
%     end
% end
end
