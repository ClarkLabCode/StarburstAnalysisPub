function resptime = SAC_Load_RespTime()
S = GetSystemConfiguration;
resptiming_file = fullfile(S.sac_data_path, 'param_info', 'resptime.mat');
data = load(resptiming_file);
resptime = data.resptime;
end