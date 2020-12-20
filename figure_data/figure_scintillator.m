function figure_scintillator()
set(0,'defaultAxesFontName', 'Arial');
set(0,'DefaultAxesTitleFontWeight','normal');

left1 = 72; left2 = 72 + 135;
%% visualization specs
colors_pref_null = {[89,23,31]/100; [23,31,89]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % colors = {[88,35,41]/255; [23, 59, 68]/255};
colors_positive_negative_cmap = brewermap(10, 'PRGn');
colors_positive_negative = {colors_positive_negative_cmap(end, :), colors_positive_negative_cmap(1,:)};

%% 1. plot visual stimulus
MakeFigure_Paper;
top = 600; ax_s = 45; ax_w = 27; ax_h = 45;
visual_stimulus_scintillator_stimulus_part_1(colors_pref_null, left1, top, ax_s, ax_w, ax_h);
MySaveFig_Juyue(gcf, 'figure_3_scintillator_part_1','v4', 'nFigSave',1,'fileType',{'fig'});
%% 
MakeFigure_Paper;
ax_w1 = 45; ax_w2 = 3.5 * 9;
visual_stimulus_scintillator_stimulus_part_2(colors_pref_null, left1, left2, left1 + 151, top,  ax_w1, ax_w2);


%% 2. prepare response
stim_name = 'scintillator';
[stim_info, data_info] = SAC_Scintillator_2020_Utils_GetStimParam();

%resp = SAC_GetResponse_OneStim('scintillator', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
disp(['Scintillator response n = ', num2str(length(resp))]);
epoch_ID = (1:24)';
[resp_reorganize, epoch_ID_reorganize, data_info_reorganize] = T4T5_OrganizeRespInit(resp, data_info, epoch_ID);


%% 3. plot averaged time traces
polarities = [1, -1];
directions = [1, -1];
dt = 1;
top = 420; ax_w = 72; ax_h = 64;
figure_scintillatr_time_trace_demo(resp, directions, polarities, dt, colors_pref_null, stim_info, left1, left2, top, ax_w, ax_h);

%% 4. plot dt sweep
recording_info.f_resp = 15.6250;
recording_info.stim_onset = 1;
integration_dur_second = 5; integration_onset_second = 1;
top = 260; ax_w = 72; ax_h = 72;
figure_scintillator_average_over_time(resp_reorganize,  colors_positive_negative, data_info_reorganize, epoch_ID_reorganize, integration_onset_second, integration_dur_second, recording_info, 1000 * stim_info.SPLT / stim_info.fps,...
    left1, top, ax_w, ax_h);


%% 5. dt sweep for T4T5
resp_T4T5 = SAC_T4T5_Scintillator_Load_T4T5_response();
figure_scintillator_average_over_time_T4T5(resp_T4T5, colors_positive_negative, left2, top, ax_w, ax_h);

MySaveFig_Juyue(gcf, 'figure_3_scintillator_part_2','v4', 'nFigSave',1,'fileType',{'fig'});

end
