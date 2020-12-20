function  resp_shifted = T4T5_LD_Utils_ShiftResp(resp, second_bar_onset, stim_onset, f_resp)
[start_idx, left_idx] = T4T5_LD_Utils_ShiftResp_Utils_GetIdx(second_bar_onset, stim_onset, f_resp);
n_cell = length(resp);
if (iscell(resp))
    resp_shifted = cell(n_cell, 1);
    for cc = 1:1:n_cell
        resp_shifted{cc} = zeros(size(resp{cc}));
        resp_shifted{cc}(start_idx:end, :, :, :) = resp{cc}(left_idx: end - (start_idx - left_idx), :, :, :);
    end
else
    resp_shifted = zeros(size(resp));
    resp_shifted(start_idx:end, :, :) = resp(left_idx:end - (start_idx - left_idx), :, :);
end