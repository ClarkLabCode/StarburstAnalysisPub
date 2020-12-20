function figure_single_bar()
set(0,'defaultAxesFontName', 'Arial')
set(0,'DefaultAxesTitleFontWeight','normal');

left_1 = 36; left_2 = left_1 + 81; left_3 = left_1 + 210; left_4 = left_1 + 400; top = 600; % plot four static ring.

%% 1. plot visual stimulus
MakeFigure_Paper;
ax_w = 36; ax_h = 60;
visual_stimulus_single_and_two_simultaneous_bars('single_bar', left_1, left_3, left_4, top, ax_w, ax_h)

%% 2. prepare response SAC
stim_name = 'apparent_motion';
recording_info = get_sac_recording_information(stim_name);
epoch_ID = (1:58)';

% resp = SAC_GetResponse_OneStim(stim_name, 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
disp(['single ring response n = ', num2str(length((resp)))]);

[~, data_info_single] = SAC_SingleBar_Utils_GetStimParam();
[resp_single, ~, data_info_single] = T4T5_OrganizeRespInit(resp, data_info_single, epoch_ID);


%% 3. plot time traces
ax_w = 64;
time_traces(resp_single, data_info_single, left_2, top, ax_w, ax_h)

%% 4. plot analysis plot
% plot bar plot. SAC;
ax_w = 120; plot_max_value = 0.5;
figure_single_bar_utils_bar_plot(resp_single, data_info_single, recording_info, plot_max_value, 0, left_3, top, ax_w, ax_h);
xlabel('ring position (50\mum)', 'FontSize', 10, 'Interpreter', 'tex');


%% 5. plot analysis plot for T4T5.
% get data.
thresh = 3; % light/dark single bar at rf center is larger than 3.
rf_center = 5;
dataset_name = 'next_neighbor';
recording_info_T4T5 = get_t4t5_recording_info_apparent_motion();
% resp = T4T5_AppMot_GetResponse_OneCellType(1,  dataset_name);
resp_T4T5 = COVID_19_load_tmp_data(stim_name, 'T4_Pro', dataset_name);
epoch_ID_T4T5 = (1:112)';

[~, data_info_single_T4T5] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
[resp_single_T4T5_orig, ~, data_info_single_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_single_T4T5, epoch_ID_T4T5);
resp_single_T4T5 = select_rois_based_on_single_bar_response(resp_single_T4T5_orig, resp_single_T4T5_orig, recording_info_T4T5, data_info_single_T4T5, thresh, rf_center);

% plotting.
ax_w = 140; plot_max_value = 0.75;
figure_single_bar_utils_bar_plot(resp_single_T4T5, data_info_single_T4T5, recording_info_T4T5, plot_max_value, 1, left_4, top, ax_w, ax_h);
set(gca, 'XTick', [3, 4, 5, 6, 7, 8], 'XTickLabel', [-1, 0, 1, 2, 3, 4]); % positions 4 is the center! 
xlabel('bar position (5\circ)', 'FontSize', 10);


MySaveFig_Juyue(gcf, 'figure_6_1_single_bar','', 'nFigSave', 1,'fileType',{'fig'});

end

function time_traces(resp, data_info, left, top, ax_w, ax_h)
positions = {[left, top, ax_w, ax_h],;
    [left, top - (ax_h +20), ax_w, ax_h]};

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
epoch_index = data_info.epoch_index;
ll = 2;

for cc_bar_1 = 1:1:2
    
    resp_ave_plot = {resp_ave(:, epoch_index(cc_bar_1, ll))};
    resp_sem_plot = {resp_sem(:, epoch_index(cc_bar_1, ll))};
    axes('Unit', 'point', 'Position', positions{cc_bar_1 });
    plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, {[0,0,0]},'stim_dur', 60);
    set(gca, 'YLim', [-0.2, 0.7], 'YTick', [0, 0.5], 'XLim', [-0.25, 1.25],'YTickLabelRotation', 90);
end
ConfAxis('fontSize', 10, 'LineWidth', 1);

end

