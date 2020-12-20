function plot_spatial_discretization_rec(N, pattern, x_label)

plot_utils_X2recTangle(pattern);
for ii = 1:1:(N - 1) 
    hold on
    plot([ii, ii] + 0.5, get(gca, 'YLim'), 'k-');
    hold off
end

for ii = x_label
    text(ii, 0, num2str(ii), 'fontSize', 10);
end
end