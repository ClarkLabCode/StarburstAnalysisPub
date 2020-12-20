function [stim_info, data_info] = T4T5_AppMot_Utils_GetStimParam(dataset_name)
sysConfig = GetSystemConfiguration;
if strcmp(dataset_name, 'next_neighbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNextNeighRespStructs_stiminfo.mat');
elseif strcmp(dataset_name,'neighbor')
    datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_ApparentMotion_barPairWithNeighRespStructs_stiminfo.mat');
end
data = load(datapath);
p = T4T5_DataTransfer_EmilioToJuyue_Stim_AppMot(data.matDescription);

%%
n_lead_cont = 2;
n_lag_cont = 2;
n_dir = 2;
n_phase = 8;

leadCont = [1,-1];
lagCont  = [1,-1];
dirVal = [1,-1]; % Progressive direction...
phase = [1:8]; % position. first, 8.

%%
epoch_index = zeros(n_lead_cont, n_lag_cont, n_dir, n_phase);
for cc_lead = 1:1:n_lead_cont
    for cc_lag = 1:1:n_lag_cont
        for dd = 1:1:n_dir
            for ll = 1:1:n_phase
                epoch_index(cc_lead, cc_lag, dd, ll) = find(p.lagCont == lagCont(cc_lag) & p.leadCont == leadCont(cc_lead) ...
                    & p.dirVal == dirVal(dd) & (mod(p.phase - 2, 8) + 1) == phase(ll));
            end
        end
    end
end

%%
param.leadCont = leadCont;
param.lagCont = lagCont;
param.dirVal = dirVal;
param.phase = phase;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'leadCont','lagCont','dirVal','phase'};
data_info.stim_param = param;

stim_info.epoch_cont = p.cont; %% Original cont corresponding to param_vec
end
