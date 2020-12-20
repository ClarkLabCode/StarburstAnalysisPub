function T4T5_Plot_Utils_PlotStimCont_YReverse(stim, color_box)
imagesc(stim'); colormap(gca, gray);
set(gca, 'XTick',[], 'YTick', [], 'clim',[-1,1]);
set(gca, 'YTick', [1,5,9], 'YTickLabel',{'0','4' '8(0)'});
ConfAxis('fontSize',10);
set(gca, 'XColor', color_box,'YColor', color_box);
box on
% ylabel('space','Color', [0,0,0]);
% xlabel('time', 'Color', [0,0,0]);
end