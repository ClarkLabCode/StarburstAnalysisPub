%% deconvolution . have to finish that.
%% First, get the first order kernel. calcium deconvolve.
%% Second,get the second order kernel. calcium deconvolve
%% STC on the second.
clear
clc
%% extract kernels. from the SAC.
folder = 'D:\data_sac_calcium';
cell_list = {'cell18828_LE_01_b', 'cell18911_LE_02_a','cell18911_LE_02_b', 'cell18911_LE_03_a', 'cell18911_LE_03_b'};
n_cell = length(cell_list);
first_order_kernel = cell(n_cell, 1);
second_order_kernel = cell(n_cell, 1);

first_order_kernel_deconvolve = cell(n_cell, 1);
second_order_kernel_deconvolve = cell(n_cell, 1);

%% how to get the second order?  subtract off.
tic
for ii = 1:1:length(cell_list)
    [first_order_kernel_deconvolve{ii},~, ~] = SAC_Tmp_extract_kernel(cell_list{ii}, 1, 0 ,0.1, 1);
    [first_order_kernel{ii},~, ~] = SAC_Tmp_extract_kernel(cell_list{ii}, 1, 0 ,0.1, 0);
    
    [second_order_kernel_deconvolve{ii},~, ~] = SAC_Tmp_extract_kernel(cell_list{ii}, 2, 0 ,0.1, 1);
    [second_order_kernel{ii},~, ~] = SAC_Tmp_extract_kernel(cell_list{ii}, 2, 0 ,0.1, 0);
end
toc
%% exercies
% save('kernel_deconvol', 'first_order_kernel_deconvolve', 'first_order_kernel', 'second_order_kernel_deconvolve', 'second_order_kernel');
%% STC. Find the function. 
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


