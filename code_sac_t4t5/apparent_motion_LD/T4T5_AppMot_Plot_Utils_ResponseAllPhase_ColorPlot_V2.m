function T4T5_AppMot_Plot_Utils_ResponseAllPhase_ColorPlot_V2(resp,data_info,stim_info,epoch_ID, recording_info, figure_name)
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
            
            
            subplot(1, 16, subplot_idx * 2);
            T4T5_Plot_Utils_ColorPlotResp_YReverse(resp_ave_this, 1, c_max, 'stim_onset_sec', recording_info.stim_onset, 'f_resp', recording_info.f_resp);
            
            for ll = 1:1:n_phase
                subplot(n_phase, 16, (ll-1) * 8 * 2 +  subplot_idx *2 -1);
                stim_cont = stim_info.epoch_cont(:, :, epoch_ID(epoch(ll)));
                T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont, [0,0,0]);
            end
        end
    end
end
sgtitle(figure_name, 'Interpreter', 'none');
MySaveFig_Juyue(gcf, figure_name, 'color_plot', 'nFigSave',2,'fileType',{'png','fig'});
