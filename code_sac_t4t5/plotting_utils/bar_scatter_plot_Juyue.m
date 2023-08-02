function bar_scatter_plot_Juyue(data_ave, data_sem, data_points, color_bank, varargin)
%%
% data_points = [N, M]; where N is different data points, M is the
% dimension of the data.
%%
link_dots_flag = 1;
plot_individual_dot = 1;
xaxis = [];
bar_width = 0.3;
line_style_bank = [];
line_width = [];
face_alpha = 1;
marker_face_alpha = 1;
do_sig_test_flag = 0;
plot_max_value = [];
sig_bonferroni_n = size(data_ave, 2);

for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

n_data = length(data_ave);
if isempty(xaxis)
    xaxis = 1:n_data;
end

if isempty(line_style_bank)
    line_style_bank = repmat('-', [n_data, 1]);
end

if isempty(line_width)
    line_width = 0.5;
end

if isempty(plot_max_value)
    plot_max_value  = max(data_ave) + max(data_sem);
end
%% plot the average value.
for ii = 1:1:n_data
    hold on;
    bar(xaxis(ii), data_ave(ii),'FaceColor', color_bank(ii,:), 'EdgeColor', [0,0,0], 'FaceAlpha', face_alpha, ...
        'LineStyle', line_style_bank(ii,:), 'BarWidth', bar_width, 'LineWidth', line_width);
    hold off;
end
%% plot sem.
for ii = 1:1:n_data
    PlotErrorBar_Juyue(xaxis(ii), data_ave(ii), data_sem(ii));
end

if do_sig_test_flag
    plot_significant_point(xaxis, data_points, plot_max_value, 'sig_bonferroni_n', sig_bonferroni_n);
end
%% plot individual dot.
if plot_individual_dot
    if size(data_points, 1) > 2
        XYPos = scatterBar(data_points);
        for ii = 1:1:n_data
            hold on;
            h = scatter((XYPos(:, 1, ii) - ii)* - bar_width + xaxis(ii), XYPos(:, 2, ii), 50, '.','MarkerEdgeColor', color_bank(ii,:), 'MarkerFaceAlpha', marker_face_alpha);
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            hold off;
        end
        if link_dots_flag
            hold on
            for ii = 1:1:size(XYPos, 1)
                h = plot([1, 2], [data_points(ii, 1), data_points(ii, 2)], 'color', [0.5,0.5,0.5]);
                h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            end
            hold off
            % plot the line as well.
        end
    end
end
set(gca, 'XTick',[]);

end
function plot_significant_point(xaxis, data_points, plot_max_value, varargin) 
sig_bonferroni_n = size(data_points, 2);
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

% change to sign a
% [~, p_val, st] = ttest(data_points);
n_d = size(data_points, 2);
p_vals = zeros(n_d, 1);
for dd = 1:1:size(data_points, 2)
    p_vals(dd) = signrank(data_points(:, dd));
end
p_vals = sig_bonferroni_n * p_vals;
disp(['sign rank test, Bonferroni correction n = ', num2str(sig_bonferroni_n), ' p = ']);
disp(num2str(p_vals));

plot_stars(xaxis,p_vals, 0.05, 0.01, 0.001, plot_max_value * 0.9, 0);

end

function plot_stars(axis,pval,alpha_1, alpha_2, alpha_3, plotVerValue, showPValueFlag)
% how many points,
pPlotStar = pval < alpha_1;
pPlotDoubleStar = pval < alpha_2;
pPlotTripleStar = pval < alpha_3;


hold on
single_star = '*';

text(axis(pPlotStar)-0.02, ones(1,sum(pPlotStar)) * plotVerValue, single_star,...
    'HorizontalAlignment','Center');
text(axis(pPlotDoubleStar)-0.02, ones(1,sum(pPlotDoubleStar)) * plotVerValue * 1.1, single_star,...
    'HorizontalAlignment','Center');
text(axis(pPlotTripleStar)-0.02, ones(1,sum(pPlotTripleStar)) * plotVerValue * 1.2, single_star,...
    'HorizontalAlignment','Center');

hold off

if showPValueFlag
    for ii = 1:1:length(axis)
        text(axis(ii),plotVerValue *  1.5,['p:',num2str(pval(ii))],'Rotation',90);
    end
end
end