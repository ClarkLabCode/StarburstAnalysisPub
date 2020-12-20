% extract kernels
clear
clc

hand_pick_flag = 1;
preprocess_flag = 0;
fpass = 0.1;
stim_name = 'white_noise';
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag);
% cell_name_all = {'18911_LE_02_a'};
n_cell = length(cell_name_all);

if preprocess_flag
    for ii = 1:1:n_cell
        SAC_PreProcess_5D_Movie(cell_name_all{ii}, 'dfoverf_method', 'lowhighpass', 'is_one_roi', 0, 'fpass', fpass, 'stim_name', 'white_noise');
    end
end

[mean_first_order_kernel, first_order_kernel_across_rois_mat, resp_ave, resp_sem, prediction] = SAC_white_noise_ExtractKernels(cell_name_all, fpass);

%% Plot All those kernels, averaged across different rois.
MakeFigure;
for ff = 1:1:n_cell
    subplot(3, 4, ff);
    quickViewOneKernel(squeeze(first_order_kernel_across_rois_mat(:,:, ff)), 1);
    title(cell_name_all{ff} , 'Interpreter', 'none');
end
% MySaveFig_Juyue(gcf, 'white_noise', 'individual_first', 'nFigSave',1,'fileType',{'png'})

MakeFigure;
subplot(2,2,1);
quickViewOneKernel(mean_first_order_kernel, 1);
title('averaged across all 9 recordings');
ConfAxis; box on;
MySaveFig_Juyue(gcf, 'white_noise', 'averaged', 'nFigSave',1,'fileType',{'png'})

%% Plot all time traces.
MakeFigure; 
for tt = 1:1:size(resp_ave, 2)
subplot(5, 1, tt);
resp_ave_plot = {resp_ave(:, tt), prediction(:, tt)};
resp_sem_plot = {resp_sem(:, tt), zeros(length(prediction), 1)};

%% plot.
plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, {[0,0,0]; [1, 0, 0]}, 'stim_dur', length(prediction));
title(['# trial : ', num2str(tt)])
end
MySaveFig_Juyue(gcf, 'white_noise', 'time_traces', 'nFigSave',1,'fileType',{'png'})
 
%% do score matching
clc
clear
S = GetSystemConfiguration;

sac_kernel = load(fullfile(S.sac_data_path, 'SAC_white_noise.mat'));
first_order_kernel_sac = sac_kernel.mean_first_order_kernel;
t4t5_kernel = load(fullfile(S.cached_T4T5_data_path, 'T4T5_white_noise.mat'));

%% average sac kernel together.
first_order_kernel_T4_progressive = squeeze(mean(t4t5_kernel.meanKernel{1}, 3));
first_order_kernel_T4_progressive = fliplr(first_order_kernel_T4_progressive); % left eye --> right eye.
first_order_kernel_T4_progressive = first_order_kernel_T4_progressive(:, 6:14);%% average sac kernel together.

%% lot of plotting.

temporal_scales = sqrt(2) .^ (1:7) * 1/4;
spatial_scales =  sqrt(2) .^ (4:12) ;
dx = [1/30, 16]; dy = [1/60, 5];
SAC_T4T5_RF_utils_find_maximum_match(first_order_kernel_sac, first_order_kernel_T4_progressive, dx, dy, temporal_scales, spatial_scales);
MySaveFig_Juyue(gcf, 'matching_kernels','cosine_score_sweep_log','nFigSave',1,'fileType',{'png'});

visualize_matching_process(first_order_kernel_sac, first_order_kernel_T4_progressive, dx, dy, [0.5, 16/sqrt(2)]);
MySaveFig_Juyue(gcf, 'matching_kernels','best','nFigSave',1,'fileType',{'png'});

visualize_matching_process(first_order_kernel_sac, first_order_kernel_T4_progressive, dx, dy, [0.75, 16/sqrt(2)]);
MySaveFig_Juyue(gcf, 'matching_kernels','t_075','nFigSave',1,'fileType',{'png'});

visualize_matching_process(first_order_kernel_sac, first_order_kernel_T4_progressive, dx, dy, [1, 16/sqrt(2)]);
MySaveFig_Juyue(gcf, 'matching_kernels','t_1','nFigSave',1,'fileType',{'png'});

%%
temporal_scales = [0.2:0.05:1];
spatial_scales =  [5:1:20];
dx = [1/30, 16]; dy = [1/60, 5];
SAC_T4T5_RF_utils_find_maximum_match(first_order_kernel_sac, first_order_kernel_T4_progressive, dx, dy, temporal_scales, spatial_scales);
MySaveFig_Juyue(gcf, 'matching_kernels','cosine_score_sweep_linear','nFigSave',1,'fileType',{'png'});
