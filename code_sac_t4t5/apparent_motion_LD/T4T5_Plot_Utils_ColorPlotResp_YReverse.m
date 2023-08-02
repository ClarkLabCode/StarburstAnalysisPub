function T4T5_Plot_Utils_ColorPlotResp_YReverse(resp, set_c_max, c_max, varargin)
stim_second_bar_on = 0.15; % 0.15 second.
stim_onset_sec = 0.2; % 200 ms.
stim_dur_sec = 1; % 1 second
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end
resp_time = linspace(-stim_onset_sec, stim_onset_sec + stim_dur_sec, size(resp, 1))';
n_phase = size(resp, 2);
%%
imagesc(resp_time, [1:n_phase], resp');
set(gca, 'XTick',[0,1], 'XTickLabel', {'0', '1'});
set(gca, 'YTick', [1,5,9], 'YTickLabel',{'0','4' '8(0)'});
% set(gca, 'XColor', color_box,'YColor', color_box);
%%
hold on;
h1 = plot([0, 0], get(gca,'YLim'), 'k--');  h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2 = plot([0 + stim_dur_sec, 0 + stim_dur_sec], get(gca,'YLim'), 'k--');h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2 = plot([0 + stim_second_bar_on, 0 + stim_second_bar_on], get(gca,'YLim'), 'k--');h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
ConfAxis('fontSize',10);

%%
mymap = flipud(brewermap(100, 'RdBu'));
colormap(gca, mymap);
if ~set_c_max
    c_max = abs(max(resp(:)));
end
set(gca, 'CLim', [-c_max, c_max]);
box on
% b2r(-0.1, 0.3, 0);
% hc = colorbar;
% hc.label()
% ylabel('space','Color', [0,0,0]);
% xlabel('time', 'Color', [0,0,0]);
end