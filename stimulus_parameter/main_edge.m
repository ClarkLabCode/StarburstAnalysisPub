function main_edge(edge_parameter_file, xt_filename)
%% load the parameter files
num = xlsread(edge_parameter_file);

epoch_number = num(1,:);
direction = num(2,:);
contrast = num(3,:); % 1, -1

velocity = num(4,:)
spatial_range = num(5,:);
pixel_size = num(6, :);
fps = num(7,:);

%% generate all stimulus
N = length(epoch_number);
xt_plot = cell(N, 1);
for ee = epoch_number
    xt_plot{ee} = make_edge(contrast(ee), direction(ee), ...
        velocity(ee), spatial_range(ee), pixel_size(ee), fps(ee));
end

% cont = cat(3, xt_plot{:});
cont = xt_plot;

%% save it
stimulus_parameters.epoch_number = epoch_number;
stimulus_parameters.direction = direction;
stimulus_parameters.contrast = contrast;
stimulus_parameters.velocity = velocity;

stimulus_parameters.spatial_range = spatial_range;
stimulus_parameters.fps = fps;
stimulus_parameters.pixel_size = pixel_size;

save(xt_filename, 'stimulus_parameters', 'cont');

%% plot it
figure();
for ee = epoch_number
    subplot(4, 4, ee);
    imagesc(squeeze(xt_plot{ee})); colormap(gray);
%     imagesc(squeeze(cont(:, :, ee))); colormap(gray);
end
end

function cont = make_edge(contrast, direction, velocity, spatial_range, pixel_size, fps)
% spatial range in micrometer
N = round(spatial_range/pixel_size);
T  = spatial_range/velocity * fps;
cont = zeros(T, N);

for t = 1:1:T
    % right boundary
    pos = floor(velocity * t/fps/pixel_size);
    if direction == 1
        cont(t, 1:pos - 1) = contrast;
        cont(t, pos:end) = contrast * (-1);
    else
        cont(t, end-pos:end) = contrast;
        cont(t, 1:end-pos + 1) = contrast * (- 1);
    end
end
end