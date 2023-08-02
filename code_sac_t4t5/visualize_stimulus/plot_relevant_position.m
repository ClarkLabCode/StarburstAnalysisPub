function plot_relevant_position(N, phases, cord)
color = [108, 190, 69]/255;
% N: how many rings to plot.
% ring_pattern:
% text



if strcmp(cord, 'polar')
    
    inner_pos = phases(1) - 1;
    outer_pos = max(phases(end), phases(1));
    
    if inner_pos > 0
        plot_utils_circle(0, 0, inner_pos, 'color', color); % innner
    end
    plot_utils_circle(0, 0, outer_pos,'color', color); % outer
    
else
    % plot the
    hold on
    inner_pos = phases(1) - 0.5;
    outer_pos = max(phases(end), phases(1)) + 0.5;
    ylim = get(gca, 'YLim');
    plot([inner_pos, inner_pos], ylim, 'color', color);
    plot([outer_pos, outer_pos], ylim, 'color', color);
    plot([inner_pos, outer_pos], [ylim(1), ylim(1)], 'color', color);
    plot([inner_pos, outer_pos], [ylim(2), ylim(2)], 'color', color);
    hold off
end

end
