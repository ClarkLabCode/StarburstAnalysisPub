function figure_opponent()
set(0,'defaultAxesFontName', 'Arial')

%% visualization specs
meta_info.N = 90;
meta_info.SAC_N = 45;
colors = {[23,31,89]/100; [89,23,31]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % null direction color, preferred direction color.
left = 72;
% colors = {[88,35,41]/255; [23, 59, 68]/255};

%% 1. plot visual stimulus
MakeFigure_Paper;
visual_stimulus_sinewave_oppoenent_stimulus(meta_info, colors, left);

%% 2. prepare response
stim_name = 'sinewave_opponent';
[stim_info, data_info] = SAC_Opponency_2020_Utils_GetStimParam();
% resp = SAC_GetResponse_OneStim(stim_name,  'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
disp(['sinewav/counter-phase response n = ', num2str(length((resp)))]);

epoch_ID = data_info.epoch_index(:);

[resp_over_phase, data_info_over_phase, epoch_ID_over_phase] = SAC_AverageResponse_By(resp, data_info, 'phase', 'mean', epoch_ID);

%% 3. plot averaged time traces
colors = {colors{2}, colors{1}, colors{3}}; % later on, preferred direction is plotted first. 
ax_w = 297; ax_h = 54;
figure_opponent_time_trace(resp_over_phase, colors, left, 480, ax_w, ax_h);

%% 4. bar plot
ax_w = 54; ax_h = 108; top = 300;
% prepare data for SAC
resp_ind_cell_mat_SAC = prepare_data_for_SAC(resp_over_phase, stim_info);
figure_opponent_barplot_plot_utils(resp_ind_cell_mat_SAC, colors, left, top, ax_w, ax_h, 0.5);
ylabel('SAC (\DeltaF/F)', 'FontSize', 10);
set(gca, 'YTick', [0, 0.25, 0.5],'YTickLabelRotation', 90);
% prepare data for T4T5
resp_ind_cell_mat_T4T5 = prepare_data_for_T4();
figure_opponent_barplot_plot_utils(resp_ind_cell_mat_T4T5, colors, 180 + 10, top, ax_w, ax_h,  0.75);
ylabel('T4T5 (\DeltaF/F)', 'FontSize', 10);
set(gca, 'YTick', [0, 0.25, 0.5, 0.75, 1],'YTickLabelRotation', 90);

% prepare data for LN model
resp_ind_cell_mat_LN = [1 0.7, 1.5];
figure_opponent_barplot_plot_utils(resp_ind_cell_mat_LN, colors, 288, top, ax_w, ax_h, 1.7);
set(gca, 'YTick', []);ylabel('LN model (a.u.)');
MySaveFig_Juyue(gcf, 'figure_5_sinewave_opponent', 'v3','nFigSave',1,'fileType',{'fig'});

end

function resp_ind_cell_mat = prepare_data_for_SAC(resp, stim_info)
[on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param.temporal_frequency);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_idx(:), off_idx(:));
[resp_ind_cell_mat, ~, ~] = SAC_GetAverageResponse(resp_over_time);
resp_ind_cell_mat = squeeze(resp_ind_cell_mat)';

end

function resp_ind_cell_mat = prepare_data_for_T4()
S = GetSystemConfiguration;
data = load(fullfile(S.cached_T4T5_data_path, 'T4T5_Opponency_NatureNeuroscience_2019.mat'));
resp_ind_cell_mat = data.combinedPD{1};
resp_ind_cell_mat = resp_ind_cell_mat(:, 1:3);
end
