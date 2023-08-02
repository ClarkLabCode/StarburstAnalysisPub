function SAC_Plot_Utils_BarPlot_Setup_Axis(x_lim, y_lim, x_tick, visible_xtick_flag)
ax_tmp = gca;
set(ax_tmp, 'YLim', y_lim, 'XLim', x_lim, 'XTick', x_tick);
xlabel('bar/ring positiion: x & x + 1');
ylabel('\DeltaF/F');
if ~visible_xtick_flag
    ax_tmp = gca;
    ax_tmp.XAxis.Visible = 'off';
end
ConfAxis('fontSize',10, 'LineWidth', 1);
end