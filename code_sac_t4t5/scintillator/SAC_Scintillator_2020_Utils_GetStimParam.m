function [stim_info, data_info] = SAC_Scintillator_2020_Utils_GetStimParam()

%% load the stimulus.
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'scintillator.mat');
load(stimulus_parameters_file);

%% this -1 and 1 is trouble some... which direction? forget again.
n_time = 6;
n_dir = 2;
n_par = 2;

dt = [0:5];
dx = [-1,1]; % -1 preferred direction. put as the first dimension. 
polarity = [1, -1];

epoch_index = zeros(n_time, n_dir, n_par);
stim_crosscorr = zeros(11, 5, n_time*n_dir*n_par );

for pp = 1:1:n_par
    for dd = 1:1:n_dir
        for tt = 1:1:n_time
            epoch_index(tt, dd, pp) = find(stimulus_parameters.temporal_offset == dt(tt) & ...
                stimulus_parameters.spatial_offset == dx(dd) & ...
                stimulus_parameters.polarity == polarity(pp));
            stim_crosscorr(:,:,epoch_index(tt, dd, pp)) = calculate_cross_cont(squeeze(cont(:,:,epoch_index(tt, dd, pp))));
        end
    end
end

param.parvals = polarity;
param.dtVals = dt;
param.dirVals = dx;

param_vec.temporal_offset = stimulus_parameters.temporal_offset;
param_vec.spatial_offset = stimulus_parameters.spatial_offset;
param_vec.polarity = stimulus_parameters.polarity;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'dt','dx','polarity'};
data_info.stim_param = param;

%
stim_info.epoch_cont = cont; %% Original cont corresponding to param_vec
stim_info.epoch_crosscorr = stim_crosscorr;
stim_info.param_name = {'dt','dir','polarity'};
stim_info.param = param;
stim_info.param_vec = param_vec;

stim_info.SPLT = stimulus_parameters.SPLT(1);
stim_info.fps = stimulus_parameters.fps(1); 
stim_info.duration = stimulus_parameters.duration(1);
stim_info.stimulus_parameters = stimulus_parameters;
% stim_info.stim_dur = size(cont, 1); %%
end

function r_coef = calculate_cross_cont(cont_this)
cont_this = cont_this - round(mean(cont_this(:))* 2) * 1/2;
[T, X] = size(cont_this);
r = xcorr2(cont_this);
r_s = xcorr2(ones(size(cont_this)));
r_coef = r./r_s;
r_coef = r_coef/r_coef(T, X);

r_coef = r_coef(T-5:T+5, X-2:X+2);
end
% MakeFigure;
% subplot(2,2,1);
% histogram(p.cont(:,:,epoch_index(1, 1, 1)), [-0.1, 0.1,0.4, 0.6,0.9, 1.1], 'FaceColor',[0,0,0]);
% set(gca, 'XTick', [0,0.5, 1]);
% title('epoch 1 (positive correlation)');
% xlabel('contrast');
% ylabel('count');
% ConfAxis('fontSize', 13);
% subplot(2,2,2);
% histogram(p.cont(:,:,epoch_index(1, 1, 2)), [-0.6, -0.4, -0.1, 0.1,0.4, 0.6], 'FaceColor',[0,0,0]);
% set(gca, 'XTick', [-0.5, 0,0.5]);
% xlabel('contrast');
% ylabel('count');
% title('epoch 13 (negative correlation)');
% ConfAxis('fontSize', 13);

