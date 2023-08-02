clear
clc
close all
%% process movies.
process_movie_flag = false;
stim_name = 'sinewave_sweep_dense';
hand_pick_flag = 1;
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag);
if process_movie_flag
    for ii = length(cell_name_all):1:length(cell_name_all)
        SAC_PreProcess_5D_Movie(cell_name_all{ii});
    end
end

%% load response. 
[stim_info, data_info] = SAC_SineWave_Sweep_Utils_GetStimParam(stim_name);
sf_str = {'1/150', '1/225', '1/300', '1/450'};
tf_str = {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','8'};
epoch_ID = data_info.epoch_index(:);
% resp = SAC_GetResponse_OneStim('sinewave_sweep_dense', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
resp = COVID_19_load_tmp_data(stim_name, 'SAC');

%% mean/F1 signals
% title_name = ['signal over ', num2str(length(resp)), ' branches'];
% SAC_SineWave_KF_Plot(resp, data_info, epoch_ID, stim_info, 'mean', sf_str, tf_str, title_name);
% SAC_SineWave_KF_Plot(resp, data_info, epoch_ID, stim_info, 'F1', sf_str, tf_str, title_name);

% % plot individual KT plot.
% for rr = 1:1:length(cell_name_all)
%     title_name = ['single branch: ', cell_name_all{rr}];
%     SAC_SineWave_KF_Plot(resp(rr), data_info, epoch_ID, stim_info, sf_str, tf_str, title_name);
% end

% plotting the time traces. 
n_suppose = 96;
resp_clipped = cell(size(resp));
for rr = 1:1:length(resp)
    resp_clipped{rr} = resp{rr}(1:n_suppose, :, :, :);
end
SAC_Sinewave_TimeTrace_Dir(resp_clipped, data_info, epoch_ID, stim_info);

% sgtitle(['Averaged Over ', num2str(length(resp)), ' branches']);
% MySaveFig_Juyue(gcf, 'Sinewave_time_traces','LowTF', 'nFigSave',2,'fileType',{'png','fig'});
% 
% sgtitle(['Averaged Over ', num2str(length(resp)), ' branches']);
% MySaveFig_Juyue(gcf, 'Sinewave_time_traces','HighTF', 'nFigSave',2,'fileType',{'png','fig'});
% 
% sgtitle(['Averaged Over ', num2str(length(resp)), ' branches']);
% MySaveFig_Juyue(gcf, 'Sinewave_time_traces_sub','LowTF', 'nFigSave',2,'fileType',{'png','fig'});
% 
% sgtitle(['Averaged Over ', num2str(length(resp)), ' branches']);
% MySaveFig_Juyue(gcf, 'Sinewave_time_traces_sub','HighTF', 'nFigSave',2,'fileType',{'png','fig'});