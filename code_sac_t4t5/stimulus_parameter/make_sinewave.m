function cont = make_sinewave(temporal_frequency, spatial_wavelength, contrast, direction, phaseVals, spatial_range, temporal_duration, fps, pixel_size)
T = temporal_duration * fps; % time steps;
X = spatial_range/pixel_size;
k = 1/(spatial_wavelength/pixel_size);
f = temporal_frequency / fps;

ti = (0:(T-1))';
xi = 0:(X-1);

cont = contrast * sin(-direction * f*ti*2*pi + k*xi*2*pi + phaseVals*2*pi);
end