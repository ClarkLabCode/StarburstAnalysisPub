function visual_stimulus_white_noise_stimulus_part_1(left, top, ax_w, ax_h)
T = 11;
X = 15;
n_ring = 15; % effective ring;

%% visual specs
interval = 40;
positions = {[left, top, ax_h, ax_h], [left + (ax_h + interval), top, ax_w, ax_h]};

%% plot static stimulus
axes('Unit', 'point', 'Position', positions{1});
plot_spatial_discretization(n_ring, zeros(n_ring, 1), []);
plot_utils_plot_SAC(10);


%%
tx = rand(T, X);
tx(tx > 0.5) = 1;
tx(tx < 0.5) = -1;
axes('Unit', 'point', 'Position', positions{2});
plot_utils_xtplot(tx(1:T, :) * 2);
plot_utils_plot_colorframes([0,0,0], '-');


end
