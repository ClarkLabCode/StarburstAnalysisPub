function plot_utils_plot_colorframes(color, line_style, varargin)
cord = 'cart';

for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

linewidth = 1;
xlim = get(gca, 'XLim');
ylim = get(gca, 'YLim');

if strcmp(cord, 'cart')
    
    hold on
    plot([xlim(1), xlim(1)], [ylim(1), ylim(2)], 'color', color, 'LineWidth', linewidth, 'LineStyle', line_style);
    plot([xlim(2), xlim(2)], [ylim(1), ylim(2)], 'color', color, 'LineWidth', linewidth, 'LineStyle', line_style);
    plot([xlim(1), xlim(2)], [ylim(1), ylim(1)], 'color', color, 'LineWidth', linewidth, 'LineStyle', line_style);
    plot([xlim(1), xlim(2)], [ylim(2), ylim(2)], 'color', color, 'LineWidth', linewidth, 'LineStyle', line_style);
    hold off
    
elseif strcmp(cord, 'polar')
    r = diff(xlim)/2;
    plot_utils_circle(0, 0, r, 'color', color);
end
end
