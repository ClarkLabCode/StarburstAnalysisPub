function [stim_info, data_info] = SAC_SineWave_2019_03_26_Utils_GetStimParam()
S = GetSystemConfiguration;

kVals = 1./[15, 30, 45]; %% spatial frequency. unit 1/pixel
fVals  = sqrt(2).^([0:9] - 2); %% temporal frequency. unit 1/second
dirVal = [1,-1];

n_k = 3;
n_f = 10;
n_d = 2; % two directions.

% load(fullfile(stim_dir, 'C3_sinusoid_sweep.mat'));
kVals_infer = repmat(kVals, [n_f , 1, n_d]); kVals_infer = kVals_infer(:)';
fVals_infer = repmat(fVals, [1, n_k * n_d]);
dirVal_infer = [ones(1,n_f * n_k), -ones(1,n_f * n_k)];


% p.divVal = [ones(1,n_f * n_k), -ones(1,n_f * n_k)];

epoch_index = zeros(n_f, n_k, n_d);
stim_xt = cell(n_f, n_k, n_d);
for ff = 1:1:n_f
    for kk = 1:1:n_k
        for dd = 1:1:n_d
            epoch_index(ff, kk, dd) = find(kVals_infer == kVals(kk) & abs(fVals_infer - fVals(ff))<1e-5 & dirVal_infer == dirVal(dd));
%             stim_xt{ff, kk, dd} = (p.cont(:,:,epoch_index(ff, kk, dd)));
        end
    end
end

param.kVals = kVals;
param.fVals = fVals;
param.dirVal = dirVal;

param_vec.kVals = kVals_infer;
param_vec.fVals = fVals_infer;
param_vec.dirVal = dirVal_infer;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'t_f','x_f','dirVal'};
data_info.stim_param = param;

%
% stim_info.epoch_cont = p.cont; %% Original cont corresponding to param_vec
stim_info.cont = stim_xt; %% This is after organization.
stim_info.param_name = {'t_f','x_f','dirVal'};
stim_info.param = param;
stim_info.param_vec = param_vec;
stim_info.stim_dur = 300;

stim_info.f_stim = 60; %% Is this true for this stimulus?
end
