function [resp, resptime_perroi, stimtime, stimseq, roi_mask] = SAC_ReadImageData_Utils_GetRespStimStimind(cell_name, fpass)

S = GetSystemConfiguration;


% first, get the stimulus seq and timing, as well as resptime.
%% load preprocessed data.
respfolder = fullfile(S.sac_data_path, cell_name);

suffix = ['lowhighpass', '_bckg_sub_','fpass', num2str(fpass * 100)];
data = load(fullfile(respfolder, 'saved_analysis',['resp_',suffix,'.mat']));
resp = permute(squeeze(data.preprocess.resp), [1, 3, 2]); % permute to change [time, trial, epoch, roi] --> [time, nepoch, roi]
roi_mask = data.preprocess.roi_mask;

%% load stimulus information
stimtime_file = fullfile(respfolder, [cell_name,'.mat']);
stimseq = SAC_Load_StimSeq(stimtime_file);
stimtime = SAC_Load_Stimtime(stimtime_file);
resptime = SAC_Load_RespTime();
roi_center = SAC_utils_cal_roi_center(roi_mask);

%% get the stimulus sequence, and th
nlines = 128;
resptime_perline = SAC_Timealign_frame2lin(resptime(:, 1), nlines);
resptime_perroi = resptime_perline(:, floor(roi_center(:, 1)));

end