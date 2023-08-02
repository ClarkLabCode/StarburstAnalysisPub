function figure_white_noise()
set(0,'defaultAxesFontName', 'Arial')
set(0,'DefaultAxesTitleFontWeight','normal');
left_1 = 54; left_2 = left_1 + 130; top_1 = 560; top_2 = 450; top_3 = 350; top_4 = 230; % plot four static ring.



%% white noise stimulus
MakeFigure_Paper;
visual_stimulus_white_noise_stimulus_part_1(left_1, top_1, 50, 60);

%% 2.1 prepare response SAC
stim_name = 'white_noise';
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, 0);
fpass = 0.1;
[SAC_kernel, ~, resp_ave, resp_sem, prediction] = SAC_white_noise_ExtractKernels(cell_name_all, fpass);
% according to bleedthrough kernel, there is one frame lag.
SAC_kernel = SAC_kernel(2:end, :);

%% 3. time traces
ax_w = 200; ax_h = 80;
plot_time_traces(resp_ave, resp_sem, prediction, left_1, top_2, ax_w, ax_h);
ax = gca; ax.XAxis.Visible='off';
plot_time_traces(resp_ave, resp_sem, prediction, left_1 + 350, top_2, ax_w, ax_h);
MySaveFig_Juyue(gcf, 'figure_2','part_1', 'nFigSave',1,'fileType',{'fig'});


MakeFigure_Paper;
%% 4. plot SAC RF.
ax_w = 90; ax_h = 50;
plot_SAC_RF(SAC_kernel, left_1, top_3, ax_w, ax_h);

%% 5. plot T4 Progressive RF.
T4T5_kernel = prepare_data_for_T4();
plot_T4_RF(T4T5_kernel, left_2, top_3, ax_w, ax_h);
MySaveFig_Juyue(gcf, 'figure_2','part_2', 'nFigSave',1,'fileType',{'fig'});

%% 6. plot matching score.
MakeFigure_Paper;
temporal_scales = sqrt(2) .^ (1:7) * 1/4; spatial_scales = sqrt(2) .^ (4:12); dx = [1/30, 16]; dy = [1/60, 5];
[scores, ~] = SAC_T4T5_RF_utils_find_maximum_match(SAC_kernel, T4T5_kernel, dx, dy, temporal_scales, spatial_scales);
ax_w = 90; ax_h = 50;
plot_matching_score(scores, temporal_scales, spatial_scales,  left_1, top_4, ax_w, ax_h);
MySaveFig_Juyue(gcf, 'figure_2','part_3', 'nFigSave',1,'fileType',{'fig'});

% %% 6. plot rescaled T4.
% [T4T5_kernel_rescaled, unit_t, unit_x] = get_recale_T4_Progressive(SAC_kernel, T4T5_kernel, dx, dy, best_scale);
% plot_T4_RF_rescaled(T4T5_kernel_rescaled, left_2, top_4, ax_w, ax_h);
figure_white_noise_visualize_matching_process(SAC_kernel, T4T5_kernel, dx, dy, [1, 13]);
MySaveFig_Juyue(gcf, 'figure_2','part_4', 'nFigSave',1,'fileType',{'fig'});

end

function plot_matching_score(scores, temporal_scales, spatial_scales, left, top, ax_w, ax_h)
    axes('Unit', 'point', 'Position', [left, top, ax_w, ax_h]);
    imagesc(scores);
    set(gca, 'XTick', 1:4:length(spatial_scales), 'XTickLabel', num2str(spatial_scales(1:4:end)'), 'YTick', 2:2:length(temporal_scales), 'YTickLabel', num2str(temporal_scales(2:2:end)'));
%     xlabel({'spatial scale:', '1 \circ in fly ~ X \mum in mice'});
%     ylabel({'temporal scale:','1 sec in fly ~  X sec in mice'});
    xlabel('spatial scale (\mum/\circ)');
    ylabel('temporal scale (s/s)');
    title('cosine similarity');
    colormap(gray);
    set(gca, 'CLim', [min(scores(:)), max(scores(:))]);
    colorbar;
    ConfAxis('fontSize', 10, 'LineWidth', 1);
    box on;
end


function plot_time_traces(resp_ave, resp_sem, prediction, left, top, ax_w, ax_h)
start_idx = 600; end_idx = 1000; trial_idx = 2;

resp_ave_plot = {resp_ave(start_idx:end_idx, trial_idx), prediction(start_idx:end_idx, trial_idx)};
resp_sem_plot = {resp_sem(start_idx:end_idx, trial_idx), zeros(end_idx- start_idx + 1, 1)};

%% plot.
axes('Unit', 'point', 'Position', [left, top, ax_w, ax_h]);
plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, {[0,0,0]; [0, 1, 0]}, 'stim_dur', 20 * 60, 'stim_onset', 0, 'plot_dash_for_stim', 0);
ylabel('\DeltaF/F', 'FontSize', 10);
set(gca, 'YLim', [-0.07, 0.07], 'XTick', [0, 10, 20], 'YTick', [-0.05, 0, 0.05], 'YTickLabelRotation', 90, 'XTick', [0,1]);
ConfAxis('fontSize', 10, 'LineWidth', 1);
end

function plot_SAC_RF(kernel, left, top, ax_w, ax_h)
axes('Unit', 'point', 'Position', [left, top, ax_w, ax_h]);
quickViewOneKernel(kernel, 1, 'barUse', [1, 8, 15]);
set(gca, 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 16, 31], 'YTickLabel', [0, 0.5, 1]);
ylabel('time (s)');
ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;
end

function plot_T4_RF(kernel, left, top, ax_w, ax_h)
axes('Unit', 'point', 'Position', [left, top, ax_w, ax_h]);
quickViewOneKernel(kernel, 1, 'labelFlag', 0); 
set(gca, 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 31, 60], 'YTickLabel', [0, 0.5, 1], 'XTick', [1, 5, 9], 'XTickLabel', {'-20', '0', '20'}, 'FontSize', 10);
xlabel('bar position (\circ)');
ylabel('time (s)');
ConfAxis('fontSize', 10, 'LineWidth', 1);
box on;
% set(gca, 'XTick', [1,7,15], 'YTickLabelRotation', 90, 'XTickLabelRotation', 90, 'YTick', [1, 31, 60], 'YTickLabel', [0, 0.5, 1]);

end


function first_order_kernel_T4_progressive = prepare_data_for_T4()
S = GetSystemConfiguration;
t4t5_kernel = load(fullfile(S.cached_T4T5_data_path, 'T4T5_white_noise.mat'));

%% average sac kernel together.
first_order_kernel_T4_progressive = squeeze(mean(t4t5_kernel.meanKernel{1}, 3));
first_order_kernel_T4_progressive = fliplr(first_order_kernel_T4_progressive); % left eye --> right eye.

%% get the center of it. not all of it.
first_order_kernel_T4_progressive = first_order_kernel_T4_progressive(:, 6:14);
end
