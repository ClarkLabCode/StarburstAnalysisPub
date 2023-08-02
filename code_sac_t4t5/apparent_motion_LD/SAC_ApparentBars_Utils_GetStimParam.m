function [stim_info, data_info] = SAC_ApparentBars_Utils_GetStimParam()
S = GetSystemConfiguration;
stimulus_parameters_file = fullfile(S.sac_parameter_filepath, 'apparent_motion.mat');
load(stimulus_parameters_file);


%%
n_lead_cont = 2;
n_lag_cont = 2;
n_dir = 2;
n_phase = length(unique(stimulus_parameters.bar1_pos(stimulus_parameters.apparent_bars == 1)));

leadCont = [1,-1];
lagCont  = [1,-1];
dirVal = [1,-1]; % Progressive direction...
phase = [1:n_phase]; % position. first, 8.

%%
epoch_index = zeros(n_lead_cont, n_lag_cont, n_dir, n_phase);
for cc_lead = 1:1:n_lead_cont
    for cc_lag = 1:1:n_lag_cont
        for dd = 1:1:n_dir
            for ll = 1:1:n_phase
                epoch_index(cc_lead, cc_lag, dd, ll) = find(stimulus_parameters.apparent_bars == 1 & ....
                    stimulus_parameters.lag_polarity == lagCont(cc_lag) & ...
                    stimulus_parameters.lead_polarity == leadCont(cc_lead) & ...
                    stimulus_parameters.direction == dirVal(dd) & ...
                    (mod(stimulus_parameters.bar1_pos - 1, n_phase) + 1) == phase(ll));
            end
        end
    end
end

%%
param.leadCont = leadCont;
param.lagCont = lagCont;
param.dirVal = dirVal;
param.phase = phase;

data_info.epoch_index = epoch_index; %% organize them together
data_info.param_name = {'leadCont','lagCont','dirVal','phase'};
data_info.stim_param = param;

stim_info.epoch_cont = cont; %% Original cont corresponding to param_vec

% MakeFigure;
% for ll = 1:1:n_phase
%     for cc_lead = 1:1:2
%         for cc_lag = 1:1:2
%             for dd = 1:1:2
%                 
%                 % plot the stimulus.
%                 subplot(n_phase * 2,8,  (ll - 1)*8*2 + ((cc_lead-1)*2+cc_lag - 1)*2 + dd);
%                 epoch_this = epoch_index(cc_lead, cc_lag, dd,ll);
%                 stim_cont_this = cont(:,:,epoch_this);
%                 
%                 T4T5_Plot_Utils_PlotStimCont_YReverse(stim_cont_this, [0,0,0]);
%                 box on
%                 title(num2str(epoch_this));
%                 
%             end
%         end
%     end
% end


end
