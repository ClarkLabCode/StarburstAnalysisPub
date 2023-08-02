clc
clear
% number of flies: T5 PRo
% 8 T4 Pro, 3 T4 Reg,  
cell_str = {'T4 Pro', 'T4 Reg', 'T5 Pro', 'T5 Reg'};
dataset_name = 'neighbor';
recording_info.f_resp = 13;
recording_info.stim_onset = 0.2;
recording_info.stim_dur_sec = 1;
recording_info.second_bar_onset = 0.15;
%%
epoch_ID = (1:144)';
plot_max_value = 2;
plot_flag = 0;
save_fig = 0;
for cell_type = 1:1:4
    resp = T4T5_AppMot_GetResponse_OneCellType(cell_type,  dataset_name);
    figure_name = cell_str{cell_type};
    apparent_motion_LD_main...
        (resp, recording_info, epoch_ID, figure_name, plot_max_value, plot_flag, save_fig, cell_type, dataset_name);
end
 
%% Emilio old dataset. There is no simultaneous two bars.
dataset_name = 'next_neighbor';
epoch_ID = (1:112)';
plot_max_value = 3;
plot_flag = 0;
save_fig = 0;
for cell_type = 1:1:4
    resp = T4T5_AppMot_GetResponse_OneCellType(cell_type,  dataset_name);
    figure_name = cell_str{cell_type};
    apparent_motion_without_simultaneous_main...
        (resp, recording_info, epoch_ID, figure_name, plot_max_value, cell_type, dataset_name)
end
 
