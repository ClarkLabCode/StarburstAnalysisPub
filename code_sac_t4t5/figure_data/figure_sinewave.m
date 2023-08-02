function figure_sinewave()
set(0,'defaultAxesFontName', 'Arial')

%% visualization specs
meta_info.N = 90;
meta_info.SAC_N = 45;
colors_pref_null = {[23,31,89]/100; [89,23,31]/100; ([89,23,31]/100 + [23,31,89]/100)/2}; % colors = {[88,35,41]/255; [23, 59, 68]/255};
left1 = 72; left2 = 180 + 9;

%% for time traces;
tfs = [4, 2, 1, 1/2, 1/2, 1, 2, 4];
ff_str ={'4', '2', '1', '1/2', '1/2', '1', '2', '4'};
dir = [-1, -1, -1, -1, 1, 1, 1, 1];
sw = 225;
n_temporal = 4;
null_color_tmp = flipud(brewermap(n_temporal + 2, 'Blues')); null_color = null_color_tmp(1:n_temporal,:);
pref_color_tmp = brewermap(n_temporal + 2, 'Reds');pref_color = pref_color_tmp(3:end,:);
colors = mat2cell([null_color;pref_color], ones(n_temporal * 2, 1), [3]);


%% for SAC KT plot, 
sf_str = {'1/150', '1/225', '1/300', '1/450'};
% tf_str = {'1/2','\surd{2}/2', '1', '\surd{2}', '2', '2\surd{2}','4','8'};
tf_str = {'1/2','', '1', '', '2', '','4', '8'};

%% 1. plot visual stimulus
MakeFigure_Paper;
top = 600;ax_s = 45;ax_w = 27; ax_h = 45; 
visual_stimulus_sinewave_stimulus(meta_info, colors_pref_null, tfs, dir, colors, sw, ff_str, left1, top, ax_s, ax_w, ax_h);

%% 2. SAC prepare response
stim_name = 'sinewave_sweep_dense';
% resp = SAC_GetResponse_OneStim(stim_name, 'hand_pick_flag', 1, 'dfoverf_method', 'stim_onset_bckg_sub', 'is_bckg', 0);
resp = COVID_19_load_tmp_data(stim_name, 'SAC');
disp(['sinewave sweep response n = ', num2str(length((resp)))]);

[stim_info, data_info] = SAC_SineWave_Sweep_Utils_GetStimParam(stim_name);
epoch_ID = data_info.epoch_index(:);
nt_clipped = 96;
resp_clipped = cell(size(resp));
for rr = 1:1:length(resp)
    resp_clipped{rr} = resp{rr}(1:nt_clipped, :, :, :);
end

%% 3. plot averaged time traces
top = 400; ax_w = 189; ax_h = 100;
figure_sinewave_time_trace_fix_spatial(resp, tfs, dir, colors, sw, stim_info,left1, top, ax_w, ax_h);
MySaveFig_Juyue(gcf, 'figure_4_part_1', 'v4','nFigSave',1,'fileType',{'fig'});

%% 4. plot KT plot and DSI
MakeFigure_Paper; % switch figure. otherwise, the color map is messed up.
top = 250; ax_w = 90; ax_h = 72;
SAC_SineWave_KF_Plot_FinalFigure(resp, data_info, epoch_ID, stim_info, 'mean', sf_str, tf_str, left1, top, ax_w, ax_h);

% 5. plot KT plot
top = 250; ax_w = 90; ax_h = 72;
resp_T4T5 = T4T5_Sinewave_GetResponse(1);
sf_str_T4T5 = {'1/22', '1/30', '1/45', '1/60', '1/90', '1/120'};
tf_str_T4T5 = {'', '', '1/2', '', '', '', '2', '', '', '', '8', '', ''};
T4T5_Sinewave_KF_Plot_FinalFigure(resp_T4T5, sf_str_T4T5, tf_str_T4T5, left2, top, ax_w, ax_h);
MySaveFig_Juyue(gcf, 'figure_4_part_2', 'v4','nFigSave',1,'fileType',{'fig'});
end