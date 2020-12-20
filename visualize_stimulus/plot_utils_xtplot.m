
function plot_utils_xtplot(xt, varargin)
plot_xt_axis = 0;
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

% [T, X];
[T, N] = size(xt);
xt = (xt + 1)/2;

imagesc([0,T-1], [0:N-1], xt);colormap(gray);
axis tight
% set(gca, 'XAxisLocation', 'top', 'XTick', [], 'YTick',[], 'YTickLabel', []);
axis off
set(gca, 'CLim', [0,1]); 
% if plot_xt_axis
%     margin = 0.1 * diff(get(gca, 'XLim'));
%     plot_utils_plot_arrow([-margin, margin * 2], [-margin, -margin], 1, [0,0,0]); text(-margin, -margin - 5, 'x', 'FontSize', 10);
%     plot_utils_plot_arrow([-margin, -margin], [-margin, margin * 2], 1, [0,0,0]); text(-margin, -margin - 5, 't', 'FontSize', 10);
% end

end

