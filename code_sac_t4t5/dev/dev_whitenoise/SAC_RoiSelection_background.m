function L = SAC_RoiSelection_background(I)
%% line by line background.
% percentile? 
    %% dark-dark region for control.
    fractionCutOff = 1;
    threshold = prctile(I(:),fractionCutOff);
    L = I < threshold;
    %show_roi_mask(I, L);
end