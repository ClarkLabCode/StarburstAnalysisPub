function [highest_score, idx_A, idx_B] = get_match_score(A, B)
%%
% A = [0, 0, 0;
%      0, 1, 0;
%      0, 1, 0;
%      0, 0, 0];
% B = [0, 0, 1;
%      0, 0, 1;
%      0, 0, 1];

%% find the largest cross-correlation. should normalize first before max...
r = xcorr2(A, B); % calculate idx for each of them.
[m, n] = size(r);
scores = zeros(m, n);

for ii = 1:1:m
    for jj = 1:1:n
        
        [idx_A, idx_B] = get_idx(A, B, ii, jj);
        n_used = (idx_A(1, 2) - idx_A(1, 1) + 1) * (idx_A(2, 2) - idx_A(2, 1) + 1);
        % normalize by L0
        scores(ii, jj) = r(ii, jj)/n_used;
    end
end

scores(1:5,:) = 0; scores(end-5:end,:) = 0;scores(:,1:5) = 0; scores(:,end-5:end) = 0;
% MakeFigure; imagesc(scores);
[highest_score, idx]= max(scores(:));
[row, col] = ind2sub(size(r), idx);
[idx_A, idx_B] = get_idx(A, B, row, col);
end

function [idx_A, idx_B] = get_idx(A, B, ii, jj)
row_in_A = ii - size(B, 1);
col_in_A = jj - size(B, 2); % idx represents where to put B(1, 1) in coordinates of A.



% find out the maxtrix being used.
row_start_A = max([row_in_A, 0]) + 1;
row_start_B = max([-row_in_A, 0]) + 1;
row_length = min([size(A, 1) - row_start_A, size(B, 1) - row_start_B]);

col_start_A = max([col_in_A, 0]) + 1;
col_start_B = max([-col_in_A, 0]) + 1;
col_length = min([size(A, 2) - col_start_A, size(B, 2) - col_start_B]);

idx_A = [row_start_A, row_start_A + row_length; col_start_A, col_start_A + col_length];
idx_B = [row_start_B, row_start_B + row_length; col_start_B, col_start_B + col_length];

end