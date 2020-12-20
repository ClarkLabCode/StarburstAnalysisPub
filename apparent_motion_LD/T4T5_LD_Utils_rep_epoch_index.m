function epoch_index_rep = T4T5_LD_Utils_rep_epoch_index(epoch_index, source, target)
curr_card = size(epoch_index);
%% [2, 8] to [2, 2, 8]; 
if strcmp(source, 'SingleBar') && strcmp(target, 'TwoSimultaneous')
    tmp = repmat(epoch_index, [2, 1]);
    tmp_reshape = reshape(tmp, [2, curr_card]);
    epoch_index_rep = permute(tmp_reshape, [2,1,3]);

%% [2, 8] to [2, 2, 2, 8]; rep_dim = [2, 3]? or [1, 3]. should not matter.
elseif strcmp(source, 'SingleBar') && strcmp(target, 'AppMot')
    tmp = repmat(epoch_index, [4, 1]);
    tmp_reshape = reshape(tmp, [2, 2, curr_card]);
    epoch_index_rep = permute(tmp_reshape, [3, 1, 2, 4]);

%% [2, 2, 8] to [2, 2, 2, 8]; rep_dim = 3; directions.
elseif strcmp(source, 'TwoSimultaneous') && strcmp(target, 'AppMot')
    tmp = repmat(epoch_index, [2, 1]);
    tmp_reshape = reshape(tmp, [2, curr_card]);
    epoch_index_rep = permute(tmp_reshape, [3, 1, 2, 4]);
end
end