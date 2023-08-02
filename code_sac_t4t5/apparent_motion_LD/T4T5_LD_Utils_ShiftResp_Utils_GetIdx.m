function  [start_idx, left_idx] = T4T5_LD_Utils_ShiftResp_Utils_GetIdx(second_bar_onset, stim_onset, f_resp)
% the starting index for the resp_shifted. %
left_idx = floor(stim_onset * f_resp);
start_idx = left_idx + round(second_bar_onset * f_resp);
