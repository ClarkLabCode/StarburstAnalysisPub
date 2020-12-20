% load all intermediate data from server

%% apparent motion

% % ON_SAC
% resp = SAC_GetResponse_OneStim('apparent_motion', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
% save('apparent_motion_SAC', 'resp');
% 
% % T4 and T5.
% cell_str = {'T4 Pro', 'T4 Reg', 'T5 Pro', 'T5 Reg'};
% dataset_name = 'next_neighbor';
% for cell_type = 1:1:4
%     resp = T4T5_AppMot_GetResponse_OneCellType(cell_type,  dataset_name);
%     save(['apparent_motion_', cell_str{cell_type}], 'resp');
% end

% T4 and T5.
% cell_str = {'T4_Pro', 'T4_Reg', 'T5_Pro', 'T5_Reg'};
% dataset_name = 'neighbor';
% for cell_type = 1:1:4
%     resp = T4T5_AppMot_GetResponse_OneCellType(cell_type,  dataset_name);
%     save(['apparent_motion_neighbor_', cell_str{cell_type}], 'resp');
% end
% 
% %% sinewave sweep dense
% resp = SAC_GetResponse_OneStim('sinewave_sweep_dense', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
% save('sinewave_sweep_dense_SAC', 'resp');

% %% scintillator
% resp = SAC_GetResponse_OneStim('scintillator', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
% save('scintillator_SAC', 'resp');
% 
% %% sinewave_opponent
% resp = SAC_GetResponse_OneStim('sinewave_opponent', 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
% save('sinewave_opponent_SAC', 'resp');
