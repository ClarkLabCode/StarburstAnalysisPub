clear
clc

stim_name = 'sinewave_opponent';
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, 0);
for ii = 1:1:length(cell_name_all)
    SAC_PreProcess_5D_Movie(cell_name_all{ii}, 'plot_raw_trace_flag', 1);
end

%%
[stim_info, data_info] = SAC_Opponency_2020_Utils_GetStimParam();
resp = SAC_GetResponse_OneStim(stim_name,  'dfoverf_method', 'stim_onset_bckg_sub');
epoch_ID = (1:24)';

%% plot the raw response of individual recording.
SAC_Oppenency_Utils_PlotRaw_Resp_IndividualCell(resp, data_info,stim_info, epoch_ID);
SAC_Oppenency_Utils_PlotRaw_Resp(resp, data_info,stim_info, epoch_ID);

%% plot individual cell
for ii = 1:1:length(cell_name_all)
    SAC_Oppenency_Utils_SumPreferredNull_WithCounterPhase(resp(ii), data_info,stim_info, epoch_ID);
    sgtitle(['recording:', cell_name_all{ii}], 'interpreter', 'none');
    MySaveFig_Juyue(gcf, 'SAC_Opponency', ['Resp_Phases', cell_name_all{ii}], 'nFigSave',1,'fileType',{'png'});
end

SAC_Oppenency_Utils_SumPreferredNull_WithCounterPhase(resp, data_info,stim_info, epoch_ID);
sgtitle(['number of recordings: ', num2str(length(cell_name_all))]);
MySaveFig_Juyue(gcf, 'SAC_Opponency', ['Resp_Phases', 'all'], 'nFigSave',2,'fileType',{'png','fig'});

[resp_over_phase, data_info_over_phase, epoch_ID_over_phase] = SAC_AverageResponse_By(resp, data_info, 'phase', 'mean', epoch_ID);
SAC_Oppenency_Utils_SumPreferredNull_WithCounterPhase(resp_over_phase, data_info_over_phase,stim_info, epoch_ID_over_phase);
MySaveFig_Juyue(gcf, 'SAC_Opponency', 'Resp_Over_Phases', 'nFigSave',2,'fileType',{'png','fig'});

%% averaged over time.
SAC_Opponency_Utils_FinalBarPlot(resp_over_phase, stim_info)
sgtitle(['number of recordings: ', num2str(length(cell_name_all))]);
set(gca, 'YLim', [0,1.5]);

exclude_extra_large_oppo =[ 1:13, 15:17, 19:23];
SAC_Opponency_Utils_FinalBarPlot(resp_over_phase(exclude_extra_large_oppo), stim_info)
sgtitle(['number of recordings: ', num2str(length(cell_name_all) - 2)]);
MySaveFig_Juyue(gcf, 'SAC_Opponency', 'Resp_Over_Phases_AveragedOverTime', 'nFigSave',1,'fileType',{'png'});
