clear
clc

stim_name = 'sinewave_opponent';
% cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, 0);

cell_name_all = {'20317_02_c', '20331_LE_02_a', '20331_LE_02_b', '20331_LE_03_b'};
for ii = 1:1:length(cell_name_all)
    SAC_PreProcess_5D_Movie(cell_name_all{ii}, 'plot_raw_trace_flag', 1);
end
