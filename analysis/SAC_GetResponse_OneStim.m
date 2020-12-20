function resp = SAC_GetResponse_OneStim(stim_name, varargin) %% now just averaging over trials, over roi and over cells. report the standard deviation over recording. not over rois.

%% use the response prior to stimulus-onset as the baseline flourescence.
% The on_set of the stimulus is hard coded to be 1 second. on trial basis.
dfoverf_method = 'last_frame'; % last_frame | onset.
hand_pick_flag = 0;
is_bckg = 0;
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end
suffix = dfoverf_method;
%% resp : cell 
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name, hand_pick_flag);
n_cell = length(cell_name_all);
resp = cell(n_cell, 1);
for nn = 1:1:n_cell
    resp{nn} = SAC_GetResponse_OneFile(cell_name_all{nn}, suffix, is_bckg);
end

%% clipped the response by the shortest.
t_min = min(cellfun(@(x) size(x, 1), resp));
for nn = 1:1:n_cell
resp{nn} = resp{nn}(1:t_min, :, :, :);
end
end