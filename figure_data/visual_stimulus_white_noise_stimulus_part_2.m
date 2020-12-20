function visual_stimulus_white_noise_stimulus_part_2()
position = [36 + 160, 600, 80, 80];
T = 1000;
X = 15;
tx = rand(T, X);
tx(tx > 0.5) = 1;
tx(tx < 0.5) = -1;

axes('Unit', 'point', 'Position', position);
plot_utils_cross_correlogram(tx);
plot_utils_plot_colorframes([0,0,0], '-');

% make a another plot for color bars.
axes('Unit', 'point', 'Position', [36 + 320, 600, 80, 80]);
plot_utils_cross_correlogram(tx); colorbar;


end
