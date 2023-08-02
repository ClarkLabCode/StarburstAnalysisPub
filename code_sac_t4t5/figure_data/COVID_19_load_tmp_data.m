function resp = COVID_19_load_tmp_data(stim_name, cell_name, dataset_name)
S = GetSystemConfiguration
if strcmp(cell_name, 'SAC')
    data_tmp_folder = fullfile(S.sac_data_path, [stim_name, '_', cell_name, '.mat']);
else
    data_tmp_folder = fullfile(S.sac_data_path, [stim_name, '_', dataset_name, '_', cell_name, '.mat']);
end
data = load(data_tmp_folder); % you are using T5 data
resp = data.resp;
end
