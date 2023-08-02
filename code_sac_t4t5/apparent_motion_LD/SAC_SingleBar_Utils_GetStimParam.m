function [stim_info, data_info] = SAC_SingleBar_Utils_GetStimParam()
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'apparent_motion.mat'); 
load(stimulus_parameters_file);

%%
n_bar_cont = 2;
n_phase = length(unique(stimulus_parameters.bar1_pos(stimulus_parameters.single_bar == 1)));
bar_cont = [1,-1];
phase = [1:n_phase]; % position

%%
epoch_index = zeros(n_bar_cont,n_phase);
for cc = 1:1:n_bar_cont
    for ll = 1:1:n_phase
        epoch_index(cc,ll) = find(stimulus_parameters.single_bar == 1 & ...
                                  stimulus_parameters.lead_polarity == bar_cont(cc) & ...
                                  (mod(stimulus_parameters.bar1_pos - 1, n_phase) + 1) == phase(ll));
    end
end

%%
param.barCont = bar_cont;
param.phase = phase;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'bar_cont','phase'};
data_info.stim_param = param;

stim_info.epoch_cont = cont; %% Original cont corresponding to param_vec

end