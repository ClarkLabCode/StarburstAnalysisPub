function [stim_info, data_info] = SAC_SineWave_Sweep_Utils_GetStimParam(stim_name)
S = GetSystemConfiguration;

%% load the stimulus. 
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, [stim_name, '.mat']); 
load(stimulus_parameters_file);


%% 
param.fVals = unique(stimulus_parameters.temporal_frequency); n_f = length(param.fVals);
param.kVals = 1./unique(stimulus_parameters.spatial_wavelength);n_k = length(param.kVals);
param.dirVal = unique(stimulus_parameters.direction);n_d = length(param.dirVal);

param_vec.kVals = stimulus_parameters.spatial_wavelength;
param_vec.fVals = stimulus_parameters.temporal_frequency;
param_vec.dirVal = stimulus_parameters.direction;

data_info.epoch_index = reshape(stimulus_parameters.epoch_number, [n_f, n_k, n_d]); %% organize them together
data_info.param_name = {'t_f','x_f','dirVal'};
data_info.stim_param = param;

%
% stim_info.epoch_cont = p.cont; %% Original cont corresponding to param_vec
stim_info.cont = cont; %% This is after organization.
stim_info.param_name = {'t_f','x_f','dirVal'};
stim_info.param = param;
stim_info.param_vec = param_vec;
stim_info.f_stim = stimulus_parameters.fps(1); %% Is this true for this stimulus?
stim_info.stim_dur = stimulus_parameters.temporal_duration(1) * stim_info.f_stim;
stim_info.stimulus_parameters = stimulus_parameters;

end
