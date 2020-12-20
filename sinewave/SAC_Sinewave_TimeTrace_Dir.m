function SAC_Sinewave_TimeTrace_Dir(resp, data_info, epoch_ID, stim_info)
epoch_index = data_info.epoch_index;
fVals = data_info.stim_param.fVals;
kVals = data_info.stim_param.kVals;
n_k = length(kVals);
n_f = length(fVals);
[on_idx, off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1, stim_info.param_vec.fVals);

ff_str = {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','8'};
sf_str = {'1/150 \mum', '1/225 \mum', '1/300 \mum', '1/450 \mum'};

% ff_str = {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','4\surd{2}','8', '8\surd{2}'};
% sf_str = {'1/15\circ', '1/30\circ', '1/60\circ', '1/90\circ'};
% sf_str = {'1/75 \mum', '1/150 \mum', '1/225 \mum'};
%% prefered red color. null blue color.
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);

color_bank_two = zeros(2,4,3);
color_bank_two(1,:,:) = brewermap(4, 'Reds');
color_bank_two(2,:,:) = brewermap(4, 'Blues');

for ff = 1:1:n_f
    if ff == 1 || ff == (round(n_f/2) + 1)
        MakeFigure;
    end
    subplot(round(n_f/2),1,mod(ff - 1, round(n_f/2)) + 1);
    
    for kk = 1:1:n_k 
        % preferred direction
        SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(ff, kk, 1)),...
            resp_sem(:, epoch_index(ff, kk, 1)),...
            color_bank_two(1, kk,:),...
            'stim_dur', stim_info.stim_dur,...
            'f_stim', stim_info.f_stim,...
            'set_integrate_len', true,...
            'plot_integrate_shading', true,...
            'f_vals', fVals(ff)); hold on;

    end
    for kk = 1:1:n_k 
        % null direction.
        SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(ff, kk, 2)),...
            resp_sem(:, epoch_index(ff, kk, 2)),...
            color_bank_two(2, kk,:),...
            'stim_dur', stim_info.stim_dur,...
            'f_stim', stim_info.f_stim,...
            'set_integrate_len', true,...
            'plot_integrate_shading', true,...
            'f_vals', fVals(ff)); hold on;

    end
    if ff == 1 || ff == (round(n_f/2) + 1)
        legend_str = [cellfun(@(x) ['pref ', x], sf_str, 'UniformOutput',false), cellfun(@(x) ['null ', x], sf_str, 'UniformOutput',false)];
        legend(legend_str);
    end
%     set(gca, 'YLim', [-0.15, 0.5]);
    if ff == (round(n_f/2) + 1) || ff == n_f
        xlabel('time (s)');
    end
    title(['TF: ', ff_str{ff}, ' Hz']);
    
end

%% plot 10 different time. black the differences. gray.
[resp_over_dir, ~, ~] = SAC_AverageResponse_By(resp, data_info, 'dirVal', 'sub', epoch_ID);
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp_over_dir);
colors_bank = brewermap(4,'Dark2');

for ff = 1:1:n_f
    if ff == 1 || ff == (round(n_f/2) + 1)
        MakeFigure;
    end
    subplot(round(n_f/2),1,mod(ff - 1, (round(n_f/2))) + 1);
    for kk = 1:1:n_k 
        
        SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(ff, kk, 1)),...
            resp_sem(:, epoch_index(ff, kk, 1)), ...
            colors_bank(kk,:),...
            'set_integrate_len', true,...
            'plot_integrate_shading', true,...
            'f_vals', fVals(ff)); hold on;
        

%         set(gca, 'YLim', [-0.1, 0.15]);
        title(['TF: ', ff_str{ff}, ' Hz']);
    end
    if ff == 1 || ff == (round(n_f/2) + 1)
        
        legend(sf_str);
    end
    if ff == round(n_f/2)+1 || ff == n_f
        xlabel('time (s)');
    end
end

end
%% How do you take a look at the response...
