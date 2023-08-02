function [mean_first_order_kernel_SVD, filter_svd, resp_ave, resp_sem, pred_ave] = SAC_white_noise_ExtractKernels(cell_name_all, fpass)
n_cell = length(cell_name_all);
tic
first_order_kernel = cell(n_cell, 1); pred_resp = cell(n_cell, 1); resp = cell(n_cell, 1);
for ii = 1:1:n_cell
    [first_order_kernel{ii}, ~, pred_resp{ii}, resp{ii}, ~] = SAC_Tmp_extract_kernel(cell_name_all{ii}, 1, 1, fpass, 0, 0); % cell_name, order, LN_flag, fpass, arma_flag, save_kernels)
    %     [second_order_kernel{ii},~, ~] = SAC_Tmp_extract_kernel(cell_list{ii}, 2, 0);
end
toc
first_order_kernel_across_rois = cell(n_cell, 1);
for ii = 1:1:n_cell
    first_order_kernel_across_rois{ii} = squeeze(mean(first_order_kernel{ii}, 3));
end
first_order_kernel_across_rois_mat = cat(3, first_order_kernel_across_rois{:});

%% L1 normalize, L2 normalize.
filter_L1 = zeros(size(first_order_kernel_across_rois_mat));
filter_L2 = zeros(size(first_order_kernel_across_rois_mat));
filter_svd = zeros(size(first_order_kernel_across_rois_mat));
for ii = 1:1:n_cell
    [filter_L1(:, :, ii), filter_L2(:, :, ii)] = normalize_one_filter(first_order_kernel_across_rois_mat(:, :, ii));
    filter_svd(:, :, ii) = clean_one_filter(first_order_kernel_across_rois_mat(:, :, ii));
end

%% average;


%% SVD
%% average all response.
[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
[~, pred_ave, ~] = SAC_GetAverageResponse(pred_resp);

mean_first_order_kernel = mean(first_order_kernel_across_rois_mat, 3); % do normalization. before averaging...
mean_first_order_kernel_L1 = mean(filter_L1, 3);
mean_first_order_kernel_L2 = mean(filter_L2, 3);
mean_first_order_kernel_SVD = mean(filter_svd, 3);

% MakeFigure; 
% subplot(2,2 ,1);
% quickViewOneKernel(mean_first_order_kernel, 1);
% title('original');
% subplot(2,2 ,2);
% quickViewOneKernel(mean_first_order_kernel_L1, 1);
% title('normalize by L1');
% subplot(2,2 ,3);
% quickViewOneKernel(mean_first_order_kernel_L2, 1);
% title('normalize by L2');
% subplot(2,2 ,4);
% quickViewOneKernel(mean_first_order_kernel_SVD, 1);
% title('SVD (first 3)');
 
% quickViewKernelsFirst(filter_L1);
% quickViewKernelsFirst(filter_L2);
%% normalize first.
end

function [filter_L1, filter_L2] = normalize_one_filter(filter)
filter_L2 = filter./sum(filter(:).^2);
filter_L1 = filter./sum(abs(filter(:)));
end

function filter_svd = clean_one_filter(filter)
[U, S, V] = svd(filter, 'econ');
%% plot the decomposition, take a look at  how many should be used.
% MakeFigure;
% subplot(2, 3, 1);
% quickViewOneKernel(filter, 1);
% subplot(2, 3, 2);
% scatter(1:size(V, 1), diag(S));
% subplot(2, 3, 3);
% quickViewOneKernel(U(:, 1) * V(:, 1)', 1);
% subplot(2, 3, 4);
% quickViewOneKernel(U(:, 1) * V(:, 1)' * S(1, 1) + U(:, 2) * V(:, 2)' * S(2,2), 1);
% subplot(2, 3, 5);
% quickViewOneKernel(U(:, 1) * V(:, 1)' * S(1, 1) + U(:, 2) * V(:, 2)' * S(2,2) + U(:, 3) * V(:, 3)' * S(3,3), 1);
% subplot(2, 3, 6);
% quickViewOneKernel(U(:, 1) * V(:, 1)' * S(1, 1) + U(:, 2) * V(:, 2)' * S(2,2) + U(:, 3) * V(:, 3)' * S(3,3) + U(:, 4) * V(:, 4)' * S(4,4), 1);

filter_svd = U(:, 1) * V(:, 1)' * S(1, 1) + U(:, 2) * V(:, 2)' * S(2,2) + U(:, 3) * V(:, 3)' * S(3,3);
end