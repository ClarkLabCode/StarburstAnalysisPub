function T4T5_SingleBar_Plot_Utils_PlotTimeTraces(resp_ave, resp_sem, color_use, varargin)
accessory = 0;
%% experimental parameter.
stim_onset_sec = 0.2; % 200 ms.
stim_dur_sec = 1; % 1 second

%% plotting parameters
limPreSetFlag = 0;
maxValue = [];
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end
resp_time = linspace(-stim_onset_sec, stim_onset_sec + stim_dur_sec, size(resp_ave, 1))';

%% plotting.
PlotXY_Juyue(resp_time, resp_ave,'errorBarFlag',1,'sem',resp_sem,...
    'colorMean', color_use, 'colorError',color_use, 'limPreSetFlag', limPreSetFlag, 'maxValue', maxValue); hold on;
if accessory
    plot_utils_shade([0,0 + stim_dur_sec], get(gca,'YLim'));
    ylabel('\Delta F/F');
    xlabel('time (s)');
end
hold on;
end