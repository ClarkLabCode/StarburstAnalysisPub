
function cont = main_apparent_motion(apparent_motion_parameter, xt_filename)

%% load paratemer files
num = xlsread(apparent_motion_parameter);
epoch_number = num(1, :);
single_bar = num(2, :);
simultaneous_bars = num(3, :);
apparent_bars = num(4, :);
bar1_pos = num(5, :);
bar2_pos = num(6, :);
direction = num(7, :);
delay = num(8, :);
lead_polarity = num(9, :);
lag_polarity = num(10, :);
spatial_size_in_pixel = num(11, :);
duration = num(12, :);
fps = num(13,:);
SPLT = num(14,:);
SPPS = num(15,:);

%% make stimulus
N = length(epoch_number);
xt_plot = cell(N, 1);
for ee = epoch_number
    if single_bar(ee) == 1
        xt_plot{ee} = make_single_bar(bar1_pos(ee), lead_polarity(ee), duration(ee)* fps(ee), spatial_size_in_pixel(ee));
    elseif simultaneous_bars(ee) == 1
        xt_plot{ee} = make_simultaneous_bar(bar1_pos(ee), bar2_pos(ee), lead_polarity(ee), lag_polarity(ee), duration(ee) * fps(ee), spatial_size_in_pixel(ee));
    elseif apparent_bars(ee) == 1
        xt_plot{ee} = make_apparent_motion(bar1_pos(ee), bar2_pos(ee), direction(ee), lead_polarity(ee), lag_polarity(ee), delay(ee)* fps(ee), duration(ee)* fps(ee), spatial_size_in_pixel(ee));
    end
end
cont = cat(3, xt_plot{:});

%% save the stimulus.
stimulus_parameters.epoch_number = epoch_number;
stimulus_parameters.single_bar = single_bar;
stimulus_parameters.simultaneous_bars = simultaneous_bars;
stimulus_parameters.apparent_bars  = apparent_bars;
stimulus_parameters.bar1_pos = bar1_pos;
stimulus_parameters.bar2_pos = bar2_pos;
stimulus_parameters.lead_polarity = lead_polarity ;
stimulus_parameters.lag_polarity = lag_polarity;
stimulus_parameters.direction = direction;
stimulus_parameters.delay = delay ;
stimulus_parameters.spatial_size_in_pixel = spatial_size_in_pixel;
stimulus_parameters.duration = duration ;
stimulus_parameters.fps = fps;
stimulus_parameters.SPLT = SPLT;
stimulus_parameters.SPPS = SPPS;

save(xt_filename, 'stimulus_parameters', 'cont');

figure(); 
for ee = 1:32
subplot(4, 8, ee)
imagesc(cont(:, :, ee)); colormap(gray); set(gca, 'clim', [-1, 1]);
end

figure();
for ee = 33:42
subplot(2, 5, ee-32)
imagesc(cont(:, :, ee)); colormap(gray); set(gca, 'clim', [-1, 1]);
end

figure();
for ee = 43:58
subplot(4, 4, ee-42)
imagesc(cont(:, :, ee)); colormap(gray); set(gca, 'clim', [-1, 1]);
end

end

function cont = make_apparent_motion(bar1_pos, bar2_pos, direction, lead_cont, lag_cont, delay, T, X)
cont = zeros(T,X);
if direction == 1
    leadPos = bar1_pos; lagPos = bar2_pos;
else
    leadPos = bar2_pos; lagPos = bar1_pos;
end
cont(:,leadPos)=lead_cont;
cont(delay+1:end,lagPos)=lag_cont;
end

function cont = make_simultaneous_bar(bar1_pos, bar2_pos, bar1_cont, bar2_cont, T, X)
cont = zeros(T,X);

cont(:,bar1_pos)=bar1_cont;
cont(:,bar2_pos)=bar2_cont;
end

function cont = make_single_bar(bar_pos, bar_cont,T, X)
cont = zeros(T,X);
cont(:,bar_pos)=bar_cont;

end