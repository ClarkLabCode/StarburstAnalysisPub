function visual_stimulus_sinewave_stimulus(meta_info, colors_pref_null, tfs, dir_timetraces, colors, sw, ff_str, left, top, ax_s, ax_w, ax_h)

% plot the static, and XT plot.  use use 2 hz.
dir = [-1, 1];
tf = 2 ;
T = 61;
sw = 225; % large to small, small to large.
disp(['Sine wave demo, spatial frequency = ', num2str(sw), ', temporal frequency = ', num2str(tf)]);
xt = load_sinewave_stimulus(1, tf, sw);

%% visual specs

i1 = 9; i2 = 27;
positions = {[left, top, ax_s, ax_s], [left + (ax_s + i1), top, ax_w, ax_h];
             [left + (ax_s + i1) + (ax_w + i2) , top, ax_s, ax_s], [left + (ax_s + i1) * 2 + (ax_w + i2), top, ax_w, ax_h]};

%% plot
static_sinewave = xt(1, :);
for dd = 1:2
    axes('Unit', 'point', 'Position', positions{dd, 1});
    plot_utils_X2bullsEye(static_sinewave);
    plot_center_arrow(dir(dd), meta_info.N, colors_pref_null{dd}, colors_pref_null{dd}, 'polar', 0);
    plot_utils_plot_SAC(meta_info.SAC_N);

    plot_utils_plot_colorframes(colors_pref_null{dd}, '-', 'cord', 'polar');
    
    axes('Unit', 'point', 'Position', positions{dd, 2});
    xt = load_sinewave_stimulus(dir(dd), tf, sw);
    plot_utils_xtplot(xt(1:T, :), 'plot_xt_axis', 1); 
    plot_utils_plot_colorframes(colors_pref_null{dd}, '-', 'cord', 'cart');
    
end

% 2.2
total_w = (ax_w + ax_s + i1) * 2 + i2;
i1 = 4;
n = length(ff_str); ax_w = (total_w - (n - 1) * i1)/n; ax_h = ax_w;
sinewave_stimulus_fix_spatial(meta_info, tfs, dir_timetraces, colors, sw, ff_str, left, top - 80, ax_w, ax_h, i1);

end

function sinewave_stimulus_fix_spatial(meta_info, tfs, dir, colors, sw, ff_str, left, top, ax_w, ax_h, i1)

%% data specs
T = 31;
% 
% %% visual specs
% top = 500; % 6 of them.
% ax_w = 30; ax_h = 30; i1 = 4;
positions = {[left, top, ax_w, ax_h], ...
    [left + ax_w + i1, top, ax_w, ax_h], ...
    [left + (ax_w + i1) * 2, top, ax_w, ax_h], ...
    [left + (ax_w + i1) * 3 , top, ax_w, ax_h], ...
    [left + (ax_w + i1) * 4, top, ax_w, ax_h], ...
    [left + (ax_w + i1) * 5, top, ax_w, ax_h],...
    [left + (ax_w + i1) * 6, top, ax_w, ax_h],...
    [left + (ax_w + i1) * 7, top, ax_w, ax_h]};



for ee = 1:1:length(dir)
    xt = load_sinewave_stimulus(dir(ee), tfs(ee), sw);
    axes('Unit', 'point', 'Position', positions{ee});
    plot_utils_xtplot(xt(1:T, :));
    plot_utils_plot_colorframes(colors{ee}, '-', 'cord', 'cart');
    title(ff_str{ee}, 'FontSize', 10 ,'color', colors{ee});

end
end

function sinewave_stimulus_fix_temporal(meta_info)
% 2.2, plot the static with different spatial frequency.
dir = [-1, -1, -1, -1, 1, 1, 1, 1];
tf = 2;
sws = [150, 225, 300, 450, 450, 300, 225, 150]; % large to small, small to large.
colors = mat2cell([brewermap(4, 'Blues');flipud(brewermap(4, 'Reds'))], ones(8, 1), [3]);
for ee = 1:1:length(dir)
    xt = load_sinewave_stimulus(dir(ee), tf, sws(ee));
    subplot(2, 8, ee + 8)
    plot_utils_X2bullsEye(xt(1,:));
    plot_center_arrow(dir(ee), meta_info.N, colors{ee}, 'polar', 0);
    plot_utils_plot_colorframes(colors{ee}, '-', 'cord', 'cart');
end


end