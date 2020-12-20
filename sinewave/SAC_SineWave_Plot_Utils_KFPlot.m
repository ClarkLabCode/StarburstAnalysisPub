function SAC_SineWave_Plot_Utils_KFPlot(resp, set_clim, c_max, varargin)

spatial_frequency_str = [];
spatial_frequency_unit = '';
temporal_frequency_str = [];

for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

mymap = flipud(brewermap(100,'RdBu'));
colormap(mymap);

imagesc(resp);
if isempty(spatial_frequency_str)
    set(gca ,'XTick', [1, 2, 3, 4], 'XTickLabel', {'1/15', '1/30', '1/60', '1/90'});
else
    set(gca ,'XTick', 1:length(spatial_frequency_str), 'XTickLabel', spatial_frequency_str, 'XTickLabelRotation', 90);
end
set(gca, 'YDir', 'normal');
set(gca, 'XDir', 'reverse');

if isempty(temporal_frequency_str)
    set(gca ,'YTick', [1:10], 'YTickLabel', {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','4\surd{2}','8', '8\surd{2}'}, 'YTickLabelRotation', 90);
else
    set(gca ,'YTick', 1:length(temporal_frequency_str), 'YTickLabel', temporal_frequency_str, 'YTickLabelRotation', 90);
end
ylabel('temporal frequency (Hz)','FontSize', 10);
xlabel({'spatial', ['frequency', ' (', spatial_frequency_unit, ')']},'FontSize', 10);

if set_clim
    set(gca, 'CLim', [-c_max, c_max]);
else
    c_max = max(abs(resp(:)));
    set(gca, 'CLim', [-c_max, c_max]);
end

ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;

%% set up the tick for colorbar.
% min_val = min(min(resp(:)), 0);
% set(ch, 'XTick', [min_val, c_max]);
end