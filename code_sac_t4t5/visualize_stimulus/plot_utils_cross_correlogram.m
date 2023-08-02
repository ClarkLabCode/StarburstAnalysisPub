function plot_utils_cross_correlogram(tx)
t_range = 2;
x_range = 2;
[T, X] = size(tx);
r = xcorr2(tx);
r = r(T - t_range:T + t_range , X - x_range:X + x_range);
r_norm = r/max(r(:));
purple_green = brewermap(100, 'PRGn');
imagesc(r_norm); 
colormap(purple_green);
set(gca, 'CLim', [-1,1]);
set(gca, 'XTick',[2,3,4], 'XTickLabel',{'-50','0','50'}, 'XAxisLocation','top', 'YTick',[t_range,t_range+1 ,t_range+2], 'YTickLabel',{'-50','0','50'}, 'FontSize', 10);
end