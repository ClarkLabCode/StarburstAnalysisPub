function main_opponent_sinewave(parameter_file, xt_filename)

num = xlsread(parameter_file);

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
    xt_plot{ee} = make_opponent_sinewave(temporal_frequency(ee), spatial_wavelength(ee), ...
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
for ee = epoch_number
       
    subplot(3, 8, ee);
    imagesc(squeeze(cont(:, :, ee))); colormap(gray); set(gca, 'Clim', [-1, 1]);
    set(gca, 'XTick', [], 'YTick', []);
%     colorbar;
end


end


function cont = make_opponent_sinewave(temporal_frequency, spatial_wavelength, contrast, direction, phaseVals, spatial_range, temporal_duration, fps, pixel_size)
T = temporal_duration * fps; % time steps;
X = spatial_range/pixel_size;
k = 1/(spatial_wavelength/pixel_size);
f = temporal_frequency / fps;

ti = (0:(T-1))';
xi = 0:(X-1);
if direction == 0
    cont_right = contrast*sin(f*ti*2*pi - k*xi*2*pi + phaseVals*pi);
    cont_left = contrast*sin(f*ti*2*pi + k*xi*2*pi - phaseVals*pi);
    cont = cont_right +  cont_left;
else
    cont = contrast*sin(f*ti*2*pi - direction * k*xi*2*pi + direction * phaseVals*pi);
end
end