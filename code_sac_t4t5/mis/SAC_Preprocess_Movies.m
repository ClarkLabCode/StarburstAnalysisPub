clear
clc
process_movie_flag = false;
%% load recordings specific to the stimulus.
stim_name = 'apparent_motion';
hand_pick_flag = false;
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag);
% if not processed. process it.
if process_movie_flag
    for ii = 1:1:length(cell_name_all)
        SAC_PreProcess_5D_Movie(cell_name_all{ii});
    end
end