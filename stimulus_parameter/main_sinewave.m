function main_sinewave(sinewave_parameter_file, xt_filename)
%% load the parameter files
num = xlsread(sinewave_parameter_file);

epoch_number = num(1,:);
temporal_frequency = num(2,:);
spatial_wavelength = num(3,:);
direction = num(4,:);
contrast = num(5,:);
phaseVals = num(6,:);
spatial_range = num(7,:);
temporal_duration = num(8,:);
pixel_size = num(9,:);
fps = num(10,:);
SPLT = num(11, :);
SPPS = num(12, :);

%% generate all stimulus
N = length(epoch_number);
xt_plot = cell(N, 1);
for ee = epoch_number
    xt_plot{ee} = make_sinewave(temporal_frequency(ee), spatial_wavelength(ee), ...
        contrast(ee), direction(ee), phaseVals(ee),...
        spatial_range(ee), temporal_duration(ee),...
        fps(ee), pixel_size(ee));
end

cont = cat(3, xt_plot{:});

%% save it
stimulus_parameters.epoch_number = epoch_number;
stimulus_parameters.temporal_frequency = temporal_frequency;
stimulus_parameters.spatial_wavelength = spatial_wavelength;
stimulus_parameters.direction = direction;
stimulus_parameters.contrast = contrast;
stimulus_parameters.phaseVals = phaseVals;
stimulus_parameters.spatial_range = spatial_range;
stimulus_parameters.temporal_duration = temporal_duration;
stimulus_parameters.pixel_size = pixel_size;
stimulus_parameters.fps = fps;
stimulus_parameters.SPLT = SPLT;
stimulus_parameters.SPPS = SPPS;
save(xt_filename, 'stimulus_parameters', 'cont');

%% plot it
MakeFigure;
if N == 20
    for ee = epoch_number
        subplot(4, 5, ee);
        imagesc(squeeze(cont(:, :, ee))); colormap(gray);
    end
else
    for ee = epoch_number
        subplot(8, 8, ee);
        imagesc(squeeze(cont(:, :, ee))); colormap(gray);
    end
end

%% plot the stimulus
MakeFigure;
for ee = 5:1:8
subplot(1, 8, ee - 4);
imagesc(squeeze(cont(:, :, 1 + (ee - 1) * 8))); colormap(gray);
set(gca, 'XTick', [], 'YTick', []); 
end
for ee = 1:1:4
subplot(1, 8, 9 - ee);
imagesc(squeeze(cont(:, :, 1 + (ee - 1) * 8))); colormap(gray);
set(gca, 'XTick', [], 'YTick', []); 
end
end

