function figure_apparent_motion_supp_simultaneous_bar()
set(0,'defaultAxesFontName', 'Arial');

%% visualization specs
colors_pref_null = {[89,23,31]/100; [23,31,89]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % colors = {[88,35,41]/255; [23, 59, 68]/255};



%% 1. plot visual stimulus
MakeFigure_Paper;
visual_stimulus_apparent_motion_single_bar();

%% 2. prepare response SAC
recording_info.f_resp = 15.6250;
recording_info.stim_onset = 1;
recording_info.stim_dur_sec = 1;
recording_info.second_bar_onset = 0.25;

stim_name = 'apparent_motion';
epoch_ID = (1:58)';

% resp = SAC_GetResponse_OneStim(stim_name, 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data(stim_name, 'SAC');

%% organize the singbar resp into 2 * epoches.
[stim_info_simultaneous, data_info_simultaneous] = SAC_TwoSimultaneousBar_Utils_GetStimParam();
[resp_simultaneous, epoch_ID_simultaneous, data_info_simultaneous] =  T4T5_OrganizeRespInit(resp, data_info_simultaneous, epoch_ID);


%% 3. plot time traces
left = 36 + 135; top = 470;
time_traces(resp_single, data_info_single, left, top)

%% 4. plot analysis plot
% plot bar plot. SAC;
bar_plot(resp_single, data_info_single, recording_info,  36 + 312 - 40, 460);
xlabel('inner ring position', 'FontSize', 10);


MySaveFig_Juyue(gcf, 'apparent_motion_single_bar', 'v1', 'nFigSave',1,'fileType',{'pdf'})
MySaveFig_Juyue(gcf, 'figure_6_supp_1','', 'nFigSave',1,'fileType',{'pdf'});

end