function T4T5_SingleBar_Plot_Utils_ResponseAllPhase_ColorPlot(resp,data_info,stim_info,epoch_ID)
% Plot them aligned together...
n_cont = 2;
epoch_index = data_info.epoch_index;

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
c_max = max(abs(resp_ave(:)));
%%
MakeFigure;
for cont = 1:1:n_cont % bar 1 has a smaller spatial index.
    
    subplot_idx = cont;
    epoch = epoch_index(cont, :);
    
    resp_ave_this = resp_ave(:, epoch(:));
%     resp_sem_this = resp_sem(:, epoch(:));
    
    stim_cont = stim_info.epoch_cont(:, :, epoch_ID(epoch(5)));
    
    
    subplot(2, 2, subplot_idx);
    T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, [0,0,0]);
    
    subplot(2, 2, 2 + subplot_idx);
    T4T5_Plot_Utils_ColorPlotResp_YReverse(resp_ave_this, 1, c_max);
    
end