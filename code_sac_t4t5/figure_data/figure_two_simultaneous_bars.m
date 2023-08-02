function figure_two_simultaneous_bars()
set(0,'defaultAxesFontName', 'Arial');
set(0,'DefaultAxesTitleFontWeight','normal');

left_1 = 36; left_2 = left_1 + 81; left_3 = left_1 + 225; left_4 = left_1 + 400; top = 460; % plot four static ring.

%% 1. plot visual stimulus
MakeFigure_Paper;
ax_w = 40; ax_h = 60;
visual_stimulus_single_and_two_simultaneous_bars('two_simultaneous_bars', left_1, left_3, left_4, top, ax_w, ax_h)

%% 2. prepare response SAC
stim_name = 'apparent_motion';
recording_info = get_sac_recording_information(stim_name);
epoch_ID = (1:58)';

% resp = SAC_GetResponse_OneStim(stim_name, 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub');
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
[~, data_info_two_simultaneous] = SAC_TwoSimultaneousBar_Utils_GetStimParam();
[resp_two_simultaneous, ~, data_info_two_simultaneous] = T4T5_OrganizeRespInit(resp, data_info_two_simultaneous, epoch_ID);

%% 3. plot time traces
ax_w = 80;
time_traces(resp_two_simultaneous, data_info_two_simultaneous, left_2, top, ax_w, ax_h)

%% 4. plot analysis plot
% plot bar plot. SAC;
ax_w = 120 * 4/5; plot_max_value = 0.5;
figure_two_simultaneous_bars_utils_bar_plot(resp_two_simultaneous, data_info_two_simultaneous, recording_info, 0, plot_max_value, left_3, top, ax_w, ax_h);
set(gca, 'XTick', [1, 2, 3, 4], 'XTickLabel', [0, 1, 2, 3]); % positions 4 is the center! 
xlabel('inner ring position (50\mum)', 'FontSize', 10, 'Interpreter', 'tex');


%% 5. plot analysis plot for T4T5.
thresh = 3; % light/dark single bar at rf center is larger than 3.
rf_center = 5;
dataset_name = 'neighbor';
recording_info_T4T5 = get_t4t5_recording_info_apparent_motion();
resp_T4T5 = COVID_19_load_tmp_data(stim_name, 'T4_Pro', dataset_name);
% resp = T4T5_AppMot_GetResponse_OneCellType(1,  dataset_name);
epoch_ID_T4T5 = (1:144)';

[~, data_info_single_T4T5] = T4T5_SingleBar_Utils_GetStimParam(dataset_name);
[resp_single_T4T5, ~, data_info_single_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_single_T4T5, epoch_ID_T4T5);
[~, data_info_two_simultaneous_T4T5] = T4T5_TwoSimultaneousBar_Utils_GetStimParam(1, dataset_name);
[resp_two_simultaneous_T4T5_orig, ~, data_info_two_simultaneous_T4T5] = T4T5_OrganizeRespInit(resp_T4T5, data_info_two_simultaneous_T4T5, epoch_ID_T4T5);
% select response by single bar response
resp_two_simultaneous_T4T5 = select_rois_based_on_single_bar_response(resp_single_T4T5, resp_two_simultaneous_T4T5_orig, recording_info_T4T5, data_info_single_T4T5, thresh, rf_center);

% plot
ax_w = 120; plot_max_value = 1.4;
figure_two_simultaneous_bars_utils_bar_plot(resp_two_simultaneous_T4T5, data_info_two_simultaneous_T4T5, recording_info_T4T5, 1, plot_max_value, left_4, top, ax_w, ax_h);
xlabel('left bar position (5\circ)', 'FontSize', 10);
set(gca, 'XTick', [3, 4, 5, 6, 7], 'XTickLabel', [-1, 0, 1, 2, 3]); % positions 4 is the center! 

   
    
MySaveFig_Juyue(gcf, 'figure_6_3_two_simultaneous_bars','v3', 'nFigSave', 1,'fileType',{'fig'});

end

function time_traces(resp, data_info, left, top, ax_w, ax_h)
positions = {[left, top, ax_w, ax_h],;
    [left, top - (ax_h +20), ax_w, ax_h];
    [left, top - (ax_h +20) * 2, ax_w, ax_h];
    [left, top - (ax_h +20) * 3, ax_w, ax_h];
    };

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
epoch_index = data_info.epoch_index;
ll = 2;
ee = 1;
for cc_bar_1 = 1:1:2
    for cc_bar_2 = 1:1:2
        resp_ave_plot = {resp_ave(:, epoch_index(cc_bar_1, cc_bar_2, ll))};
        resp_sem_plot = {resp_sem(:, epoch_index(cc_bar_1, cc_bar_2, ll))};
        axes('Unit', 'point', 'Position', positions{ee});
        plot_multiple_time_traces(resp_ave_plot, resp_sem_plot, {[0,0,0]},'stim_dur', 60);
        set(gca, 'YLim', [-0.2, 0.7], 'YTick', [0, 0.5], 'XLim', [-0.25, 1.25], 'YTickLabelRotation', 90);
        ee = ee + 1;
    end
end
end



