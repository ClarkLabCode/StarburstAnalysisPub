function visual_stimulus_scintillator_stimulus_part_2(colors, left1, left2, left3, top,  ax_w1, ax_w2)

%% 1. a demonstration following previous plot.
tx = load_scintillator_stimulus(1, 1, 1);
axes('Unit', 'point', 'Position', [left3, top, ax_w1, ax_w1]);
plot_utils_cross_correlogram(tx);
plot_utils_plot_colorframes(colors{1}, '-');
xlabel('\Deltar (\mum)', 'FontSize', 10);ylabel('\Deltat (ms)', 'FontSize', 10);

% make a another plot for color bars.
axes('Unit', 'point', 'Position', [320, top, ax_w1, ax_w1]);
plot_utils_cross_correlogram(tx); colorbar;

%% 2. legend for time traces
top = top - 100;
i1 = 9; i2 = 36;
positions = {[left1, top, ax_w2, ax_w2], [left1 + (ax_w2 + i1), top, ax_w2, ax_w2];
             [left2, top, ax_w2, ax_w2], [left2 + (ax_w2 + i1), top, ax_w2, ax_w2]};

dir = [1, -1]; % dir opposite of spatial-offset
polarity = [1, -1];
title_str = {['(+,\rightarrow)'], 
             ['(+,\leftarrow)']
             ['(-,\rightarrow)']
             ['(-,\leftarrow)']};
ee = 1;
for pp = 1:length(polarity)
    for dd = 1:length(dir)
        tx = load_scintillator_stimulus(polarity(pp), dir(dd), 1);
        axes('Unit', 'point', 'Position', positions{pp, dd});
        
        plot_utils_cross_correlogram(tx);
        plot_utils_plot_colorframes(colors{dd}, '-');
        
        set(gca, 'XTick', [], 'YTick', []);
        title(title_str{ee}, 'FontSize', 10);
        % end
        ee = ee + 1;
    end
end
end