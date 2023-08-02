function visual_stimulus_apparent_motion(colors, left_1, left_3, left_4, top_1, top_2, ax_w, ax_h)
plot_phase2_column(left_1, top_1,  top_2, ax_w, ax_h, colors);
plot_phase_demo(left_3, top_2 + ax_h + 10, 'polar', 20, 5);
plot_phase_demo(left_4, top_2 + ax_h + 10, 'cart', 20, 6);

end

function plot_phase2_column(left, top_1, top_2, ax_w, ax_h, colors)
%% first, plot the static stimulus.
hor = 4;
dir = [1, -1];

positions = {[left, top_1, ax_w, ax_h];[left + (ax_w + hor), top_1, ax_w, ax_h]};
title_str = {'\rightarrow', '\leftarrow'};

for dd = 1:1:2
    tx = load_apparent_motion_stim(dir(dd), 1, 1, 2);
    axes('Unit', 'point', 'Position', positions{dd});
    plot_spatial_discretization(size(tx, 2), tx(end,:), []);
    plot_utils_plot_SAC(3);
%     plot_utils_plot_arrow([0,4], [0,0], dir(dd), colors{dd}, colors{dd}, 'arrow_len', 1);
    plot_utils_plot_colorframes(colors{dd}, '-', 'cord', 'polar');
    title(title_str{dd}, 'FontSize', 10, 'color', colors{dd}, 'FontWeight', 'bold');
end

%% second, plot the XT plot.

positions = {[left, top_2, ax_w, ax_h/2],                 [left + (ax_w + hor), top_2, ax_w, ax_h/2];
    [left, top_2 - (ax_h +20), ax_w, ax_h/2],    [left + (ax_w + hor), top_2 - (ax_h +20), ax_w, ax_h/2];
    [left, top_2 - (ax_h +20) * 2, ax_w, ax_h/2],[left + (ax_w + hor), top_2 - (ax_h +20) * 2, ax_w, ax_h/2];
    [left, top_2 - (ax_h +20) * 3, ax_w, ax_h/2],[left + (ax_w + hor), top_2 - (ax_h +20) * 3, ax_w, ax_h/2];
    };

polarity_str = {'+', '-'};
direction_str = {'\rightarrow', '\leftarrow'};

lead_polarity = [1, -1];
lag_polarity = [1, -1];
phase = 2;
ee = 1;
for dd = 1:1:2
    for cc_lead = 1:1:2
        for cc_lag = 1:1:2
            tx = load_apparent_motion_stim(dir(dd), lead_polarity(cc_lead), lag_polarity(cc_lag), phase);
            axes('Unit', 'point', 'Position', positions{ee});
            plot_utils_xtplot(tx);
            plot_utils_plot_colorframes(colors{dd}, '-', 'cord', 'cart');
            if dd == 1
                title_str = ['(', polarity_str{cc_lead}, ',', polarity_str{cc_lag}, ',\rightarrow/\leftarrow)']; % right first half
                title(title_str, 'FontSize', 10);
            end
            ee = ee + 1;
        end
    end
end


end

function plot_phase_demo(left, top, cord, ax_w, N)

hor = 4;
ax_w = 20; ax_h = 20; % 120 in
positions = {[left, top, ax_w, ax_h];
    [left + (ax_w + hor),     top , ax_w, ax_h];
    [left + (ax_w + hor) * 2, top, ax_w, ax_h];
    [left + (ax_w + hor) * 3, top, ax_w, ax_h];
    [left + (ax_w + hor) * 4, top, ax_w, ax_h];
    [left + (ax_w + hor) * 5, top, ax_w, ax_h]};

% four phases.
for pp = 1:1:(N - 1)
    axes('Unit', 'point', 'Position', positions{pp});
    x = zeros(1,N);
    x([pp, pp + 1]) = 1;
    if strcmp(cord, 'polar')
        plot_spatial_discretization(N, zeros(1, N), []);
    else
        plot_spatial_discretization_rec(N,  zeros(1, N), []);
    end
    plot_relevant_position(N, find(x == 1), cord);
end

end

