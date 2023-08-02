function plot_spatial_discretization(N, ring_pattern, ring_label)
% N: how many rings to plot.
% ring_pattern:
% text

plot_utils_X2bullsEye(ring_pattern);
for rr = 1:N
    plot_utils_circle(0, 0, rr);
end

for rr = ring_label
    text(rr - 1 -.5, 0, num2str(rr - 1), 'fontSize', 10);
end

end
