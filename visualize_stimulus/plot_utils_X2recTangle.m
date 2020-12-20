function plot_utils_X2recTangle(x)
x = (x + 1)/2;

N = length(x);
imagesc(1:N, 1:N, repmat(x, [N, 1]));colormap(gray);
axis equal
axis tight
set(gca, 'XTick', [],'YTick',[]);
set(gca, 'CLim', [0,1]);
end

