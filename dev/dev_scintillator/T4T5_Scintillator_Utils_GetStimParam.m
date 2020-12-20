function [stim_info, data_info] = T4T5_TwoSimultaneousBar_Utils_GetStimParam(cell_type, dataset_name)
sysConfig = GetSystemConfiguration;
if strcmp(dataset_name, 'next_neighbor')
    error('does not have the data!');
elseif strcmp(dataset_name,'neigbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNeighRespStructs_stiminfo.mat');
end
data = load(datapath); % 
p = T4T5_DataTransfer_EmilioToJuyue_Stim_TwoSimultaneousBar(data.matDescription,  cell_type);

%%
n_bar_cont = 2;
n_phase = 8;

bar_1_cont = [1, -1];
bar_2_cont = [1, -1];
phase = [1:8];


%%
epoch_index = zeros(n_bar_cont, n_bar_cont, n_phase);
for b1 = 1:1:n_bar_cont
    for b2 = 1:1:n_bar_cont
        for ll = 1:1:n_phase
            epoch_index(b1, b2, ll) = find(p.bar_1_cont == bar_1_cont(b1) & p.bar_2_cont == bar_2_cont(b2) & (mod(p.phase - 1, 8) + 1) == phase(ll));
        end
    end
end
%%
param.bar_1_cont = bar_1_cont;
param.bar_2_cont = bar_2_cont;
param.phase = phase;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'bar_1_cont','bar_2_cont', 'phase'};
data_info.stim_param = param;

stim_info.epoch_cont = p.cont; %% Original cont corresponding to param_vec

end
