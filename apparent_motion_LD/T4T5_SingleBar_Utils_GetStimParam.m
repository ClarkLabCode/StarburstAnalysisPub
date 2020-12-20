function [stim_info, data_info] = T4T5_SingleBar_Utils_GetStimParam(dataset_name)
sysConfig = GetSystemConfiguration;
if strcmp(dataset_name, 'next_neighbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNextNeighRespStructs_stiminfo.mat');
elseif strcmp(dataset_name,'neighbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNeighRespStructs_stiminfo.mat');
end
data = load(datapath);
p = T4T5_DataTransfer_EmilioToJuyue_Stim_SingleBar(data.matDescription, dataset_name);

%%
n_bar_cont = 2;
n_phase = 8;

bar_cont = [1,-1];
phase = [1:8]; % position. first, 8. %

%%
epoch_index = zeros(n_bar_cont,n_phase);
for cc = 1:1:n_bar_cont
    for ll = 1:1:n_phase
        epoch_index(cc,ll) = find(p.barCont == bar_cont(cc) & (mod(p.phase - 2, 8) + 1) == phase(ll));
    end
end

%%
param.barCont = bar_cont;
param.phase = phase;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'bar_cont','phase'};
data_info.stim_param = param;

stim_info.epoch_cont = p.cont; %% Original cont corresponding to param_vec

end
