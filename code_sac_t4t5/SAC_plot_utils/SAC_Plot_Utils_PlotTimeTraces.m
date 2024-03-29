function SAC_Plot_Utils_PlotTimeTraces(resp_ave, resp_sem, color_use, varargin)
%% experimental parameter.
f_resp = 15.625;
f_stim = 60;
stim_onset = 1; % always 1 second. hardcoded? independent of the stimulus.
resp_time = (1:size(resp_ave, 1))'/f_resp - stim_onset;
stim_dur = 300;

%% plotting parameter.
plot_integrate_shading = false;
set_integrate_len = false;
f_vals = [];
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

%% plot response
PlotXY_Juyue(resp_time,resp_ave,'errorBarFlag',1,'sem',resp_sem,...
    'colorMean', color_use, 'colorError',color_use); hold on;

if plot_integrate_shading
    %% get the integration onidx and offidx. use the same function in actual averaging.
    [integrate_on_idx, integrate_off_idx, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(set_integrate_len, f_vals);
    plot_utils_shade([resp_time(integrate_on_idx),resp_time(integrate_off_idx)], get(gca,'YLim')); hold on;
end

%% plot stim onset/offset.
stim_dur = stim_dur/f_stim;
h1 = plot([0, 0], get(gca,'YLim'), 'k--');  h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2 = plot([stim_dur, stim_dur], get(gca,'YLim'), 'k--');h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
ylabel('\Delta F/F');
hold on;
ConfAxis('fontSize',10);

%% set interleave to be shorter. 
set(gca, 'XLim', [-0.5, stim_dur + 0.1]);
end