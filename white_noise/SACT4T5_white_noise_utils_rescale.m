function B_q = SACT4T5_white_noise_utils_rescale(B, ratio)

F = griddedInterpolant(B);
F.Method = 'cubic';
[n_row, n_col] = size(B);
row_q = (1:ratio(1):n_row)';
col_q = (1:ratio(2):n_col)';
B_q  = F({row_q, col_q});
end
