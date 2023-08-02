function resp_subtract = SAC_T4T5_LD_Utils_AppMot_Subtract_SingleBar(resp_two, data_info_two,...
    resp_single, data_info_single, plot_flag, save_fig, stim_info_two, epoch_ID_two, stim_info_single, epoch_ID_single, ...
    recording_info, phase_type, maxValue, figure_name)

maxValue_subtraction = 1.25;
%% parameters for subtraction.
% delay_flag = 1: The single bar response has to be shifted before
% subtraction.

% phase_offset: For the bar (in the two) with phase x, the correspoding
% single bar has x + phase_offset.

% There is always two bars. Set the bar with smaller index to be bar 1.

% if direction is 1. the second bar has to be delayed.
% if direction is -1. the first bar has to be delayed.
delay_flag = [0,1; 1,0];

% if direction is 1.
% The leading bar is bar 1, and it has the same phase as the epoch phase.
%The lagging bar phase is epoch phase + 1.

% if direction is -1.
% The lagging bar is bar 1, and it has the same phase as the epoch phase.
%The leading bar phase is epoch phase + 1.

phase_offset = [0, 1; 0, 1];


%%
epoch_index_two = data_info_two.epoch_index;
epoch_index_single = data_info_single.epoch_index;

%%
n_dir = 2;
n_cont = 2;
n_phase = size(data_info_two.epoch_index, 4);
n_cell = length(resp_two);

phase_bank = 1:n_phase;
resp_subtract = resp_two;
%%
for dd = 1:1:n_dir
    for bar_1 = 1:1:n_cont
        for bar_2 = 1:1:n_cont
            
            % c1 is bar_1. c2 is bar_2.
            if dd == 1
                % if direction is 1. leading bar is bar 1.
                epoch_two = epoch_index_two(bar_1, bar_2, dd, :);
            else
                % if direction is -1. lagging bar is bar 1. [leadcont, lagcont, dir, phase]
                epoch_two = epoch_index_two(bar_2, bar_1, dd, :);
            end
            
            bar_phase_1 = phase_bank + phase_offset(dd, 1);
            bar_phase_1 = mod(bar_phase_1 - 1, n_phase) + 1;
            epoch_single_rep_1 = epoch_index_single(bar_1, bar_phase_1);
            
            bar_phase_2 = phase_bank + phase_offset(dd, 2);
            bar_phase_2 = mod(bar_phase_2 - 1, n_phase + phase_type) + 1;
            epoch_single_rep_2 = epoch_index_single(bar_2, bar_phase_2);
            
            if delay_flag(dd, 1) == 1
                resp_single_1 = T4T5_LD_Utils_ShiftResp(resp_single, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
            else
                resp_single_1 = resp_single;
            end
            
            if delay_flag(dd, 2) == 1
                resp_single_2 = T4T5_LD_Utils_ShiftResp(resp_single, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
            else
                resp_single_2 = resp_single;
            end
            
            for cc = 1:1:n_cell
                resp_1 = resp_single_1{cc}(:, :, epoch_single_rep_1, :);
                resp_2 = resp_single_2{cc}(:, :, epoch_single_rep_2, :);
                resp_subtract{cc}(:,:, epoch_two(:), :) = resp_two{cc}(:, :, epoch_two(:), :) - resp_1 - resp_2;
            end
        end
    end
    
end

if plot_flag
    % plotting parameter.
    color_bank = [255, 0, 0; 77, 160, 248; 30, 190, 183]/255; % red, cornflower blue, deep koamaru
    second_bar_onset = recording_info.second_bar_onset;
    % epoch_index_single_rep = T4T5_LD_Utils_rep_epoch_index(epoch_index_single,'SingleBar','TwoSimultaneous');
    [~, resp_ave_two, resp_sem_two] = SAC_GetAverageResponse(resp_two);
    [~, resp_ave_single, resp_sem_single] = SAC_GetAverageResponse(resp_single);
    [~, resp_ave_sub, resp_sem_sub] = SAC_GetAverageResponse(resp_subtract);
    for dd = 1:1:n_dir
        for bar_1 = 1:1:n_cont
            for bar_2 = 1:1:n_cont
                
                % c1 is bar_1. c2 is bar_2.
                if dd == 1
                    % if direction is 1. leading bar is bar 1.
                    epoch_two = epoch_index_two(bar_1, bar_2, dd, :);
                else
                    % if direction is -1. lagging bar is bar 1. [leadcont, lagcont, dir, phase]
                    epoch_two = epoch_index_two(bar_2, bar_1, dd, :);
                end
                
                bar_phase_1 = phase_bank + phase_offset(dd, 1);
                bar_phase_1 = mod(bar_phase_1 - 1, n_phase) + 1;
                epoch_single_rep_1 = epoch_index_single(bar_1, bar_phase_1);
                
                bar_phase_2 = phase_bank + phase_offset(dd, 2);
                bar_phase_2 = mod(bar_phase_2 - 1, n_phase + phase_type) + 1;
                epoch_single_rep_2 = epoch_index_single(bar_2, bar_phase_2);
                
                if delay_flag(dd, 1) == 1
                    resp_ave_single_1= T4T5_LD_Utils_ShiftResp(resp_ave_single, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
                    resp_sem_single_1= T4T5_LD_Utils_ShiftResp(resp_sem_single, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
                    str_1 = 'shifted';
                else
                    resp_ave_single_1 = resp_ave_single;
                    resp_sem_single_1 = resp_sem_single;
                    str_1 = '';
                end
                
                if delay_flag(dd, 2) == 1
                    resp_ave_single_2 = T4T5_LD_Utils_ShiftResp(resp_ave_single, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
                    resp_sem_single_2 = T4T5_LD_Utils_ShiftResp(resp_sem_single, recording_info.second_bar_onset, recording_info.stim_onset, recording_info.f_resp);
                    str_2 = 'shifted';
                else
                    resp_ave_single_2 = resp_ave_single;
                    resp_sem_single_2 = resp_sem_single;
                    str_2 = '';
                end
                %
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
                    title(str_1);
                    
                    subplot(7, n_phase, ll + 2 * n_phase);
                    epoch_this = epoch_ID_single(epoch_single_rep_2(ll));
                    stim_cont = stim_info_single.epoch_cont(:, :, epoch_this);
                    T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, color_bank(3, :));
                    title(str_2);
                    
                    % also plot response.
                    % plot invidiual traces from three stimulus.
                    % plot the subtraction.
                    subplot(4, n_phase, ll + n_phase * 2);
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_two(:, epoch_two(ll)), resp_sem_two(:, epoch_two(ll)), color_bank(1, :),...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_single_1(:, epoch_single_rep_1(ll)), resp_sem_single_1(:, epoch_single_rep_1(ll)), color_bank(2, :),...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', maxValue); hold on;
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_single_2(:, epoch_single_rep_2(ll)), resp_sem_single_2(:, epoch_single_rep_2(ll)), color_bank(3, :),...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', maxValue, 'accessory', 1); hold on;
                    plot([second_bar_onset, second_bar_onset], get(gca, 'YLim'), 'k--'); % onset of the second bar.
                    set(gca, 'YLim', [-0.3, maxValue]);
                    
                    subplot(4, n_phase, ll + n_phase * 3);
                    T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave_sub(:, epoch_two(ll)), resp_sem_sub(:, epoch_two(ll)), [0,0,0],...
                        'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp,...
                        'limPreSetFlag', 1, 'maxValue', maxValue_subtraction, 'accessory', 1); hold on;
                    plot([second_bar_onset, second_bar_onset], get(gca, 'YLim'), 'k--'); % onset of the second bar.
                    %                     ConfAxis('fontSize',8, 'LineWidth', 1.5);
                end
                sgtitle(figure_name, 'Interpreter', 'none');
                if save_fig
                    MySaveFig_Juyue(gcf, [figure_name, '_apparent_motion_minus_single_bars'],[num2str(bar_1), num2str(bar_2), num2str(dd)], 'nFigSave',2,'fileType',{'png','fig'});
                end
            end
        end
    end
end
end