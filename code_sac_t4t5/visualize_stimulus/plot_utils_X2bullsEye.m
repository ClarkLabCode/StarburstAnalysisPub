function plot_utils_X2bullsEye(x)
% x in units of contrast.
x = (x + 1)/2;
%% Create a
nbar = length(x);
x_inner = 0:1:nbar - 1;

axis equal
axis tight
colormap(gray)
box off
axis off
P = cell(nbar, 1);
for ii = 1:1:nbar
    P{ii} = annulus(x_inner(ii), x_inner(ii) + 1, 0,0,0,0);
    P{ii}.FaceColor = [1,1,1] * x(ii);
    P{ii}.FaceAlpha = 1;
end
set(gca, 'CLim', [0,1]); % luminance map.
end