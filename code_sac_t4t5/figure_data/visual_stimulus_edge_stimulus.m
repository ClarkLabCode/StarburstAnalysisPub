
function visual_stimulus_edge_stimulus(meta_info, colors, line_style, which_cord, top, left)
ax_w = 27; hor_interval = 18; ver_interval = 27;
positions = {[left, top, ax_w, ax_w]; 
             [left + (ax_w + hor_interval),     top, ax_w, ax_w];
             [left,                         top - (ax_w + ver_interval), ax_w, ax_w]; 
             [left + (ax_w + hor_interval), top - (ax_w + ver_interval), ax_w, ax_w]};

% 1. edge stimulus. start comtemplate on the figure size.
dir = [-1, 1];
pol = [1, -1];
title_str = {'(-,\leftarrow)', '(-,\rightarrow)', '(+,\leftarrow)', '(+,\rightarrow)'};

ee = 1;
for pp = [2, 1]
    for dd = 1:1:length(dir)
        edge_stim = load_edge_stim_static(dir(dd), pol(pp), meta_info.N);
        
        axes('Unit', 'point', 'Position', positions{ee});

        %% cartesian
        hold on
        if strcmp(which_cord, 'polar')
            plot_utils_X2bullsEye(edge_stim);
            tip_len = 5;
            width = 0.5;
        elseif strcmp(which_cord, 'cart')
            plot_utils_X2recTangle(edge_stim);
            tip_len = 12;
            width = 3;
        end
        face_color = colors{dd};
        edge_color = colors{dd};
        
        plot_center_arrow(dir(dd), meta_info.N, face_color, edge_color, which_cord, 0, 'tip_len', tip_len, 'width', width);
        plot_utils_plot_colorframes(colors{dd}, line_style{pp}, 'cord', which_cord);
        title(title_str{ee},'FontSize', 10, 'color', colors{dd});
        ee = ee + 1;
    end
end

% MySaveFig_Juyue(gcf, 'visual_stim','edge_v0','nFigSave',1,'fileType',{'png'});
end
