
function figure_white_noise_visualize_matching_process(X, Y, dx, dy, scale)
%% visualization spec;

left_1 = 54; left_2 = left_1 + 130; ax_w = 90; ax_h = 50; top_1 = 560; top_2 = 450

ratio = (dx ./ scale )./ dy;
Y_rescale = SACT4T5_white_noise_utils_rescale(Y, ratio);
t4t5_xlabel = linspace(-20, 20, size(Y_rescale, 2));

[score, idx_A, idx_B] = get_match_score_cosine_distance(X, Y_rescale);
idx_A(1, 2) = 31;
idx_B(1, 2) = 30;

A = X;
B = Y_rescale;

MakeFigure_Paper;

%% A
thisMaxVal = max(abs(A(:))); A = A/thisMaxVal;
axes('Unit', 'point', 'Position', [left_1, top_1, ax_w, ax_h]);

quickViewOneKernel(A, 1, 'barUse', [1, 8, 15]);
hold on; plot_frames(idx_A(2,:), idx_A(1,:)); hold off;
set(gca,'Clim',[-1 1]);ylabel('time (s)');
colorbar;
title('original SAC');
set(gca, 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 16, 31], 'YTickLabel', [0, 0.5, 1]);
ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;

axes('Unit', 'point', 'Position', [left_1, top_2, ax_w, ax_h]);
% imagesc(A(idx_A(1,1):idx_A(1,2), idx_A(2,1):idx_A(2,2)));
quickViewOneKernel(A(idx_A(1,1):idx_A(1,2), idx_A(2,1):idx_A(2,2)), 1, 'barUse', [1, 8, 15]);
set(gca,'Clim',[-1 1]);ylabel('time (s)');
set(gca, 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 16, 31], 'YTickLabel', [0, 0.5, 1]);
colorbar;
ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;

%% B
thisMaxVal = max(abs(Y(:))); Y = Y/thisMaxVal; B = B/thisMaxVal;
% t4t5_xlabel = [-20:5:20]; % How this is transferred?
axes('Unit', 'point', 'Position', [left_2, top_1, ax_w, ax_h]);
imagesc(t4t5_xlabel, 1:size(B, 1), B);
hold on; plot_frames(t4t5_xlabel(idx_B(2,:)), idx_B(1,:)); hold off;
set(gca,'Clim',[-1 1]);
colorbar;
% unit_t = (1/30) / scale(1); unit_x = 16 / scale(2);
% title({'rescaled T4T5: ', [num2str(unit_t), ' (s/pixel), ', num2str(unit_x), ' (\circ/pixel)']});
title('rescaled T4T5');
set(gca, 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 16, 30], 'YTickLabel', [0, 0.5, 1]);
xlabel('bar position (\circ)'); ylabel('time (s)');
ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;

axes('Unit', 'point', 'Position', [left_2, top_2, ax_w, ax_h]);
imagesc(t4t5_xlabel(idx_B(2,1):idx_B(2,2)), 1:size(B, 1), B(idx_B(1,1):idx_B(1,2), idx_B(2,1):idx_B(2,2)));
set(gca,'Clim',[-1 1]);
set(gca, 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 16, 30], 'YTickLabel', [0, 0.5, 1], 'XTick', [-5, 0, 5, 10]);
xlabel('bar position (\circ)'); ylabel('time (s)');
colorbar;
ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;

colormap_gen;
colormap(mymap);
end

function plot_frames(x, y)
plot([x(1), x(1)], y, 'k', 'LineWidth', 2);
plot([x(2), x(2)], y, 'k', 'LineWidth', 2);
plot(x, [y(1), y(1)], 'k', 'LineWidth', 2);
plot(x, [y(2), y(2)], 'k', 'LineWidth', 2);
end