clear
clc
recording_info.f_resp = 15.6250;
recording_info.stim_onset = 1;

process_movie_flag = true;
%% get stimulus information.
stim_name = 'scintillator';
hand_pick_flag = 1;
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag);
if process_movie_flag
    for ii = 16:1:length(cell_name_all)
        SAC_PreProcess_5D_Movie(cell_name_all{ii});
    end
end
%%
clear
clc
recording_info.f_resp = 15.625;
%% get stimulus information.
stim_name = 'scintillator';
[stim_info, data_info] = SAC_Scintillator_2020_Utils_GetStimParam();

%% load recordings specific to the stimulus.
resp = SAC_GetResponse_OneStim('scintillator', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
epoch_ID = (1:24)';
% reorganize the resp such that you could do subtraction directly.
[resp_reorganize, epoch_ID_reorganize, data_info_reorganize] = T4T5_OrganizeRespInit(resp, data_info, epoch_ID);

%% 
SAC_Scintillator_Utils_PlotRaw_Resp(resp_reorganize, data_info_reorganize, stim_info, epoch_ID_reorganize, 0);
MySaveFig_Juyue(gcf, 'SAC_Scintillator','RawTimeTrace', 'nFigSave',2,'fileType',{'png','fig'});
% SAC_Scintillator_Utils_PlotRaw_Resp(resp_reorganize, data_info_reorganize, stim_info, epoch_ID_reorganize, 0);

%% Summary Plot. There are three strange recordings.
%% also denote whose are those recordings. from where to where?
integration_dur_second = 5;
integration_onset_second = 1;
SAC_Scintillator_Utils_AverageOverTimeFirst(resp_reorganize, data_info_reorganize, epoch_ID_reorganize, integration_onset_second, integration_dur_second, recording_info, 1000 * stim_info.SPLT / stim_info.fps);

% neuron type. 
integration_info_str = ['Integration Time: ', num2str(integration_onset_second), '-', num2str(integration_onset_second+ integration_dur_second), ' (second)'];
neuron_info_str = [num2str(length(resp)), ' recordings'];
title_str = [integration_info_str, '. ', neuron_info_str];
sgtitle(title_str)
MySaveFig_Juyue(gcf, 'SAC_Scintillator','Summary', 'nFigSave',2,'fileType',{'png','fig'});

%% summary plot for individual. % average over time first?

%% Some other functions. Not Essential.
SAC_Scintillator_Utils_3D_Dt_Pol_Dir(resp_reorganize, data_info_reorganize,stim_info, epoch_ID_reorganize);
[resp_over_dir, data_info_over_dir, epoch_ID_over_dir] = SAC_AverageResponse_By(resp_reorganize, data_info_reorganize,'dx','sub', epoch_ID_reorganize);
MySaveFig_Juyue(gcf, 'SAC_Scintillator','Dt_Pol_Dir', 'nFigSave',2,'fileType',{'png','fig'});
% The resp_over_dir, get
SAC_Scintillator_Utils_2D_Dt_Pol(resp_over_dir, data_info_over_dir,stim_info, epoch_ID_over_dir);
MySaveFig_Juyue(gcf, 'SAC_Scintillator','2D_Dt_Pol', 'nFigSave',2,'fileType',{'png','fig'});

%% For Scintillator, PD, ND.
% dur_second_bank = [1, 5];
dur_second_bank = [5, 4, 4, 3, 3] ;
onset_second_bank = [1, 1, 2, 2, 3];

for ii = 1:1:length(dur_second_bank)
    dur_second = dur_second_bank(ii);
    onset_second = onset_second_bank(ii);
    SAC_Scintillator_Utils_AverageOverTimeFirst(resp_reorganize, data_info_reorganize, epoch_ID_reorganize, onset_second, dur_second, recording_info, 1000 * stim_info.SPLT / stim_info.fps);
    sgtitle(['Integration Time: ', num2str(onset_second), '-', num2str(onset_second + dur_second), ' (second)'])
%     MySaveFig_Juyue(gcf, 'SAC_Scintillator',['AveOverTime_',num2str(dur_second), 's'], 'nFigSave',2,'fileType',{'png','fig'});
end

%% analyze for each trial.
dur_second = 5;
for trial_num = 1:1:3
    resp_selected = cellfun(@(x) x(:, trial_num, :, :), resp_reorganize, 'UniformOutput', 0);
    SAC_Scintillator_Utils_AverageOverTimeFirst(resp_selected,  data_info_reorganize, epoch_ID_reorganize, dur_second, recording_info, 1000 * stim_info.SPLT / stim_info.fps);
    
    sgtitle({['only the ', num2str(trial_num),' (st,nd,th) trial is used.'], ['Integration Duration:', num2str(dur_second), ' (second)']})
    MySaveFig_Juyue(gcf, 'SAC_Scintillator',['AveOverTime_',num2str(dur_second), 's', '_Trial',num2str(trial_num)], 'nFigSave',2,'fileType',{'png','fig'});
end
