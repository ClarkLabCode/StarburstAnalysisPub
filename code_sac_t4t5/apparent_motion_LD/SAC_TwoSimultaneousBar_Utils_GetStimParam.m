function [stim_info, data_info] = SAC_TwoSimultaneousBar_Utils_GetStimParam()
%% load the stimulus. 
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'apparent_motion.mat'); 
load(stimulus_parameters_file);

%%
n_bar_cont = 2;
n_phase = length(unique(stimulus_parameters.bar1_pos(stimulus_parameters.simultaneous_bars == 1)));

bar_1_cont = [1, -1];
bar_2_cont = [1, -1];
phase = [1:n_phase]';


%%
epoch_index = zeros(n_bar_cont, n_bar_cont, n_phase);
for b1 = 1:1:n_bar_cont
    for b2 = 1:1:n_bar_cont
        for ll = 1:1:n_phase
            epoch_index(b1, b2, ll) = find(stimulus_parameters.simultaneous_bars == 1 & ...
                                           stimulus_parameters.lead_polarity == bar_1_cont(b1) & ...
                                           stimulus_parameters.lag_polarity == bar_2_cont(b2) & ...
                                           (mod(stimulus_parameters.bar1_pos - 1, n_phase) + 1) == phase(ll));
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

stim_info.epoch_cont = cont; %% Original cont corresponding to param_vec

end
