%% find your old code, copy and paste.
function xt = load_sinewave_stimulus(dir, tf, sw)
tol = 1e-3;
% load stimulus parameters and plot from there.
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'sinewave_sweep_dense.mat');
data = load(stimulus_parameters_file);


%% instead of loading the true stimulus, generate your own stimulus here so that the initial phases are the same.
stimulus_parameters = data.stimulus_parameters;
epoch_index = stimulus_parameters.direction == dir & ...
    abs(stimulus_parameters.temporal_frequency - tf) < tol & ...
    stimulus_parameters.spatial_wavelength == sw;

xt = make_sinewave(stimulus_parameters.temporal_frequency(epoch_index),...
    stimulus_parameters.spatial_wavelength(epoch_index), ...
    stimulus_parameters.contrast(epoch_index), ...
    stimulus_parameters.direction(epoch_index),...
    stimulus_parameters.phaseVals(epoch_index),...
    stimulus_parameters.spatial_range(epoch_index), ...
    stimulus_parameters.temporal_duration(epoch_index),...
    stimulus_parameters.fps(epoch_index), ...
    stimulus_parameters.pixel_size(epoch_index));

end