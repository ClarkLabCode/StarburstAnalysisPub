function resp_over_time = SAC_AppMot_Plot_Utils_BarPlot_GerAverageResponse_OverTime(resp, recording_info)
stim_onset = recording_info.stim_onset;
dur_second = recording_info.stim_dur_sec;
f_resp = recording_info.f_resp;
on_set = ceil(f_resp * (stim_onset));
off_set = floor(f_resp * dur_second + on_set);
resp_over_time = SAC_AverageResponseOverTime(resp, on_set, off_set);
end