% write a small script to automatically parse them...

function update_database()

% 
% folder_names = {'19d01','19n06', '19n11', '19n30', '19d10'};
% folder_names = {'19d01'};
% stimulus_parameter = 'sinewave_sweep_dense';
% update_data_for_one_stimulus(folder_names, stimulus_parameter);

% folder_names = {'19d01', '19d05', '19d16', '19d19'};
% stimulus_parameter = 'apparent_motion';
% update_data_for_one_stimulus(folder_names, stimulus_parameter);
% 
% folder_names = {'20103', '20115', '20128', '20129', '20209'};
% stimulus_parameter = 'scintillator';
% update_data_for_one_stimulus(folder_names, stimulus_parameter);

%stimulus_parameter = 'sinewave_opponent';
%folder_names = {'20317', '20331', '20406'};
% 
% stimulus_parameter = 'edges';
% folder_names = {'20521'};
% update_data_for_one_stimulus(folder_names, stimulus_parameter);

% stimulus_parameter = 'white_noise';
% folder_names = {'18821', '18823', '18828', '18911'};
% update_data_for_one_stimulus(folder_names, stimulus_parameter);

stimulus_parameter = 'C2 - scintillator LIN';
folder_names = {'22830', '22902'};
update_data_for_one_stimulus(folder_names, stimulus_parameter);
end

function update_data_for_one_stimulus(folder_names, stimulus_parameter)
S = GetSystemConfiguration;
dropbox_data = 'C:\Users\yalec\Dropbox\BorghuisClark - SAC Calcium\submission_ready_data_code\dryad_sac_t4t5\data_sac_calcium';

[subfolder_name_flat, folder_name_flat] = check_all_folders(folder_names, dropbox_data, 'stimulus_parameter', stimulus_parameter);
[subfolder_name_flat, folder_name_flat] = choose_updated_files(subfolder_name_flat, folder_name_flat, S.sac_data_path);
[transformed_name, data_path_source, data_path_destination] = ...
    get_path_and_name(folder_name_flat, subfolder_name_flat, S.sac_data_path, dropbox_data);

copy_omni_files(data_path_source, data_path_destination)

% display them.
disp(cat(1, folder_name_flat{:}));
% name_tmp = cellfun(@(x) ['LE_', x], subfolder_name_flat, 'UniformOutput', false);
name_tmp = cellfun(@(x) x(7:end), subfolder_name_flat, 'UniformOutput', false);
disp(cat(1, name_tmp{:}));

function copy_omni_files(data_path_source, data_path_destination)
for dd = 1:1:length(data_path_source)
    data_path_source{dd}
    data_path_destination{dd}
    copyfile(fullfile(data_path_source{dd}, '*.mat'), data_path_destination{dd});
end

end
%% collect all data_path, folder_name, subfolder_name
function [subfolder_name_flat, folder_name_flat] = check_all_folders(folder_names, dropbox_data, varargin)
stimulus_parameter = ''; % check out the stimulus parameter file? or hard coded.
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

%% from stimulus parameter file infer how many epoches. somewhat dangerous. okay for now.
stimulus_parameter='scintillator';
if strcmp(stimulus_parameter, 'white_noise')
    n_epoch = 6;
else
    params_info = xlsread(fullfile('C:\Users\yalec\Dropbox\BorghuisClark - SAC Calcium\submission_ready_data_code\dryad_sac_t4t5\data_sac_calcium', 'stimulus_parameter', [stimulus_parameter, '.xlsx']));
    n_epoch = size(params_info, 2);
end
%%

folder_name_flat = cell(1000, 1);
subfolder_name_flat = cell(1000, 1);
count = 0;

for ff = 1:1:length(folder_names)
    folder_name = folder_names{ff};
    subfolder_info = dir(fullfile(dropbox_data,  folder_name));
    for ss = 1:1:length(subfolder_info)
        subfolder_path = fullfile(fullfile(dropbox_data,  folder_name, subfolder_info(ss).name), '*.mat');
        fileinfo = dir(subfolder_path);
        if length(fileinfo) == n_epoch
            count = count + 1;
            folder_name_flat{count} = folder_name;
            subfolder_name_flat{count} = subfolder_info(ss).name;
        end
    end
end

subfolder_name_flat = subfolder_name_flat(1:count);
folder_name_flat = folder_name_flat(1:count);
end

%%


function [subfolder_name_flat, folder_name_flat] = choose_updated_files(subfolder_name_flat, folder_name_flat, local_data_path)
[~, ~, data_path_destination] = ...
    get_path_and_name(folder_name_flat, subfolder_name_flat, local_data_path, '');
%% go through data_path_destination, if exist, pass. if not, update both .
updated_files = zeros(length(data_path_destination), 1);
for dd = 1:1:length(data_path_destination)
    data_dest = data_path_destination{dd};
    if ~exist(data_dest, 'dir')
        updated_files(dd) = 1;
    end
end
subfolder_name_flat = subfolder_name_flat(updated_files == 1);
folder_name_flat = folder_name_flat(updated_files == 1);
end

%%
function [transformed_name, data_path_source, data_path_destination] = ...
    get_path_and_name(folder_name_flat, subfolder_name_flat, local_data_path, dropbox_data)
% transformed_name = cellfun(@(x, y)[x, '_LE_', y], folder_name_flat, subfolder_name_flat, 'UniformOutput', false);
transformed_name = subfolder_name_flat;
data_path_source = cellfun(@(x, y) fullfile(dropbox_data, x, y),  folder_name_flat, subfolder_name_flat, 'UniformOutput', false);
data_path_destination =  cellfun(@(x) fullfile(local_data_path, x),  transformed_name, 'UniformOutput', false);
end

end