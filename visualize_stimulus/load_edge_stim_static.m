

function [x] = load_edge_stim_static(dir, pol, N) % light edge.
% x = ones(1, N) * - 1;
x = zeros(1, N);
if dir == 1
    x(1:floor(N/2)) = 1;
else
    x(floor(N/2):end) = 1;
end

x = x * pol;
end