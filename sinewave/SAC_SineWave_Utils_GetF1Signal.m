function resp_ind_cell = SAC_SineWave_Utils_GetF1Signal(resp, fVals)
[on_set, off_set, ~] = SAC_SineWave_Utils_AverageOverTime_CalOnOffIdx(1,fVals);

n_cell = length(resp);
for nn = 1:1:n_cell
    [~, n_trial, n_epoch, n_rois] = size(resp{nn});
    resp_ind_cell{nn} = zeros(1, n_trial, n_epoch, n_rois);
    for ee = 1:1:n_epoch
        resp_ind_cell{nn}(1,:,ee,:,:) = get_f1_component(resp{nn}(on_set(ee):off_set(ee),:,ee,:), fVals(ee));
        
    end
end


end

function [ans] = get_f1_component(resp, freq)
fs = 15.6250;
L = length(resp);

P2 = abs(fft(resp)); % two-sided spectrum.
P1 = P2((1:L/2 + 1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
[~, idx] = min(abs(f - freq));

ans = P1(idx);
end