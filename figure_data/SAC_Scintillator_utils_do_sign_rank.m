
function p_values = SAC_Scintillator_utils_do_sign_rank(data, which_side)
n = size(data, 2);
p_values = zeros(n, 1);
for ii = 1:1:n
    p_values(ii) = signrank(data(:, ii), 0, 'tail', which_side);
%     p_values(ii) = signrank(data(:, ii));

end

bofferroni_n = (n - 1) * 2;
p_values = p_values * bofferroni_n;
disp(['Statistics with Sign Rank test, single tail-', which_side]);
disp(['Bonferroni Correction n = ', num2str(bofferroni_n), 'Since dt = 0 is not tested']);
disp(num2str(p_values));
end
