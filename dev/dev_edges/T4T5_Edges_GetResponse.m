function resp = T4T5_Edges_GetResponse(cell_type, preselected_fly, preselected_roi)

S = GetSystemConfiguration;
T4T5_datapath = fullfile(S.cached_T4T5_data_path, 'T4T5_edges_response.mat');

data = load(T4T5_datapath);
response = get_response(data.data, cell_type);
resp = get_one_fly_one_roi(response, preselected_fly, preselected_roi);
resp = squeeze(mean(resp, 2)); % average over three trials.

end

function response = get_response(data, cell_type)

n_flies = size(data, 2) - 1;
n_trial = 3;
n_epoch = 4;

% collect all cell type, for this fly.
response = cell(n_trial, n_epoch, n_flies);
ff_used = 1;
for ff = 1:1:n_flies
    idx = ff + 1;
    if size(data{cell_type + 1, idx}, 2) >= 1
        for ee = 1:1:n_epoch
            stim = data{1, idx};
            stim_used = decode_epoch_idx_into_trials(find(stim == ee));
            for tt = 1:1:n_trial
                response{tt, ee, ff_used} = data{2, idx}(stim_used{tt}, :);
            end
        end
        ff_used = ff_used + 1;
    end
end
n_flies_used = ff_used;
response = response(:, :, 1:n_flies_used);
end

function stim_each_trial = decode_epoch_idx_into_trials(stim)
tmp = diff(stim);
tmp = find(tmp > 10); %
stim_trial_1 = stim(1: tmp(1));
stim_trial_2 = stim(tmp(1) + 1:tmp(2));
stim_trial_3 = stim(tmp(2) + 1:end);

stim_each_trial = {stim_trial_1, stim_trial_2, stim_trial_3};
end



function resp = get_one_fly_one_roi(response, ff, rr)
T = 156;
% edge_code = {'right light edges', 'right dark edges', 'left light edges', 'left dark edges'}
resp = zeros(T, 3, 2, 2); % 12 second. all three trials.
for dd = 1:1:2
    for pp = 1:1:2
        for tt = 1:1:3
            resp(:, tt, dd, pp) = response{tt, (dd-1) * 2 + pp, ff}(1:T, rr);
        end
    end
end
end