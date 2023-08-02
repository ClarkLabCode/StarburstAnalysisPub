function visual_stimulus_scintillator_stimulus_part_1(colors, left, top, ax_s, ax_w, ax_h)
T = 11;
tx = load_scintillator_stimulus(1, 1, 1) * 2;

%% visual specs
interval = 18;
positions = {[left, top, ax_s, ax_s], [left + (ax_s + interval), top, ax_w, ax_h]};

%% plot
axes('Unit', 'point', 'Position', positions{1});
N = 5; ring_pattern = tx(1, 1:N); ring_label = [];
plot_spatial_discretization(5, ring_pattern, ring_label);
plot_utils_plot_SAC(3);

axes('Unit', 'point', 'Position', positions{2});
plot_utils_xtplot(tx(1:T, 1:N));
plot_utils_plot_colorframes(colors{1}, '-', 'cord', 'cart');


end
