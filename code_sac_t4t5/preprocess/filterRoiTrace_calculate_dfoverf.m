function dfoverf = filterRoiTrace_calculate_dfoverf(method, resp, fpass, fs)
PARAM_PERC = 0.1;
PARAM_LASTFRAME = 4;
PARAM_ONSETFRAME = 10;
PARAM_ONSET_TIME = 15;

if strcmp(method, 'last_frame')
    f0 = mean(resp(end-(PARAM_LASTFRAME - 1):end,:,:,:), 1);
    dfoverf = (resp - f0)./f0;
    
    
elseif strcmp(method, 'low_10')
    sorted_resp = sort(resp, 1);
    n = ceil(size(resp, 1) * PARAM_PERC);
    f0 = mean(sorted_resp(1:n,:,:,:),1);
    dfoverf = (resp - f0)./f0;
    
    
elseif strcmp(method, 'stim_onset')
    f0 = mean(resp(PARAM_ONSET_TIME-(PARAM_ONSETFRAME - 1):PARAM_ONSET_TIME,:,:,:), 1);
    dfoverf = (resp - f0)./f0;
    
    
elseif strcmp(method, 'lowhighpass')
    [df_tmp, ~] = filterRoiTraces_Utils_HighLowPassAndNormalize(permute(squeeze(resp), [1, 3, 2]), fpass,fs);
    dfoverf(:, 1, :, :) = permute(df_tmp, [1, 3, 2]);
    %
end
end