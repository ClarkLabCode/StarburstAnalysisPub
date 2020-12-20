function apparent_motion_LD_main(resp, recording_info, epoch_ID, figure_name, plot_max_value, plot_flag, save_fig, cell_type, dataset_name)

if strcmp(cell_type, 'SAC') 
    phase_type = 1;
    plot_center_location_flag = 0;
    
    %% organize the singbar resp into 2 * epoches.
    [stim_info_simultaneous, data_info_simultaneous] = SAC_TwoSimultaneousBar_Utils_GetStimParam();
    [resp_simultaneous, epoch_ID_simultaneous, data_info_simultaneous] =  T4T5_OrganizeRespInit(resp, data_info_simultaneous, epoch_ID);
    
    [stim_info_single, data_info_single] = SAC_SingleBar_Utils_GetStimParam();
    [resp_single, epoch_ID_single, data_info_single] = T4T5_OrganizeRespInit(resp, data_info_single, epoch_ID);
    
    [stim_info_am, data_info_am] =  SAC_ApparentBars_Utils_GetStimParam();
    [resp_am, epoch_ID_am, data_info_am] = T4T5_OrganizeRespInit(resp, data_info_am, epoch_ID);
else
    phase_type = 0;
    plot_center_location_flag = 1;
    
    [stim_info_simultaneous, data_info_simultaneous] = T4T5_TwoSimultaneousBar_Utils_GetStimParam(cell_type, dataset_name);
    [resp_simultaneous, epoch_ID_simultaneous, data_info_simultaneous] =  T4T5_OrganizeRespInit(resp, data_info_simultaneous, epoch_ID);
    
    [stim_info_single, data_info_single] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
    [resp_single, epoch_ID_single, data_info_single] = T4T5_OrganizeRespInit(resp, data_info_single, epoch_ID);
    
    [stim_info_am, data_info_am] = T4T5_AppMot_Utils_GetStimParam(dataset_name);
    [resp_am, epoch_ID_am, data_info_am] = T4T5_OrganizeRespInit(resp, data_info_am, epoch_ID);
    
end

%% First, plot the response to single bars, simultaneous bars, and apparent bars.
SAC_T4T5_TwoSimultaneousBars_Plot_Utils_RawResp(resp_simultaneous, data_info_simultaneous, stim_info_simultaneous, epoch_ID_simultaneous, recording_info, plot_max_value, 0, [figure_name,'_Raw_Response']);
SAC_T4T5_TwoSimultaneousBars_Plot_Utils_BarPlot(resp_simultaneous, data_info_simultaneous, stim_info_simultaneous,  epoch_ID_simultaneous, recording_info, plot_max_value * 0.5, 0, [figure_name,'_Simultaneous_Raw_Response'])
SAC_T4T5_SingleBar_Plot_Utils_RawResp(resp_single, data_info_single, stim_info_single, epoch_ID_single, recording_info, plot_max_value, figure_name);
SAC_T4T5_SingleBar_Plot_Utils_BarPlot(resp_single, data_info_single, stim_info_single, epoch_ID_single, recording_info, plot_max_value * 0.5,[figure_name,'_SingleBar_Raw_Response'], 0);

%% Simultaneous - Single.
resp_TwoSimultaneous_subtract_SingleBar = SAC_T4T5_LD_Utils_TwoSimultaneous_Subtract_SingleBar(...
    resp_simultaneous, data_info_simultaneous,...
    resp_single, data_info_single,...
    plot_flag,save_fig, ...
    stim_info_simultaneous, epoch_ID_simultaneous, ...
    stim_info_single, epoch_ID_single, recording_info, phase_type, plot_max_value, figure_name);
% SAC_T4T5_TwoSimultaneousBars_Plot_Utils_RawResp(resp_TwoSimultaneous_subtract_SingleBar, data_info_simultaneous, stim_info_simultaneous, epoch_ID_simultaneous, recording_info, plot_max_value * 0.75, 1, [figure_name,'_Interaction']);
SAC_T4T5_TwoSimultaneousBars_Plot_Utils_BarPlot(resp_TwoSimultaneous_subtract_SingleBar, data_info_simultaneous, stim_info_simultaneous,  epoch_ID_simultaneous, recording_info, plot_max_value * 0.75, 1, [figure_name,'_Simultaneous_NonLinear_Response'])

%% App - Single
resp_AppMot_subtract_SingleBar = SAC_T4T5_LD_Utils_AppMot_Subtract_SingleBar(...
    resp_am, data_info_am,...
    resp_single, data_info_single,...
    plot_flag,save_fig, ...
    stim_info_am, epoch_ID_am, ...
    stim_info_single, epoch_ID_single, recording_info, phase_type, plot_max_value, figure_name);
% apparent motion without subtracting out the simultaneous. 
SAC_AppMot58_Plot_Utils_ApparentBars_BarPlot(resp_AppMot_subtract_SingleBar, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value * 0.75, [figure_name, '_AppMot_NonLinear_with_nonDS_Response'], plot_center_location_flag)
SAC_AppMot58_Plot_Utils_ApparentBars(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value, figure_name)
%%  App - Simultaneous.
resp_interacting_term = SAC_T4T5_LD_Utils_AppMot_Subtract_Simultaneous(resp_AppMot_subtract_SingleBar, data_info_am,...
    resp_TwoSimultaneous_subtract_SingleBar, data_info_simultaneous, plot_flag, save_fig, stim_info_am, epoch_ID_am, ...
    stim_info_simultaneous, epoch_ID_simultaneous, recording_info, plot_max_value, figure_name);

%% summarize over phase, bar plot;
SAC_AppMot58_Plot_Utils_ApparentBars_BarPlot(resp_interacting_term, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value * 0.75, [figure_name, '_AppMot_NonLinear_Response'], plot_center_location_flag);
SAC_AppMot58_Plot_Utils_ApparentBars_BarPlot(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value * 1.25, [figure_name, '_AppMot_Raw_Response'],plot_center_location_flag);

%% two ways to plot the result.
% SAC_AppMot58_Plot_Utils_ApparentBars(resp_interacting_term, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value * 0.4, [figure_name, '_Interaction']);
% SAC_AppMot58_Plot_Utils_ApparentBars(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value, [figure_name, '_Raw_Response']);
% 
% T4T5_AppMot_Plot_Utils_ResponseAllPhase_ColorPlot_V2(resp_interacting_term,data_info_am,stim_info_am,epoch_ID_am, recording_info, [figure_name, '_Interaction']);
% T4T5_AppMot_Plot_Utils_ResponseAllPhase_ColorPlot_V2(resp_am,data_info_am,stim_info_am,epoch_ID_am, recording_info, [figure_name, '_Raw_Response']);

end