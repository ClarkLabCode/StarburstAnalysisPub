clear
clc
recording_info.f_resp = 15.6250;
recording_info.stim_onset = 1;
recording_info.stim_dur_sec = 1;
recording_info.second_bar_onset = 0.25;
epoch_ID = (1:58)';
plot_flag = 0; save_fig = 0;

%% load one data point and analyze from there.
% resp = SAC_GetResponse_OneStim('apparent_motion', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data('apparent_motion', 'SAC');
figure_name = ['ON_SAC_', num2str(length(resp))];
plot_max_value = 0.5;
apparent_motion_LD_main(resp, recording_info, epoch_ID, figure_name, plot_max_value, 1, 0, 'SAC', 0);

%% load background data.
resp = SAC_GetResponse_OneStim('apparent_motion', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 1);
figure_name = ['ON_SAC_bleedthrough_', num2str(length(resp))];
plot_max_value = 0.1;
apparent_motion_LD_main(resp, recording_info, epoch_ID, figure_name, plot_max_value, plot_flag, save_fig, 'SAC');

%%
resp = SAC_GetResponse_OneStim('apparent_motion', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
figure_name = ['ON_SAC_', num2str(length(resp))];
plot_max_value = 1;
apparent_motion_without_simultaneous_main(resp, recording_info, epoch_ID, figure_name, plot_max_value, 'SAC', '');