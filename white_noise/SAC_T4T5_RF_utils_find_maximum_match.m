function [scores, best_scale] = SAC_T4T5_RF_utils_find_maximum_match(X, Y, dx, dy, temporal_scales, spatial_scales)
% X, Y first order kernel. [time, space]
% dx, dy: [temporal scale, spatial scale] of X and Y.

% X:
% unit_space_x: 5 degree/pixel
% unit_space_y: 16 micro/pixel


% Y
% unit_time_x: 1/30 sec / pixel
% unit_time_y: 1/60 sec / pixel
plot_flag = 0;

n_time = length(temporal_scales);
n_space = length(spatial_scales);
scores = zeros(n_time, n_space);

for jj = 1:1:n_space
    for ii = 1:1:n_time
        
        scale = [temporal_scales(ii), spatial_scales(jj)];
        ratio = (dx ./  scale)./ dy;
        % interpolate Y, keep X the same.
        Y_rescale = SACT4T5_white_noise_utils_rescale(Y, ratio);
        [scores(ii, jj), ~] = get_match_score_cosine_distance(X, Y_rescale);
    end
end

[best_score, idx]= max(abs(scores(:))); [row, col] = ind2sub(size(scores), idx);
best_scale = [temporal_scales(row), spatial_scales(col)];

disp(['max similarity:  ', num2str(max(best_score(:)))]);

if plot_flag
    %% summarize matching result.
    MakeFigure;
    subplot(1,2,1);
    imagesc(scores);
    set(gca, 'XTick', 1:2:n_space, 'XTickLabel', num2str(spatial_scales(1:2:end)'), 'YTick', 2:2:n_time, 'YTickLabel', num2str(temporal_scales(2:2:end)'));
    xlabel({'spatial scale:', '1 \circ in fly ~ X \mum in mice'});
    ylabel({'temporal scale:','1 sec in fly ==  X sec in mice'});
    colormap(gray);
    set(gca, 'CLim', [min(scores(:)), max(scores(:))]);
    title({['Highest similarity score (cosine distance): ', num2str(best_score), '.'], ['The scale is ', num2str(best_scale(1)), ' (s/s),  ', num2str(best_scale(2)), ' (\mum/\circ)']});
    colorbar
    ConfAxis('fontSize', 12);
    box on;

    %% also, find the largest score, and demonstrate it.
    visualize_matching_process(X, Y, dx, dy, best_scale)
    
    %%
end
end

%% test the rescale first.
function B_q = SACT4T5_white_noise_utils_rescale(B, ratio)
F = griddedInterpolant(B);
F.Method = 'cubic';
[n_row, n_col] = size(B);
row_q = (1:ratio(1):n_row)';
col_q = (1:ratio(2):n_col)';
B_q  = F({row_q, col_q});
end
