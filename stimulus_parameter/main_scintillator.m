function cont = main_scintillator(scintillator_parameter, xt_filename)

%% load paratemer files
num = xlsread(scintillator_parameter);
epoch_number = num(1, :);
spatial_offset = num(2, :); %% 1: null direction. -1: means preferred direction.
temporal_offset = num(3, :);
polarity = num(4, :);
spatial_size_in_pixel = num(5, :);
duration = num(6, :);
fps = num(7, :);
SPLT = num(8, :);
SPPS = num(9, :);
%% make stimulus
N = length(epoch_number);
xt_plot = cell(N, 1);
for ee = epoch_number
    xt_plot{ee} = make_scintillator(temporal_offset(ee), spatial_offset(ee), polarity(ee), spatial_size_in_pixel(ee), duration(ee), fps(ee), SPLT(ee));
end
cont = cat(3, xt_plot{:});

%% save the stimulus.
stimulus_parameters.epoch_number = epoch_number;
stimulus_parameters.spatial_offset = spatial_offset;
stimulus_parameters.temporal_offset = temporal_offset;
stimulus_parameters.polarity = polarity;
stimulus_parameters.spatial_size_in_pixel = spatial_size_in_pixel;
stimulus_parameters.duration = duration;
stimulus_parameters.fps = fps;
stimulus_parameters.SPLT = SPLT;
stimulus_parameters.SPPS = SPPS;

save(xt_filename, 'stimulus_parameters', 'cont');

%%

figure();
for ee = 1:1:24
    cont_this = squeeze(cont(:, :, ee));
    [T, X] = size(cont_this);
    r = xcorr2(cont_this);
    r = r(T-6:T+6 , X-2:X+2);
    subplot(4, 6, ee);
    imagesc(r); colormap(gray);
    set(gca, 'XTick',[2,3,4], 'XTickLabel',{'-1','0','1'}, 'YTick',[5,6,7], 'YTickLabel',{'-1','0','1'});
end

figure();
for ee = 1:1:24
    cont_this = squeeze(cont(:, :, ee));
    subplot(4, 6, ee);
    histogram(cont_this)
end

end
