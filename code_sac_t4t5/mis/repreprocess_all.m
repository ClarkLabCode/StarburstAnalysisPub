
clear
clc

process_movie_flag = false;
stim_names = {'sinewave_sweep_dense', 'apparent_motion', 'scintillator', 'sinewave_opponent', 'white_noise'};

for ii = 5:1:5
    preprocess_this_stimulus(stim_names{ii})
end

function preprocess_this_stimulus(stim_name)
hand_pick_flag = 1;
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag);
% 
for ii = 2:1:length(cell_name_all)
    SAC_PreProcess_5D_Movie(cell_name_all{ii}, 'dfoverf_method', 'lowhighpass', 'is_one_roi', 0);
end
end