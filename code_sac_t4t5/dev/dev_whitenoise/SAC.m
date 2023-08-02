%% load SAC dataset.
data_tmp_folder = fullfile('/home/lc/jc/work/lab_SAC_Calcium/data_sac_calcium/', 'kernel_deconvol_SAC.mat');
load(data_tmp_folder); % you are using T5 data
cell_list = {'cell18828_LE_01_b', 'cell18911_LE_02_a','cell18911_LE_02_b', 'cell18911_LE_03_a', 'cell18911_LE_03_b'};

%%
n_cell = length(first_order_kernel);
first_order_kernel_across_rois_deconv = cell(n_cell, 1);
second_order_kernel_across_rois_deconv = cell(n_cell, 1);

for ii = 1:1:n_cell
    first_order_kernel_across_rois_deconv{ii} = squeeze(mean(first_order_kernel_deconvolve{ii}, 3));
    second_order_kernel_across_rois_deconv{ii} = squeeze(mean(second_order_kernel_deconvolve{ii}, 3));
end

%%
first_order_kernel_across_rois = cell(n_cell, 1);
second_order_kernel_across_rois = cell(n_cell, 1);

for ii = 1:1:n_cell
    first_order_kernel_across_rois{ii} = squeeze(mean(first_order_kernel{ii}, 3));
    second_order_kernel_across_rois{ii} = squeeze(mean(second_order_kernel{ii}, 3));
end

%%
first_order_kernel_across_rois_mat_deconv = cat(3, first_order_kernel_across_rois_deconv{:});
quickViewKernelsFirst(first_order_kernel_across_rois_mat_deconv);


first_order_kernel_across_rois_mat = cat(3, first_order_kernel_across_rois{:});
quickViewKernelsFirst(first_order_kernel_across_rois_mat);
for ii = 1:1:n_cell
    subplot(2, 3, ii);
    title(cell_list{ii}, 'Interpreter', 'none');
end
MySaveFig_Juyue(gcf, 'individual_recordings', 'SAC', 'nFigSave',1,'fileType',{'png'});

%% you should plot them together.
for ii = 1:1:n_cell
    MakeFigure;
    subplot(2,2,1)
    quickViewOneKernel(squeeze(first_order_kernel_across_rois_mat(:,:,ii)), 1);
    title('original kernel');
    ConfAxis('fontSize', 15);
    box on
    
    subplot(2,2,2)
    quickViewOneKernel(squeeze(first_order_kernel_across_rois_mat_deconv(:,:,ii)), 1);
    title('deconvolved kernel');
    ConfAxis('fontSize', 15);
    box on
end


%% plot the averaged response of three of them.
averaged_first_order_kernel = mean(first_order_kernel_across_rois_mat(:, :, [1, 2, 4]), 3);
MakeFigure;
subplot(2,2,1)
quickViewOneKernel(squeeze(mean(first_order_kernel_across_rois_mat(:, :, [1, 2, 4]), 3)), 1);
title('averaged across 3 good ones');

subplot(2,2,2)
quickViewOneKernel(squeeze(mean(first_order_kernel_across_rois_mat, 3)), 1);
title('averaged across all 5');
MySaveFig_Juyue(gcf, 'averaged_first_order_kernel', 'SAC', 'nFigSave',1,'fileType',{'png'});