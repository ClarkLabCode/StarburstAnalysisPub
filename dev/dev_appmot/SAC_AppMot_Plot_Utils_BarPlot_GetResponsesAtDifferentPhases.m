function [resp_ave_this, resp_sem_this, resp_ind_this, color_this] = ...
    SAC_AppMot_Plot_Utils_BarPlot_GetResponsesAtDifferentPhases(resp_ave, resp_sem, resp_ind, epoch_index, color)
n_phase = length(epoch_index);
resp_ave_this = zeros(n_phase, 1);
resp_sem_this = zeros(n_phase, 1);
resp_ind_this = zeros(n_phase, size(resp_ind, 3));
color_this = repmat(color, [n_phase, 1]);
for ll = 1:1:n_phase
    epoch_over_X_this = epoch_index(ll);
    resp_ave_this(ll) = resp_ave(epoch_over_X_this);
    resp_sem_this(ll) = resp_sem(epoch_over_X_this);
    resp_ind_this(ll, :)  = resp_ind(epoch_over_X_this, :);
end

end