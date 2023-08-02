

function plot_utils_plot_arrow(x, y, dir, face_color, edge_color, varargin)
linewidth = 1;
tip_len = 10;
width = 2;
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

% TODO: implementation of the arrow is harder than I imaginged.
% [X, Y] = plot_utils_ax2norm(x, y);
%% https://www.mathworks.com/help/matlab/ref/matlab.graphics.shape.arrow-properties.html
% ar = annotation('arrow', X, Y);
hold on
if dir == 1
    arrow([x(1), y(1)], [x(2), y(2)],'FaceColor',face_color, 'EdgeColor', edge_color, 'LineWidth', linewidth, 'Length', tip_len, 'BaseAngle', 90, 'Width', width);
else
    arrow([x(2), y(2)], [x(1), y(1)],'FaceColor',face_color, 'EdgeColor', edge_color, 'LineWidth', linewidth, 'Length', tip_len, 'BaseAngle', 90, 'Width', width);
end
% plot(x, y, 'color', color, 'LineWidth', 5);
hold off
end