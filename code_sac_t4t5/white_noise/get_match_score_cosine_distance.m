function [highest_score, idx_A, idx_B] = get_match_score_cosine_distance(A, B)
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
        
        A_eff = A(idx_A(1, 1):idx_A(1, 2), idx_A(2, 1):idx_A(2, 2));
        B_eff = B(idx_B(1, 1):idx_B(1, 2), idx_B(2, 1):idx_B(2, 2));
        
        tmp = A_eff .* B_eff;
        if (abs(sum(tmp(:))) - r(ii, jj)) > 1e-1
            error('wrong!')
        end
        % normalize by vector length.
        scores(ii, jj) = r(ii, jj)/(sqrt(sum(A_eff(:).^2)) * sqrt(sum(B_eff(:).^2)));
    end
end

scores(:,1:6) = 0; scores(:,end-6:end) = 0;

%% align them by time 0. 

%%
row = min([size(A, 1), size(B, 1)]);
[highest_score, col] = max(scores(row, :));
% [highest_score, idx]= max(scores(:));
% [row, col] = ind2sub(size(r), idx);

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