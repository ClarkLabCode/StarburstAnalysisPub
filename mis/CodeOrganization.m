% Agenda
% 1. go through analysis code.
% 2. go through new stimulus paramter file. Current, hardcoded stimulus. In
% the future, parameter files will be stored together with recordings.

% 3. how to intergrete two systems.

%% 0. organize the data into a local folder. 
%% 1. set up the git.
% download repository to local PC.
% sysConfig-> sac_data_path
S = GetSystemConfiguration;
S.sac_data_path

%% 2. organize the database
% go to D:\data_sac_calcium in Explore
% change the excel, as well as the matfile.
% stim_info for 8 stimulus.
SAC_Utils_data_base_from_xlsx_to_table()

%% preprocessing-> ROI selection, DF/F, organize data.
% cell_name = '19326_LE_01_a';
cell_name = '19o10_LE_02_c';
SAC_PreProcess_5D_Movie(cell_name);

%% analyze a particular stimulus.


%% Example scintillator


%% Example sinewave

