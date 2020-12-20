function plot_utils_plot_SAC(r, varargin)
line_style = '--';
color = [22, 76, 64]/100;
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

plot_utils_circle(0, 0, r, 'color', color, 'line_style', line_style);
end
