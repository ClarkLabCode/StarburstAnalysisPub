
function visualize_matching_process(X, Y, dx, dy, scale)
ratio = (dx ./ scale )./ dy;
Y_rescale = SACT4T5_white_noise_utils_rescale(Y, ratio);

[score, idx_A, idx_B] = get_match_score_cosine_distance(X, Y_rescale);

A = X;
B = Y_rescale; 
MakeFigure;
%% A
thisMaxVal = max(abs(A(:))); A = A/thisMaxVal;
subplot(2, 3, 1);
imagesc(A);
hold on; plot_frames(idx_A(2,:), idx_A(1,:)); hold off;
set(gca,'Clim',[-1 1]);
colorbar;
title({['original SAC: '], [num2str(1/30), ' (s/pixel), 16 (\mum/pixel)']});


subplot(2, 3, 4);
imagesc(A(idx_A(1,1):idx_A(1,2), idx_A(2,1):idx_A(2,2)));
set(gca,'Clim',[-1 1]);
title({['original SAC: '], [num2str(1/30), ' (s/pixel), 16 (\mum/pixel)']});


colorbar;
colormap_gen;
colormap(mymap);

%% B
thisMaxVal = max(abs(Y(:))); Y = Y/thisMaxVal; B = B/thisMaxVal;
subplot(2, 3, 3)
imagesc(Y);
title({'original T4T5: ', [num2str(1/60), ' (s/pixel), 5 (\circ/pixel)']});

set(gca,'Clim',[-1 1]);
colorbar;

subplot(2, 3, 2);
imagesc(B)
hold on; plot_frames(idx_B(2,:), idx_B(1,:)); hold off;
set(gca,'Clim',[-1 1]);
colorbar;
unit_t = (1/30) / scale(1); unit_x = 16 / scale(2);
title({'rescaled T4T5: ', [num2str(unit_t), ' (s/pixel), ', num2str(unit_x), ' (\circ/pixel)']});

subplot(2, 3, 5);
imagesc(B(idx_B(1,1):idx_B(1,2), idx_B(2,1):idx_B(2,2)));
set(gca,'Clim',[-1 1]);
colorbar;
title({'rescaled T4T5: ', [num2str(unit_t), ' (s/pixel), ', num2str(unit_x), ' (\circ/pixel)'], ['This cosine distance is: ', num2str(score)]});

colormap_gen;
colormap(mymap);
end
function plot_frames(x, y)
plot([x(1), x(1)], y, 'r', 'LineWidth', 2);
plot([x(2), x(2)], y, 'r', 'LineWidth', 2);
plot(x, [y(1), y(1)], 'r', 'LineWidth', 2);
plot(x, [y(2), y(2)], 'r', 'LineWidth', 2);
end