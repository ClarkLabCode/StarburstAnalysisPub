function figure_opponent_barplot_plot_utils(resp_ind_cell_mat, colors, left, top, ax_w, ax_h, max_plot_value)
resp_ave = mean(resp_ind_cell_mat,1);
resp_sem = std(resp_ind_cell_mat, 1, 1)/sqrt(size(resp_ind_cell_mat, 1));

positions = [left, top, ax_w, ax_h];

pref = resp_ind_cell_mat(:,1);
oppo = resp_ind_cell_mat(:,3);
null = resp_ind_cell_mat(:,2);

%% what if you changed ttest?
p_pref_opp = signrank(pref, oppo, 'tail', 'right'); p_pref_opp = p_pref_opp * 3;
p_pref_null = signrank(pref, null); p_pref_null = p_pref_null * 3;
p_null_oppo = signrank(null, oppo); p_null_oppo = p_null_oppo * 3;

disp('Statistics for counter-phase stimulus');
disp(['Preferred direction / counter-phase: statistics with Sign Rank test, single tail-right, Bonferroni Correction n = 3, p = ', num2str(p_pref_opp)]);
disp(['Preferred direction / null direction: statistics with Sign Rank test, two-tail, Bonferroni Correction n = 3, p = ', num2str(p_pref_null)]);
disp(['null direction / counter-phase: statistics with Sign Rank test, two-tail, Bonferroni Correction n = 3, p = ', num2str(p_null_oppo)]);


%% plot bar
axes('Unit', 'point', 'Position', positions);
bar_scatter_plot_Juyue(resp_ave, resp_sem, resp_ind_cell_mat,  cat(1, colors{:}),...,
    'plot_individual_dot', 0, 'link_dots_flag', 0, 'xaxis', [0,1,2], 'bar_width', 0.5,...
    'line_style_bank', ['-';'-';'-'], 'line_width', 1, 'face_alpha', 1, 'do_sig_test_flag', 0, 'marker_face_alpha', 1);

% plot significance line.
alpha_1 = 0.05; alpha_2 = 0.01; alpha_3 = 0.001;
hold on;
if p_pref_opp < 0.05
    plot([0,2], [max_plot_value, max_plot_value] * 1.2, 'k-', 'LineWidth', 1);
    plot_stars(1, p_pref_opp, alpha_1, alpha_2, alpha_3,max_plot_value * 1.2 + 0.02, 0)
end
hold on;
if p_pref_null < 0.05
    plot([0,1], [max_plot_value, max_plot_value] * 1.05, 'k-', 'LineWidth', 1);
    plot_stars(0.5, p_pref_null, alpha_1, alpha_2, alpha_3, max_plot_value * 1.05 + 0.02, 0)
end
hold on;
if p_null_oppo < 0.05
    plot([1,2], [max_plot_value, max_plot_value] * 0.8, 'k-', 'LineWidth', 1);
    plot_stars(1.5, p_null_oppo, alpha_1, alpha_2, alpha_3, max_plot_value * 0.8 + 0.02, 0);
end

set(gca, 'YLim', [0,max_plot_value * 1.2], 'XLim', [-1,3]);
ConfAxis('fontSize',10, 'LineWidth', 1);
set(gca, 'XTick', [0,1,2], 'XTickLabel', {'PD', 'ND', 'PD + ND'}, 'XTickLabelRotation', 90);
end

function plot_stars(axis,pval,alpha_1, alpha_2, alpha_3, plotVerValue, showPValueFlag)
% how many points,

pPlotTripleStar = pval < alpha_3;
pPlotDoubleStar = pval < alpha_2 & ~pPlotTripleStar;
pPlotStar = pval < alpha_1 &  ~pPlotTripleStar &  ~pPlotDoubleStar;

hold on
single_star = '*';
double_star = '**';
triple_star = '***';

text(axis(pPlotStar)-0.02, ones(1,sum(pPlotStar)) * plotVerValue, single_star,...
    'HorizontalAlignment','Center');
text(axis(pPlotDoubleStar)-0.02, ones(1,sum(pPlotDoubleStar)) * plotVerValue, double_star,...
    'HorizontalAlignment','Center');
text(axis(pPlotTripleStar)-0.02, ones(1,sum(pPlotTripleStar)) * plotVerValue, triple_star,...
    'HorizontalAlignment','Center');

hold off

if showPValueFlag
    for ii = 1:1:length(axis)
        text(axis(ii),plotVerValue *  1.5,['p:',num2str(pval(ii))],'Rotation',90);
    end
end
end