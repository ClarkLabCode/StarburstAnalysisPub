%% write a analysis code for edges response, plot four speed, choose one just plot the average response. should be easy.
clear
clc

%% load response.
stim_name = 'edges';
[stim_info, data_info] = SAC_Edges_Utils_GetStimParam(stim_name);

% resp = SAC_GetResponse_OneStim('sinewave_sweep_dense', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);

colors = {[1, 0, 0], [0,0,1]};
velocity = data_info.param.velocity;
polarity = [1, -1]; polarity_str = {'light', 'dark'};
epoch_index = data_info.epoch_index;

MakeFigure;
ee = 1;
for vv = 1:1:4
    for pp = 1:1:2
        for dd = 1:1:2
            subplot(4, 4, ee);
            SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(dd, pp, vv)),...
            resp_sem(:, epoch_index(dd, pp, vv)),...
            colors{dd},...
            'stim_dur', 8.5 * 60,...
            'f_stim', 60); hold on;
             title([polarity_str{pp}, ', velocity:' , num2str(velocity(vv)), '\mum/s']);
     
            ee = ee + 1;
            set(gca, 'YLim', [-0.2, 0.8]);
        end
    end
end
