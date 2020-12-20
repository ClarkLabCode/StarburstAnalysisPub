function cont = make_scintillator(temporal_offset, spatial_offset, polarity, spatial_size_in_pixel, duration, fps, SPLT)
%% script to make 2 pt correlation stimulus
% note: since this is stochastic, when multiple runs of the same stimulus
% are used, they should be regenerated here to make each instantiation
% different from the others... This could also be done be expanding the
% number here with with the same parameters -- they'll be different
rng(1);

T = ceil(duration * fps / SPLT); % time steps
X = spatial_size_in_pixel; % positions

c1 = rand(T,X+5) > 0.5;
tmp = (c1 + polarity * circshift(c1,[temporal_offset, -spatial_offset])) * 1/2; % ternary stimulus, -1,0,1
cont = tmp(:,1:X); % do we don't get wrap around

% cont = repelem(cont, patternlifetime_in_frame, 1);
if polarity == 1
    mean_lum = 0.5;
else
    mean_lum = 0;
end

cont = cont - mean_lum;

end