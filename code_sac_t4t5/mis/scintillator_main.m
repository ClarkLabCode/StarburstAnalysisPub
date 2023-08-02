clear
clc
addpath(genpath('../code_sac_t4t5/'))
process_movie_flag = false;
%% get stimulus information.
[stim_info, data_info] = SAC_Scintillator_Utils_GetStimParam();

%% load recordings specific to the stimulus.
stim_name = 'Scintillator_2019_03_26';
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, 1);
% if not processed. process it.
if process_movie_flag
    for ii = length(cell_name_all):1:length(cell_name_all)
        SAC_PreProcess_5D_Movie(cell_name_all{ii});
    end
end
resp = SAC_GetResponse_OneStim(stim_name);
epoch_ID = (1:24)';

%% Averaged Time traces for each epoch.
SAC_Scintillator_Utils_PlotRaw_Resp(resp, data_info,stim_info, epoch_ID, 0);
MySaveFig_Juyue(gcf, 'SAC_Scintillator','RawTimeTrace', 'nFigSave',2,'fileType',{'png','fig'});

% how about plot individual recordings? 
% SAC_Scintillator_Utils_PlotRaw_Resp(resp, data_info,stim_info, epoch_ID, 1);

%% Summary Plot
integration_dur_second = 15;
SAC_Scintillator_Utils_AverageOverTimeFirst(resp, data_info, epoch_ID, integration_dur_second);
MySaveFig_Juyue(gcf, 'SAC_Scintillator','Summary', 'nFigSave',2,'fileType',{'png','fig'});

integration_dur_second = 5;
SAC_Scintillator_Utils_AverageOverTimeFirst(resp(11), data_info, epoch_ID, integration_dur_second);

%% Three average functions.
% SAC_AverageResponseOverTime(resp, on_set, off_set)
% SAC_AverageResponse_By(resp, data_info, ave_param, mode, epoch_ID)
% SAC_GetAverageResponse(resp_over_time);


%% Some other functions. Not Essential.
SAC_Scintillator_Utils_3D_Dt_Pol_Dir(resp, data_info,stim_info, epoch_ID);
[resp_over_dir, data_info_over_dir, epoch_ID_over_dir] = SAC_AverageResponse_By(resp, data_info,'dir','sub',epoch_ID);
% MySaveFig_Juyue(gcf, 'SAC_Scintillator','Dt_Pol_Dir', 'nFigSave',2,'fileType',{'png','fig'});
% The resp_over_dir, get
SAC_Scintillator_Utils_2D_Dt_Pol(resp_over_dir, data_info_over_dir,stim_info, epoch_ID_over_dir);
% MySaveFig_Juyue(gcf, 'SAC_Scintillator','2D_Dt_Pol', 'nFigSave',2,'fileType',{'png','fig'});

%% For Scintillator, PD, ND.
dur_second_bank = [1, 5, 15];
for ii = 1:1:length(dur_second_bank)
    dur_second = dur_second_bank(ii);
    SAC_Scintillator_Utils_AverageOverTimeFirst(resp, data_info, epoch_ID, dur_second);
    sgtitle(['Integration Duration:', num2str(dur_second), ' (second)'])
    MySaveFig_Juyue(gcf, 'SAC_Scintillator',['AveOverTime_',num2str(dur_second), 's'], 'nFigSave',2,'fileType',{'png','fig'});
end

%% analyze for each recording. plot it for each cell.
dur_second = 15;
for ii = 1:1:length(cell_name_all)
    %     SAC_Scintillator_Utils_2D_Dt_Pol(resp_over_dir(ii), data_info_over_dir,stim_info, epoch_ID_over_dir);
    SAC_Scintillator_Utils_AverageOverTimeFirst(resp(ii), data_info, epoch_ID, dur_second);
end

%% analyze for each trial.
dur_second = 15;
for trial_num = 1:1:3
    resp_selected = cellfun(@(x) x(:, trial_num, :, :), resp, 'UniformOutput', 0);
    SAC_Scintillator_Utils_AverageOverTimeFirst(resp_selected, data_info, epoch_ID, dur_second);
    
    sgtitle({['only the ', num2str(trial_num),' (st,nd,th) trial is used.'], ['Integration Duration:', num2str(dur_second), ' (second)']})
    MySaveFig_Juyue(gcf, 'SAC_Scintillator',['AveOverTime_',num2str(dur_second), 's', '_Trial',num2str(trial_num)], 'nFigSave',2,'fileType',{'png','fig'});
end
