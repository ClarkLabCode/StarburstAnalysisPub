function recording_info = get_sac_recording_information(stim_name)
recording_info.f_resp = 15.6250;
recording_info.stim_onset = 1;
if strcmp(stim_name,  'apparent_motion')
    recording_info.stim_dur_sec = 1;
    recording_info.second_bar_onset = 0.25;
else
    recording_info.stim_dur_sec = 5;
end
end