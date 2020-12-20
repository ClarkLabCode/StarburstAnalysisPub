function figure_edge_response()
set(0,'defaultAxesFontName', 'Arial')
set(0,'DefaultAxesTitleFontWeight','normal');

%% visualization specs
meta_info.N = 90;
colors_null_pref = {[23,31,89]/100; [89,23,31]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % colors = {[88,35,41]/255; [23, 59, 68]/255};
colors_pref_null = {[89,23,31]/100; [23,31,89]/100};
line_style = {'-', '--'};
%% The stimulus is ready.
cords = {'polar', 'cart'};
lefts = [72, 180, 312, 520]; top1 = 660; top2 = 475;
MakeFigure_Paper;
for ii = 1:1:2
    visual_stimulus_edge_stimulus(meta_info, colors_null_pref, line_style, cords{ii},  top1, lefts(ii));
end

%% SAC
ax_w = 72;
[stim_info, data_info] = SAC_Edges_Utils_GetStimParam('edges');
% resp = SAC_GetResponse_OneStim('sinewave_sweep_dense', 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
resp = COVID_19_load_tmp_data('edges', 'SAC');
disp(['Edges response n = ', num2str(length(resp))]);
recording_info_sac = get_sac_recording_information('edges');
plot_response_SAC(resp, stim_info, data_info, recording_info_sac, top2, lefts(1), ax_w, colors_pref_null, line_style, [-0.2, 1]);
% plot the same thing, get the scale bar
plot_response_SAC(resp, stim_info, data_info,recording_info_sac, top2, lefts(3), ax_w, colors_pref_null, line_style, [-0.2, 1]);
ax = gca;
ax.XAxis.Visible = 'on'; ax.YAxis.Visible = 'on';
set(gca, 'YTick', [0,0.2], 'XTick', [0,1]);


%% T4T5
ax_w = 72;
cell_type = 1;  preselected_fly = 10; preselected_roi = 6;
resp_T4T5 = T4T5_Edges_GetResponse(cell_type, preselected_fly, preselected_roi);
recording_info_T4T5 = get_t4t5_recording_info_apparent_motion();
plot_response_T4T5(resp_T4T5, recording_info_T4T5, top2, lefts(2), ax_w, colors_null_pref, line_style, [-1, 20])
% plot the same thing, get the scale bar
plot_response_T4T5(resp_T4T5, recording_info_T4T5, top2, lefts(4), ax_w, colors_null_pref, line_style, [-1, 20]);
ax = gca;
ax.XAxis.Visible = 'on'; ax.YAxis.Visible = 'on';
set(gca, 'YTick', [0,4], 'XTick', [0,2]); ylabel('4 \DeltaF/F'), xlabel('s');

%%
MySaveFig_Juyue(gcf, 'figure_1_edge_stimulus', 'v4','nFigSave',1,'fileType',{'fig'});
end

function plot_response_SAC(resp, stim_info, data_info, recording_info, top, left, ax_w, colors, line_style, ylim)
%% visual spec
ax_h = 120;
offset = ylim(2)/2.5;
ylim(2) = ylim(2) + offset * 3.2;
position = [left, top, ax_w, ax_h];
legend_str = {'(+,\leftarrow)', '(+,\rightarrow)', '(-,\leftarrow)', '(-,\rightarrow)'};

[~, resp_ave, resp_sem] = SAC_GetAverageResponse(resp);
epoch_index = data_info.epoch_index;

axes('Unit', 'point', 'Position', position); % plot same direction together...
ee = 0;
vv = 2;
for pp = 1:1:2
    for dd = [2, 1]
        baseline = ee *  offset;
        SAC_Plot_Utils_PlotTimeTraces(resp_ave(:, epoch_index(dd, pp, vv)) + baseline,...
            resp_sem(:, epoch_index(dd, pp, vv)),...
            colors{dd},...
            'stim_dur', 3 * 60,...
            'f_stim', 60); hold on;
        
        ee = ee + 1;
        text(3, baseline + 0.1, legend_str{ee}, 'FontSize', 10, 'color', colors{dd});
    end
end

% axis
set(gca, 'YLim', ylim, 'XTick', [], 'YTick', []);
ax = gca;
ax.XAxis.Visible = 'off'; ax.YAxis.Visible = 'off';
ConfAxis('LineWidth', 1, 'fontSize', 10);
end

function plot_response_T4T5(resp, recording_info, top, left, ax_w, colors, line_style, ylim)
%% visual spec
ax_h = 120;
offset = ylim(2)/2.5;
ylim(2) = ylim(2) + offset * 3.2;
position = [left, top, ax_w, ax_h];

% x axis, in second.
f_resp = recording_info.f_resp;
stim_onset = 0; % always 1 second. hardcoded? independent of the stimulus.
resp_time = (1:size(resp, 1))'/f_resp - stim_onset;


legend_str = {'(+,\leftarrow)', '(+,\rightarrow)', '(-,\leftarrow)', '(-,\rightarrow)'};
axes('Unit', 'point', 'Position', position); % plot same direction together...

hold on;
ee = 0;
for pp = 1:1:2
    for dd = 1:1:2
        % plot response
        baseline = ee *  offset;
        plot(resp_time, resp(:, dd, pp) + baseline, 'color', colors{dd}, 'LineStyle', line_style{pp});
        ee = ee + 1;
        
        text(0, baseline + 5, legend_str{ee}, 'FontSize', 10, 'color', colors{dd});
    end
end

% axis
set(gca, 'YLim', ylim, 'XTick', [], 'YTick', []);
ax = gca;
ax.XAxis.Visible = 'off'; ax.YAxis.Visible = 'off';
end