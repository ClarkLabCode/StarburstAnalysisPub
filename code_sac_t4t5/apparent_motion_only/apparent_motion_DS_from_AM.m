function apparent_motion_DS_from_AM(resp_am, data_info_am, stim_info_am, epoch_ID_am, recording_info, plot_max_value, figure_name)
% TODO.  
% 1. get rid of stimulus for different phases to save some space in T4T5?
% 5. the onset of the response is delayed by about 0.25 second?
%% raw time traces
SAC_AppMot_Plot_Utils_4D(resp_am, data_info_am, stim_info_am, epoch_ID_am,...
    recording_info, plot_max_value * 0.75, [figure_name,'_AppMot_4D']);

%% In 4D plot, plot the raw response, with lag contrast subtracted.
SAC_AppMot_Plot_Utils_4D_Lag_Dir_LeadC_LagC(resp_am, data_info_am, stim_info_am, epoch_ID_am, ...
    recording_info, plot_max_value * 0.7, [figure_name,'_AppMot_4D_Phase_LagC_LeadC_Dir']);

%% In 4D plot, plot the raw response, with lag contrast subtracted, Bar plot.
SAC_AppMot_Plot_Utils_4D_BarPlot_Lag_Dir_LeadC_LagC(resp_am, data_info_am, stim_info_am, epoch_ID_am, ...
    recording_info, plot_max_value * 0.7, [figure_name,'_AppMot_4D_BarPlot_Phase_LagC_LeadC_Dir']);

%% In 3D plot, subtraction off lagCont, i.e. along lead contrast axis.
[resp_ave_over_lagCont, data_info_ave_over_lagCont, epoch_ID_ave_over_lagCont] = ...
    SAC_AverageResponse_By(resp_am, data_info_am, 'lagCont', 'sub', epoch_ID_am);
SAC_AppMot_Plot_Utils_3D_Lag_Dir(resp_ave_over_lagCont, data_info_ave_over_lagCont, stim_info_am, epoch_ID_ave_over_lagCont, ...
    recording_info, plot_max_value, [figure_name,'_AppMot_3D_Phase_LeadC_Dir'])

SAC_AppMot_Plot_Utils_3D_BarPlot_Lag_Dir(resp_ave_over_lagCont, data_info_ave_over_lagCont, stim_info_am, epoch_ID_ave_over_lagCont, ...
    recording_info, plot_max_value * 0.75, [figure_name,'_AppMot_3D_BarPlot_Phase_LeadC_Dir'])

%% In 2D plot, subtraction off direction
[resp_ave_over_leadCont, data_info_ave_over_leadCont, epoch_ID_ave_over_leadCont] = ...
    SAC_AverageResponse_By(resp_ave_over_lagCont, data_info_ave_over_lagCont, 'leadCont', 'sub', epoch_ID_ave_over_lagCont);

SAC_AppMot_Plot_Utils_2D_Phase(resp_ave_over_leadCont, data_info_ave_over_leadCont, stim_info_am, epoch_ID_ave_over_leadCont, ...
    recording_info, plot_max_value * 0.6, [figure_name,'_AppMot_2D_Phase_Dir'])

SAC_AppMot_Plot_Utils_2D_BarPlot_Phase(resp_ave_over_leadCont, data_info_ave_over_leadCont, stim_info_am, epoch_ID_ave_over_leadCont, ...
    recording_info, plot_max_value * 0.4, [figure_name,'_AppMot_2D_BarPlot_Phase'])

%% In 2D plot, average across phases.
[resp_ave_over_dir, data_info_ave_over_dir, epoch_ID_ave_over_dir] = ...
    SAC_AverageResponse_By(resp_ave_over_leadCont, data_info_ave_over_leadCont, 'dirVal', 'sub', epoch_ID_ave_over_leadCont);
SAC_AppMot_Plot_Utils_1D(resp_ave_over_dir, data_info_ave_over_dir, stim_info_am, epoch_ID_ave_over_dir,...
    recording_info, plot_max_value * 0.75, [figure_name,'_AppMot_1D_Phase'])

%%
end