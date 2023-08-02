function visual_stimulus_single_and_two_simultaneous_bars(type, left_1, left_3, left_4, top, ax_w, ax_h)

plot_phase2_column(type, left_1, top, ax_w, ax_w);
plot_phase_demo(type, left_3, top + ax_h + 10, 'polar', 5); %
plot_phase_demo(type, left_4, top + ax_h + 10, 'cart', 6); % plotting T4T5 as well.
end

function plot_phase2_column(type, left, top, ax_w, ax_h)
ver = 40;
% determine layout.
phase = 2;

%% 1. plot the static stimulus. no need to represent the XT plot for static stimulus.
tx = zeros(1, 5);

if strcmp(type, 'single_bar')
    positions = {[left, top, ax_w, ax_h];
        [left, top - (ax_h + ver), ax_w, ax_h]};
    tx(phase) = 1;
    txs = {tx * 1, tx * -1};
    title_str = {'(+)', '(-)'};
elseif strcmp(type, 'two_simultaneous_bars')
    positions = {[left, top, ax_w, ax_h];
        [left, top - (ax_h + ver), ax_w, ax_h],
        [left, top - (ax_h + ver) * 2, ax_w, ax_h],
        [left, top - (ax_h + ver) * 3, ax_w, ax_h]};
    txs = cell(4, 1);
    %% ++, +-, -+, ++
    left_polarity = [1, 1, -1, -1];
    right_polarity = [1, -1, 1, -1];
    title_str = {'(+,+)', '(+,-)', '(-,+)', '(-,-)'};
    for ee = 1:1:4
        txs{ee} = tx; txs{ee}(phase) = left_polarity(ee); txs{ee}(phase + 1) = right_polarity(ee);
    end
end

for ee = 1:1:length(txs)
    axes('Unit', 'point', 'Position', positions{ee});
    plot_spatial_discretization(size(tx, 2), txs{ee}, []);
    plot_utils_plot_SAC(3);
    title(title_str{ee}, 'FontSize', 10);
end

%% second, plot the XT plot.
% position = [left, top + ax_h + 10, ax_w, ax_h];
% axes('Unit', 'point', 'Position', position);
% plot_spatial_discretization(size(tx, 2), tx(end,:), []);
end

function plot_phase_demo(type, left, top, cord, N)
hor = 4;
% ax_w = (bar_plot_width - (interval * N))/N;
ax_w = 20; ax_h = 20; % 120 in
positions = {[left, top, ax_w, ax_h];
    [left + (ax_w + hor),     top , ax_w, ax_h];
    [left + (ax_w + hor) * 2, top, ax_w, ax_h];
    [left + (ax_w + hor) * 3, top, ax_w, ax_h];
    [left + (ax_w + hor) * 4, top, ax_w, ax_h];
    [left + (ax_w + hor) * 5, top, ax_w, ax_h]};

x = zeros(1, N);
if strcmp(type, 'single_bar')
    xs = cell(N, 1);
    for pp = 1:1:N
        xs{pp} = x; xs{pp}(pp) = 1;
    end
    
elseif strcmp(type, 'two_simultaneous_bars')
    xs = cell(N-1, 1);
    
    for pp = 1:1:N-1
        xs{pp} = x; xs{pp}(pp) = 1; xs{pp}(pp + 1) = 1;
    end
    
end

%
for pp = 1:1:length(xs)
    axes('Unit', 'point', 'Position', positions{pp});
    if strcmp(cord, 'polar')
        plot_spatial_discretization(N, zeros(1, N), []);
    else
        plot_spatial_discretization_rec(N, zeros(1, N), []);
    end
    plot_relevant_position(N, find(xs{pp} == 1), cord);
end

end