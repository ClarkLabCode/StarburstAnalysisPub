function tx = load_scintillator_stimulus(polarity, dir, is_demo)
% load stimulus parameters and plot from there.
temporal_offset = 1;
S = GetSystemConfiguration;

stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'scintillator.mat');
data = load(stimulus_parameters_file);
stimulus_parameters = data.stimulus_parameters;

% find the relevant stimulus.
epoch_index = stimulus_parameters.polarity == polarity & ...
    stimulus_parameters.spatial_offset == -dir & ...
    stimulus_parameters.temporal_offset == temporal_offset;

tx = squeeze(data.cont(:,:, epoch_index));

% if want longder stimulus to have a cleaner cross-correlagram, generate a
% long stimulus here.
if is_demo
    tx = make_scintillator(temporal_offset, -dir, polarity, 50, 100, 60, 3);
end

end

