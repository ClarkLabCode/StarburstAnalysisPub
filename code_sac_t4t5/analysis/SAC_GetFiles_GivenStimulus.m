function cell_name = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag)
    S = GetSystemConfiguration;
    sac_data_file = fullfile(S.sac_data_path, 'stim_info','data_base.mat');
    load(sac_data_file);
    
    X = stim_to_number(stim_name);
    if ~hand_pick_flag
        manual_select = ones(length(X), 1);
    end
    cell_name = T_cell_to_stim.cell_name(T_cell_to_stim.number == X & manual_select == 1);
end