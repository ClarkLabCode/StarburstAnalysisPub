function SAC_PreProcess_5D_Movie(cell_name, varargin)
plot_raw_trace_flag = 0;
plot_dfoverf_trace_flag = 1;
dfoverf_method = 'stim_onset';

fs = 15.6250;
selection_method = 'water_shed';
dimThreshLevel = 0.05;
is_one_roi = 1;

% stim_name = '';
fpass = 0.1;
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

S = GetSystemConfiguration;
respfolder = fullfile(S.sac_data_path, cell_name);

%% roi selection
[roi_mask, mean_movie] = SAC_RoiSelection(respfolder, 'selection_method',selection_method);

%% get background subtracted movies.
if strcmp(stim_name, 'white_noise')
    movie_bckg_sub = SAC_BleedThroughSubtraction_Main(respfolder, fullfile(respfolder, [cell_name,'.mat']));
    resp_f(:, 1, :, :) = permute(SAC_GetRoiTimeTrace(roi_mask, movie_bckg_sub), [1, 3, 2]);
    resp_bckg = [];dfoverf_bckg = [];
else
    raw_movie = load_raw_movie(respfolder);
    
    %% blackground subtraction. select roi. In terms of bleedthrough kernel subtraction, same effect as the kernel subtraction version. However, sometimes too much, resp_f goes under 0.
    [movie_bckg_sub, bckg_mask] = SAC_BlackgroundSubtraction(raw_movie, dimThreshLevel);
    resp_f = SAC_GetRoiTimeTrace_5D_movie(roi_mask, movie_bckg_sub, is_one_roi);
    resp_bckg = SAC_GetRoiTimeTrace_5D_movie(bckg_mask, raw_movie, 1);
    
    if plot_raw_trace_flag
        plot_raw_dfoverf(resp_f);
        sgtitle(['Raw Response: ', cell_name], 'Interpreter', 'none');
        plot_raw_dfoverf(resp_bckg);
        sgtitle(['Bleedthrough Response: ', cell_name], 'Interpreter', 'none');
    end
    
    dfoverf_bckg = filterRoiTrace_calculate_dfoverf(dfoverf_method, resp_bckg, fpass, fs);
end

dfoverf = filterRoiTrace_calculate_dfoverf(dfoverf_method, resp_f, fpass, fs);
%% plot it dfoverf
if plot_dfoverf_trace_flag
    plot_raw_dfoverf(dfoverf); % somehow, large numbers there...
    sgtitle(['dF Over F: ', cell_name, ''], 'Interpreter', 'none');
end


%% save file
file_dir = fullfile(respfolder,'saved_analysis');
if ~exist(file_dir,'dir')
    mkdir(file_dir);
end

if strcmp(dfoverf_method, 'lowhighpass')
    file_path = fullfile(file_dir, ['resp_', dfoverf_method, '_bckg_sub_','fpass', num2str(fpass * 100) '.mat']);
else
    file_path = fullfile(file_dir, ['resp_', dfoverf_method, '_bckg_sub', '.mat']);
end

preprocess.raw_resp = resp_f;
preprocess.resp = dfoverf;   % dfOverf
preprocess.raw_bckg = resp_bckg;
preprocess.resp_bckg = dfoverf_bckg;
preprocess.roi_mask = roi_mask;
preprocess.meanfilm = mean_movie;
preprocess.dfoverf_method = dfoverf_method;
preprocess.dim = ['time','trial','epoch','rois'];
save(file_path, 'preprocess');

%% also save the corresponding mean movie
end

function  [raw_movie] = load_raw_movie(respfolder)
    %% get roi time traces.
    data_info = dir(fullfile(respfolder,'oim*.mat'));
    n_epoch = length(data_info);
    % oim X means stimulus epoch X
    data_info_name = arrayfun(@(ee) ['oim', num2str(ee),'_' cell_name, '.mat'], 1:n_epoch, 'UniformOutput', false);
    raw_movie = cell(n_epoch, 1);
    for ee = 1:1:n_epoch
        file = fullfile(respfolder, data_info_name{ee});
        [~, raw_movie{ee}] = SAC_utils_load_raw_movie_5D_movie(file);
    end
    
end
