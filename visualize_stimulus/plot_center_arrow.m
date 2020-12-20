function plot_center_arrow(dir, N, face_color, edge_color, cord, offset, varargin)
tip_len = 8;
width = 2;
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

% specify the length of the arrow
arrow_start = floor(N/4);
arrow_len = floor(N/2);

if strcmp(cord, 'polar')
    % plot 4 arrows, left, right, up, down
    x_bank = {[arrow_start, arrow_start + arrow_len], [-arrow_start, -(arrow_start + arrow_len)], [offset, offset], [offset, offset]};
    y_bank = {[offset, offset], [offset, offset],  [arrow_start, arrow_start + arrow_len], [-arrow_start, -(arrow_start + arrow_len)]};
else
    x_bank = {[arrow_start, arrow_start + arrow_len]};
    y_bank = {floor([N/2, N/2] + offset)};
end

for ii = 1:1:length(x_bank)
    plot_utils_plot_arrow(x_bank{ii}, y_bank{ii}, dir, face_color, edge_color, 'tip_len', tip_len, 'width', width);
end
end