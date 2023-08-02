function tx = load_apparent_motion_stim(dir, lead_polarity, lag_polarity, phase)

% load stimulus parameters and plot from there.
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'apparent_motion.mat');
data = load(stimulus_parameters_file);

stimulus_parameters = data.stimulus_parameters;
n_phase = length(unique(stimulus_parameters.bar1_pos(stimulus_parameters.apparent_bars == 1)));

epoch_index = stimulus_parameters.apparent_bars == 1 & ...
    stimulus_parameters.direction == dir & ...
    stimulus_parameters.lag_polarity == lag_polarity & ...
    stimulus_parameters.lead_polarity == lead_polarity & ...
    (mod(stimulus_parameters.bar1_pos - 1, n_phase) + 1) == phase;
tx = squeeze(data.cont(:, :, epoch_index));

end