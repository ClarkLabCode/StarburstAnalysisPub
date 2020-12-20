function resp_reorganize = T4T5_AppMot_GetResponse_OneCellType(cell_type, dataset_name)
sysConfig = GetSystemConfiguration;
if strcmp(dataset_name, 'next_neighbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNextNeighRespStructs.mat');
elseif strcmp(dataset_name,'neighbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNeighRespStructs.mat');
end

data = load(datapath);
resp = data.barPairIndAnalyses.analysis{cell_type};

%% rearrange the response...
n_fly = length(resp.indFly);

resp_reorganize = cell(n_fly, 1);
num_of_rois = resp.numROIs;
num_of_rois_cum = cumsum(num_of_rois);
idx_l = [1, num_of_rois_cum(1:n_fly - 1) + 1];
idx_r = idx_l + num_of_rois - 1;

for ff = 1:1:n_fly
    resp_this_fly = resp.roiResps(:, :, idx_l(ff):idx_r(ff));
    resp_this_fly = permute(resp_this_fly, [2, 1, 3]);
    %% if possible, get the individual trials...
    resp_reorganize{ff} = reshape(resp_this_fly, [size(resp_this_fly, 1), 1, size(resp_this_fly, 2),size(resp_this_fly, 3)]);
end

end