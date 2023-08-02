function resp = SAC_GetResponse_OneFile(cell_name, suffix, is_bckg)
% dfoverf_method = 'last_frame';
S = GetSystemConfiguration;    
respfolder = fullfile(S.sac_data_path, cell_name, 'saved_analysis',['resp_',suffix,'.mat']);
load(respfolder)
if is_bckg
    resp = preprocess.resp_bckg;
else
    resp = preprocess.resp;
end
end
