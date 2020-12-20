function response = T4T5_Sinewave_GetResponse(cell_type)

S = GetSystemConfiguration;
T4T5_datapath = fullfile(S.cached_T4T5_data_path, 'T4T5_sinewave_sweep_dense.mat');

data = load(T4T5_datapath);
[response, spatial_frequency, temporal_frequency] = get_response(data.imagingIn, cell_type);

end

function [response, spatial_frequency, temporal_frequency] = get_response(data, cell_type)

if cell_type == 1
    data = data.T4GCaMPPro;
elseif cell_type == 2
    data = data.T4GCaMPReg;
elseif cell_type == 3
    data = data.T5GCaMPPro;
else
    data = data.T5GCaMPReg;
end

spatial_frequency = data.lambda;
temporal_frequency = data.tf(1:13);
response = squeeze(fliplr(data.powerMap(1:13, :, :)));
end