function apparent_motion_without_simultaneous_main(resp, recording_info, epoch_ID, figure_name, plot_max_value, cell_type, dataset_name)

if strcmp(cell_type, 'SAC')
    plot_center_location_flag = 0;
    phase_type = 1;
    %% organize the singbar resp into 2 * epoches.
    [stim_info_single, data_info_single] = SAC_SingleBar_Utils_GetStimParam();
    [resp_single, epoch_ID_single, data_info_single] = T4T5_OrganizeRespInit(resp, data_info_single, epoch_ID);
    
    [stim_info_am, data_info_am] =  SAC_ApparentBars_Utils_GetStimParam();
    [resp_am, epoch_ID_am, data_info_am] = T4T5_OrganizeRespInit(resp, data_info_am, epoch_ID);
else
    plot_center_location_flag = 0;
    phase_type = 0;
    [stim_info_single, data_info_single] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
    [resp_single, epoch_ID_single, data_info_single] = T4T5_OrganizeRespInit(resp, data_info_single, epoch_ID);
    
    [stim_info_am, data_info_am] = T4T5_AppMot_Utils_GetStimParam(dataset_name);
    [resp_am, epoch_ID_am, data_info_am] = T4T5_OrganizeRespInit(resp, data_info_am, epoch_ID);
end
%% apparent motion raw response
SAC_AppMot58_Plot_Utils_ApparentBars_BarPlot(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value * 1.25, [figure_name, '_AppMot_Raw_Response'], plot_center_location_flag)
% SAC_AppMot58_Plot_Utils_ApparentBars_BarPlot(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, 1, [figure_name, '_AppMot_Raw_Response'], plot_center_location_flag)

%%
apparent_motion_DS_from_AM(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value, figure_name);

%% First, plot the response to single bars, simultaneous bars, and apparent bars.
SAC_T4T5_SingleBar_Plot_Utils_RawResp(resp_single, data_info_single, stim_info_single, epoch_ID_single, recording_info, plot_max_value, [figure_name,'_SingleBar_Raw_Response_TimeTraces']);
SAC_T4T5_SingleBar_Plot_Utils_BarPlot(resp_single, data_info_single, stim_info_single, epoch_ID_single, recording_info, plot_max_value * 0.5,[figure_name,'_SingleBar_Raw_Response_BarPlot'], plot_center_location_flag);

%% summarize over phase, bar plot

%% ToDo: 
% 1. do summary plot.
% 2. do save and plot flag.
% 3. do phase selection. 

% select which phases to plot. interesting.
if plot_center_location_flag
else
    apparent_motion_DS_from_AM(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value, figure_name);
end

end