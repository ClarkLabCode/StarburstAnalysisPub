clear
clc

%% process movies.
stim_name = 'sinewave_sweep_dense';
hand_pick_flag = 1;

%% load response. 
[stim_info, data_info] = SAC_SineWave_Sweep_Utils_GetStimParam(stim_name);
sf_str = {'1/150', '1/225', '1/300', '1/450'};
tf_str = {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','8'};
epoch_ID = data_info.epoch_index(:);
resp = COVID_19_load_tmp_data(stim_name, 'SAC');

%% mean/F1 signals
title_name = ['signal over ', num2str(length(resp)), ' branches'];
SAC_SineWave_KF_Plot(resp, data_info, epoch_ID, stim_info, 'mean', sf_str, tf_str, title_name);

% plot individual KT plot.
for rr = 1:1:length(cell_name_all)
    title_name = ['single branch the: ',num2str(rr)];
    SAC_SineWave_KF_Plot(resp(rr), data_info, epoch_ID, stim_info, 'mean', sf_str, tf_str, title_name);
end