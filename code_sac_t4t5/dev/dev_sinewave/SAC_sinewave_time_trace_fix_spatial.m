function SAC_sinewave_time_trace_fix_spatial(resp, data_info, epoch_ID, stim_info)

epoch_index = data_info.epoch_index;
fVals = data_info.stim_param.fVals;
kVals = data_info.stim_param.kVals;
n_k = length(kVals);
n_f = length(fVals);

ff_str = {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','8'};
sf_str = {'1/150 \mum', '1/225 \mum', '1/300 \mum', '1/450 \mum'};

ff_plot = [1:2:8];
ff_plot_str = ff_str(ff_plot);

%% prefered red color. null blue color.
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);

color_bank_two = zeros(2,n_f,3);
color_bank_two(1,:,:) = brewermap(n_f, 'Reds');
color_bank_two(2,:,:) = brewermap(n_f, 'Blues');

MakeFigure;
for kk = 1:1:n_k
    subplot(4, 1, kk);
    
    for f = 1:1:length(ff_plot)
        % preferred direction
        ff = ff_plot(f);
        
        SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(ff, kk, 1)),...
            resp_sem(:, epoch_index(ff, kk, 1)),...
            color_bank_two(1, ff,:),...
            'stim_dur', stim_info.stim_dur,...
            'f_stim', stim_info.f_stim,...
            'set_integrate_len', true,...
            'plot_integrate_shading', false,...
            'f_vals', fVals(ff)); hold on;
        
    end
    for f = 1:1:length(ff_plot)
        % null direction.
        ff = ff_plot(f);
        SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(ff, kk, 2)),...
            resp_sem(:, epoch_index(ff, kk, 2)),...
            color_bank_two(2, ff,:),...
            'stim_dur', stim_info.stim_dur,...
            'f_stim', stim_info.f_stim,...
            'set_integrate_len', true,...
            'plot_integrate_shading', false,...
            'f_vals', fVals(ff)); hold on;
        
    end
    if kk == 1 
        legend_str = [cellfun(@(x) ['pref ', x], ff_plot_str, 'UniformOutput',false), cellfun(@(x) ['null ', x], ff_plot_str, 'UniformOutput',false)];
        legend(legend_str);
    end
    %     set(gca, 'YLim', [-0.15, 0.5]);
    if kk == n_k
        xlabel('time (s)');
    end
    
    title(['SF: ', sf_str{kk},]);
    
end
end
