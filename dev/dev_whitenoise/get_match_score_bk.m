function [score, idx_A, idx_B] = get_match_score(A, B)
%%
% A = [0, 0, 0;
%      0, 1, 0;
%      0, 1, 0;
%      0, 0, 0];
% B = [0, 0, 1;
%      0, 0, 1;
%      0, 0, 1];

%% find the largest cross-correlation. should normalize first before max...
r = xcorr2(A, B);
[value, idx]= max(abs(r(:)));
[row, col] = ind2sub(size(r), idx);
row_in_A = row - size(B, 1);
col_in_A = col - size(B, 2); % idx represents where to put B(1, 1) in coordinates of A.

%% normalize by the vector length.

% find out the maxtrix being used.
row_start_A = max([row_in_A, 0]) + 1;
row_start_B = max([-row_in_A, 0]) + 1;
row_length = min([size(A, 1) - row_start_A, size(B, 1) - row_start_B]);

col_start_A = max([col_in_A, 0]) + 1;
col_start_B = max([-col_in_A, 0]) + 1;
col_length = min([size(A, 2) - col_start_A, size(B, 2) - col_start_B]);

A_eff = A(row_start_A:row_start_A + row_length, col_start_A : col_start_A + col_length);
B_eff = B(row_start_B:row_start_B + row_length, col_start_B: col_start_B + col_length);

tmp = A_eff .* B_eff;
if (abs(sum(tmp(:))) - value) > 1e-1
    error('wrong!')
end

% normalize by vector length.
score = value/(sqrt(sum(A_eff(:).^2)) * sqrt(sum(B_eff(:).^2)));
idx_A = [row_start_A, row_start_A + row_length - 1; col_start_A, col_start_A + col_length - 1];
idx_B = [row_start_B, row_start_B + row_length - 1; col_start_B, col_start_B + col_length - 1];
end

