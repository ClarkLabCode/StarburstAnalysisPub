function figure_apparent_motion()
set(0,'defaultAxesFontName', 'Arial')
set(0,'DefaultAxesTitleFontWeight','normal');

left_1 = 36; left_2 = left_1 + 90; left_3 = left_1 + 234; left_4 = left_1 + 400; top_2 = 460; % plot four static ring.
top_1 = 500;

%% visualization specs
meta_info.N = 90;
colors_pref_null = {[89,23,31]/100; [23,31,89]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % colors = {[88,35,41]/255; [23, 59, 68]/255};


%% 1. plot visual stimulus
MakeFigure_Paper;
ax_w = 18; ax_h = 60; 
visual_stimulus_apparent_motion(colors_pref_null, left_1, left_3 + 5, left_4 + 5, top_1, top_2, ax_w, ax_h);

%% 2. prepare response SAC
stim_name = 'apparent_motion';
recording_info = get_sac_recording_information(stim_name);

[stim_info_am, data_info_am] =  SAC_ApparentBars_Utils_GetStimParam();
% resp = SAC_GetResponse_OneStim(stim_name, 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
epoch_ID = (1:58)';
[resp_am, epoch_ID_am, data_info_am] = T4T5_OrganizeRespInit(resp, data_info_am, epoch_ID);

%% 3. plot time traces
ax_w = 80;ax_h = 60;
figure_apparent_motion_time_traces(resp_am, colors_pref_null, data_info_am, left_2, top_2, ax_w, ax_h);


ax_w = 120 * 4/5; ax_h = 60;
%% 4. plot analysis plot
figure_apparent_motion_bar_plot(resp_am, colors_pref_null, data_info_am, recording_info,  0, 0.51, left_3, top_2, ax_w, ax_h, 1);
set(gca, 'XTick', [1, 2, 3, 4], 'XTickLabel', [0, 1, 2, 3]);
xlabel('inner ring position (50\mum)', 'FontSize', 10, 'Interpreter', 'tex');

%% 5. do the same thing for T4T5
thresh = 3; % light/dark single bar at rf center is larger than 3.
rf_center = 5;

% load data
dataset_name = 'next_neighbor';
recording_info_T4T5 = get_t4t5_recording_info_apparent_motion();
resp_T4T5 = COVID_19_load_tmp_data(stim_name, 'T4_Pro', dataset_name);
epoch_ID_T4T5 = (1:112)';
[~, data_info_single_T4T5] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
[resp_single_T4T5, ~, data_info_single_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_single_T4T5, epoch_ID_T4T5);
[~, data_info_am_T4T5] = T4T5_AppMot_Utils_GetStimParam(dataset_name);
[resp_am_T4T5_orig, ~, data_info_am_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_am_T4T5, epoch_ID_T4T5);
% select response by single bar response
resp_am_T4T5 = select_rois_based_on_single_bar_response(resp_single_T4T5, resp_am_T4T5_orig, recording_info_T4T5, data_info_single_T4T5, thresh, rf_center);
ax_w = 120;
figure_apparent_motion_bar_plot(resp_am_T4T5, colors_pref_null, data_info_am_T4T5, recording_info_T4T5, 1, 1.2, left_4, top_2, ax_w, ax_h, 0);
xlabel('left bar position (5\circ)', 'FontSize', 10);
set(gca, 'XTick', [3, 4, 5, 6, 7], 'XTickLabel', [-1, 0, 1, 2, 3]); % positions 4 is the center! 


%% save it
MySaveFig_Juyue(gcf, 'figure_6_2_apparent_motion','v3', 'nFigSave',1,'fileType',{'fig'});

end