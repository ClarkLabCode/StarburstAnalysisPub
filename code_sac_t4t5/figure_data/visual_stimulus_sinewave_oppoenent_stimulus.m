function visual_stimulus_sinewave_oppoenent_stimulus(meta_info, colors, left)
%% data specs
T = 61;
offset = 10;
%% visual specs
v_pos = 600;
ax_s = 45;
ax_w = 27; ax_h = 45;
i1 = 9;
i2 = 27;
positions = {[left, v_pos, ax_s,ax_s],                                                        [left + (ax_s + i1), v_pos, ax_w, ax_h];
             [left + (ax_s + i1)  + (ax_w + i2) ,        v_pos, ax_s, ax_s],          [left + (ax_s + i1) * 2 + (ax_w + i2),  v_pos, ax_w, ax_h];
             [left + (ax_s + i1) * 2 + (ax_w + i2) * 2 , v_pos, ax_s, ax_s], [left + (ax_s + i1) * 3 + (ax_w + i2) * 2, v_pos, ax_w, ax_h]};


dir = [-1, 1, 0];
title_str = {'(\leftarrow)', '(\rightarrow)', '(\leftarrow + \rightarrow)'};
for dd = 1:length(dir)
    xt = load_sinewave_opponent_stimulus(dir(dd));
    
    % static
    axes('Unit', 'point', 'Position', positions{dd, 1});
    plot_utils_X2bullsEye(xt(1,:));
    % plot a dashline to indicate SAC.
    plot_utils_plot_SAC(meta_info.SAC_N, colors{dd});
    
    if dd == 3
        plot_center_arrow(1, meta_info.N, colors{dd}, colors{dd}, 'polar', offset, 'width', 1);
        plot_center_arrow(-1, meta_info.N, colors{dd}, colors{dd}, 'polar', -offset, 'width', 1);
    else
        plot_center_arrow(dir(dd), meta_info.N, colors{dd}, colors{dd}, 'polar',0, 'width', 1);
    end
    plot_utils_plot_colorframes(colors{dd}, '-', 'cord', 'polar');

    
    % tx plot
    axes('Unit', 'point', 'Position', positions{dd, 2});
    plot_utils_xtplot(xt(1:T, :))
    plot_utils_plot_colorframes(colors{dd}, '-', 'cord', 'cart');
    title(title_str{dd}, 'FontSize', 10, 'color', colors{dd});
end
end