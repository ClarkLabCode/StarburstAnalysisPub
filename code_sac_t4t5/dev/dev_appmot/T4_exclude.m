%% exclude T4 data by constraining its response to dark bars.
function T4_exclude()

% plotting
colors_pref_null = {[89,23,31]/100; [23,31,89]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % colors = {[88,35,41]/255; [23, 59, 68]/255};
lefts = [36, 36 + 200, 36 + 400];  top_1 = 620; top_2 = 360; % plot four static ring.
ax_w = 120; ax_h = 80;

% get data. T4 Progressive, next_neighbor.
% stim_name = 'apparent_motion';
% dataset_name = 'next_neighbor';
% recording_info_T4T5 = get_t4t5_recording_info_apparent_motion();
% resp_T4T5 = COVID_19_load_tmp_data(stim_name, 'T4_Pro','next_neighbor');
% epoch_ID_T4T5 = (1:112)';
% [~, data_info_single_T4T5] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
% [resp_single_T4T5, ~, data_info_single_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_single_T4T5, epoch_ID_T4T5);
% [~, data_info_am_T4T5] = T4T5_AppMot_Utils_GetStimParam('next_neighbor');
% [resp_am_T4T5, ~, data_info_am_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_am_T4T5, epoch_ID_T4T5);

%%
stim_name = 'apparent_motion';
dataset_name = 'neighbor';
recording_info_T4T5 = get_t4t5_recording_info_apparent_motion();
resp_T4T5 = COVID_19_load_tmp_data(stim_name, 'T4_Reg',dataset_name);
epoch_ID_T4T5 = (1:144)';
[~, data_info_single_T4T5] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
[resp_single_T4T5, ~, data_info_single_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_single_T4T5, epoch_ID_T4T5);
[~, data_info_am_T4T5] = T4T5_AppMot_Utils_GetStimParam(dataset_name);
[resp_am_T4T5, ~, data_info_am_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_am_T4T5, epoch_ID_T4T5);

%% light response, dark response at phase 4 or 5?
threshs = [3, 5];

resp_single_plot = cell(3, 1);
resp_am_plot = cell(3, 1);
for ee = 1:1:2
    roi_selection_mask = select_rois_based_on_light_dark_ratio(resp_single_T4T5, 5, recording_info_T4T5, data_info_single_T4T5, threshs(ee));
    resp_single_plot{ee + 1} = select_rois(resp_single_T4T5, roi_selection_mask);
    resp_am_plot{ee + 1} = select_rois(resp_am_T4T5, roi_selection_mask);
end
resp_single_plot{1} = resp_single_T4T5;
resp_am_plot{1} = resp_am_T4T5;
% first column. orginal. top single bar. bottom apparent motion. second column thresh 2. third column thresh 5.
title_str = {'only ESI', ['light/dark > ', num2str(threshs(1))], ['light/dark > ', num2str(threshs(2))]};

MakeFigure_Paper;
for ee = 1:1:3
    bar_plot(resp_single_plot{ee}, data_info_single_T4T5, recording_info_T4T5, 0.7, 0, lefts(ee), top_1, ax_w, ax_h);
%     set(gca, 'XTick', [3, 4, 5, 6, 7, 8], 'XTickLabel', [-1, 0, 1, 2, 3, 4]); % positions 4 is the center!
    xlabel('left bar position', 'FontSize', 10);
    title(title_str{ee});
    
%     figure_apparent_motion_bar_plot(resp_am_plot{ee}, colors_pref_null, data_info_am_T4T5, recording_info_T4T5, 0, 1, lefts(ee), top_2, ax_w, ax_h);
%     xlabel('left bar position', 'FontSize', 10);
% %     set(gca, 'XTick', [3, 4, 5, 6, 7], 'XTickLabel', [-1, 0, 1, 2, 3]);
end

MySaveFig_Juyue(gcf, 'select_rois_based_on_single_bar_response', '', 'nFigSave',1,'fileType',{'pdf'});
end


function resp_selected = select_rois(resp, selection_mask)
n_f = length(resp);
cnt = 1;
resp_selected = cell(n_f, 1);
for ff = 1:1:n_f
    if sum(selection_mask{ff}) > 0
        resp_selected{cnt} = resp{ff}(:,:,:,selection_mask{ff});
        cnt = cnt + 1;
    end
end
resp_selected = resp_selected(1:cnt-1);
end

function roi_selection_mask = select_rois_based_on_light_dark_ratio(resp, by_phase_ll, recording_info, data_info, thresh)

stim_onset = recording_info.stim_onset;
second_bar_onset = recording_info.second_bar_onset;
dur_second = 1 - second_bar_onset;

% averaged over time.
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * stim_onset);
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%%
epoch_index = data_info.epoch_index;
n_lag = size(data_info.epoch_index, 2);

%%
ratio = cellfun(@(x) get_light_dark_ratio(x, epoch_index), resp_over_time,  'UniformOutput', false);

n_roi = cellfun(@(x) size(x, 4), resp,  'UniformOutput', false); n_roi = cat(1, n_roi{:}); n_roi = sum(n_roi);
ratio_over_phase_mean = zeros(n_lag, 1);
ratio_over_phase_std = zeros(n_lag, 1);
ratio_mat = zeros(n_roi, n_lag);
for ll = 1:1:n_lag
    tmp = cellfun(@(x) x(ll,:), ratio, 'UniformOutput', false);
    tmp = cat(2, tmp{:});
    ratio_mat(:, ll) = tmp;
    ratio_over_phase_mean(ll) = mean(tmp);
    ratio_over_phase_std(ll) = std(tmp, 1)/sqrt(n_roi);
end

% MakeFigure;subplot(2,2,1);
% %% ratio accross all bars
% bar_scatter_plot_Juyue(ratio_over_phase_mean, ratio_over_phase_std, ratio_mat,  repmat([0,0,0], [n_lag, 1]),...,
%     'link_dots_flag', 0, 'xaxis', [1:8]', 'bar_width', 0.3,...
%     'plot_individual_dot', 0, 'line_width', 1, 'face_alpha', 1,'do_sig_test_flag', 1, 'plot_max_value', 1 + 0.1);
% set(gca,'XTick', [1:8]); xlabel('bar position'); ylabel('light/dark ratio'); title('averaged ratio');

%% select based on ratio. The ratio has to be larger than 10.
roi_selection_mask = cellfun(@(x) x(by_phase_ll, :) > thresh, ratio, 'UniformOutput', false);
end

function ratio = get_light_dark_ratio(x, epoch_index)
n = size(epoch_index, 2);
positive = reshape(squeeze(x(1, 1, epoch_index(1,:), :)),[n, size(x, 4)]);
negative = reshape(squeeze(x(1, 1, epoch_index(2,:), :)),[n, size(x, 4)]);

ratio = positive./negative;
end
function bar_plot(resp, data_info, recording_info, plot_max_value, plot_center_phase_flag, left, top, ax_w, ax_h)
positions = {[left, top, ax_w, ax_h],;
    [left, top - (ax_h +20), ax_w, ax_h]};


%%
stim_onset = recording_info.stim_onset;
second_bar_onset = recording_info.second_bar_onset;
dur_second = 1 - second_bar_onset;

% averaged over time.
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * stim_onset);
off_set = floor(f_resp * dur_second + on_set);
[resp_over_time] = SAC_AverageResponseOverTime(resp, on_set, off_set);

%
epoch_index = data_info.epoch_index;
n_lag = size(data_info.epoch_index, 2);

% organize the response, ave, sem, and individual?
bar_width = 0.3;

xaxis_this = [1:n_lag];
x_lim_plot = [0.5, n_lag + 0.5];

ee = 1;
for cc_lead = 1:1:2
    
    axes('Unit', 'point', 'Position', positions{ee});
    epoch_this = epoch_index(cc_lead, :);
    color_this = repmat([0,0,0], [n_lag, 1]);
    resp_one_polarity = cellfun(@(x) reshape(squeeze(x(epoch_this)), [length(epoch_this), 1]), resp_over_time, 'UniformOutput', false);
    
    % get the bar plot. individual
    resp_ind_cell_mat = cat(2, resp_one_polarity{:})';
    resp_ave_over_cell = mean(resp_ind_cell_mat, 1);
    resp_std_over_cell = std(resp_ind_cell_mat, 1, 1);
    resp_sem_over_cell = resp_std_over_cell./sqrt(length(resp_one_polarity ));
    
    % first, plot without individual.
    bar_scatter_plot_Juyue(resp_ave_over_cell, resp_sem_over_cell, resp_ind_cell_mat,  color_this,...,
        'link_dots_flag', 0, 'xaxis', xaxis_this, 'bar_width', bar_width,...
        'plot_individual_dot', 0, 'line_width', 1, 'face_alpha', 1,'do_sig_test_flag', 1, 'plot_max_value', plot_max_value + 0.1);
    SAC_Plot_Utils_BarPlot_Setup_Axis(x_lim_plot, [-0.2, 1] * (plot_max_value + 0.1), xaxis_this, 0)
    set(gca, 'YTick', [0, 0.5, 1]);
    if plot_center_phase_flag
        set(gca, 'XLim', [2.5, 8.5]);
    end
    ee = ee + 1;
    
end
ax_tmp = gca;
ax_tmp.XAxis.Visible = 'on';
set(gca, 'XTick', [1:n_lag], 'XTickLabel', [0:n_lag - 1]);

end