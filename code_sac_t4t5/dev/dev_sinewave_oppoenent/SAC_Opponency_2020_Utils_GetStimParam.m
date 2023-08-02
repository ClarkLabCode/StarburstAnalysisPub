function [stim_info, data_info] = SAC_Opponency_2020_Utils_GetStimParam()
%% load the stimulus.
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'sinewave_opponent.mat');
load(stimulus_parameters_file);

%%
n_phase = 8;
n_dir = 3; %% left, right, opponency.
dirVals = [1, -1, 0]; % preferred. null.
phaseVals = [0:n_phase]/n_phase;

epoch_index = zeros(n_phase,n_dir);
for dd = 1:1:n_dir
    for pp = 1:1:n_phase 
        epoch_index(pp, dd) = find(stimulus_parameters.direction == dirVals(dd) & ...
                stimulus_parameters.phaseVals == phaseVals(pp));
    end
end

%% offset of phase.. how to tell?
param.phasevals = unique(stimulus_parameters.phaseVals);
param.direction = unique(stimulus_parameters.direction);
param.temporal_frequency = unique(stimulus_parameters.temporal_frequency);
param.spatial_wavelength = unique(stimulus_parameters.spatial_wavelength);

param_vec.phases = stimulus_parameters.phaseVals;
param_vec.direction= stimulus_parameters.direction;
param_vec.temporal_frequency = stimulus_parameters.temporal_frequency;
param_vec.spatial_wavelength = stimulus_parameters.spatial_wavelength;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'phase','dir'};
data_info.stim_param = param;

%
stim_info.param_name = {'phase','dir'};
stim_info.param = param;
stim_info.param_vec = param_vec;


stim_info.SPLT = stimulus_parameters.SPLT(1);
stim_info.fps = stimulus_parameters.fps(1); 
end
