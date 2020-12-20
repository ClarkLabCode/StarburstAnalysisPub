function [stim_info, data_info] = SAC_Edges_Utils_GetStimParam(stim_name)
%% load the stimulus.

S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, [stim_name, '.mat']);
load(stimulus_parameters_file);


%%
param.direction = [1, -1]; n_d = 2;
param.polarity = [1, -1]; n_p = 2;
param.velocity = unique(stimulus_parameters.velocity);n_v = length(param.velocity);

epoch_index = zeros(n_d, n_p, n_v);
for dd = 1:1:n_d
    for pp = 1:1:n_p
        for vv = 1:1:n_v
            epoch_index(dd, pp, vv) = find(stimulus_parameters.direction == param.direction(dd) & ...
                stimulus_parameters.contrast == param.polarity(pp) & ...
                stimulus_parameters.velocity == param.velocity(vv));
        end
    end
end

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'direction','polarity','velocity'};
data_info.param = param;
data_info.stim_param = param;

% stim_info.epoch_cont = p.cont; %% Original cont corresponding to param_vec
stim_info.epoch_cont = cont; %% This is after organization.
stim_info.param_name = data_info.param_name;
stim_info.param = param;
stim_info.stimulus_parameters = stimulus_parameters;

end
