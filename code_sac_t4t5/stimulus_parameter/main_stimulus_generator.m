%% sinewave
sinewave_parameter_file = 'sinewave_sweep_dense.xlsx';
xt_filename = 'sinewave_sweep_dense.mat';
main_sinewave(sinewave_parameter_file, xt_filename)

sinewave_parameter_file = 'sinewave_sweep_sparse.xlsx';
xt_filename = 'sinewave_sweep_sparse.mat';
main_sinewave(sinewave_parameter_file, xt_filename)

%% opponency stimulus wait for result on sinewave.
xt_filename = 'sinewave_opponent';
sinewave_parameter_file = 'sinewave_opponent.xlsx';
main_opponent_sinewave(sinewave_parameter_file, xt_filename);

%% white noise
% keep original experiment.

%% scintillator. interleave: gray || interleave: uncorrelated stochastic stimulus.
% interleave is gray, therefore, each trial is independent.
disp('Scintillator stimuli. Each pixel should be 50 um');
scintillator_parameter = 'scintillator.xlsx';
xt_filename = 'scintillator.mat';
main_scintillator(scintillator_parameter, xt_filename);

%% apparent motion
disp('Apparent Motion stimuli. Each pixel should be 50 um');
apparent_motion_parameter = 'apparent_motion.xlsx';
xt_filename = 'apparent_motion.mat';
cont = main_apparent_motion(apparent_motion_parameter, xt_filename);

