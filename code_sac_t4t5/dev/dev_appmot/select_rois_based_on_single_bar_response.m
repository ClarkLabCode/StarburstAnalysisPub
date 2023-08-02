function resp_selected = select_rois_based_on_single_bar_response(resp_single, resp, recording_info, data_info, thresh, rf_center)
roi_selection_mask = select_rois_based_on_light_dark_ratio(resp_single, rf_center, recording_info, data_info, thresh);
resp_selected = select_rois(resp, roi_selection_mask);
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
roi_selection_mask = cellfun(@(x) x(by_phase_ll, :) > thresh, ratio, 'UniformOutput', false);
end

function ratio = get_light_dark_ratio(x, epoch_index)
n = size(epoch_index, 2);
positive = reshape(squeeze(x(1, 1, epoch_index(1,:), :)),[n, size(x, 4)]);
negative = reshape(squeeze(x(1, 1, epoch_index(2,:), :)),[n, size(x, 4)]);

ratio = positive./negative;
end