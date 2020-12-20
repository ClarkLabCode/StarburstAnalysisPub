function T4T5_AppMot_Plot_Utils_ResponseAllPhase_ColorPlot(resp,data_info,stim_info,epoch_ID)
% Plot them aligned together...
n_dir = 2;
n_cont = 2;
epoch_index = data_info.epoch_index;
n_phase = size(epoch_index, 4);

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
c_max = max(abs(resp_ave(:)));
%%
MakeFigure;
for dd = 1:1:n_dir
    for lead_cont = 1:1:n_cont % bar 1 has a smaller spatial index.
        for lag_cont = 1:1:n_cont % bar 2 has a smaller spatial index.
            
            if(lead_cont == lag_cont)
                block = 1; % phi/
            else
                block = 2; % reverse phi.
            end

            subplot_idx = (block - 1) * 4 + (lead_cont - 1) * 2 + dd;
            epoch = epoch_index(lead_cont, lag_cont, dd, :);

            resp_ave_this = resp_ave(:, epoch(:));
            resp_sem_this = resp_sem(:, epoch(:));

            stim_cont = stim_info.epoch_cont(:, :, epoch_ID(epoch(5)));
            

            subplot(2, n_phase, subplot_idx);
            T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, [0,0,0]);

            subplot(2, n_phase, 8 + subplot_idx);
            T4T5_Plot_Utils_ColorPlotResp_YReverse(resp_ave_this, 1, c_max);
        end
    end
end