function plot_raw_dfoverf(resp_f)
fs = 15.6250;
t = (0:size(resp_f, 1)-1)/fs;
stim_onset = 1; % 1 second.
%% plot raw time traces, averaged over three trials.
% MakeFigure;
% mean_resp = squeeze(mean(mean(resp_f, 4), 2));
% max_f = max(mean_resp(:));
% min_f = min(mean_resp(:));
% n_epoch = size(mean_resp, 2);
% n_epoch = min(n_epoch, 24);
%
% for ii = 1:1:n_epoch
%     subplot(4, 6, ii);
%     plot(t, mean_resp(:, ii),'k-');
%     set(gca, 'YLim', [min_f, max_f]);
%     hold on;
%     plot([stim_onset, stim_onset], get(gca, 'YLim'), 'k--');
%     title(['Epoch:', num2str(ii)]);
% end

%% response for each trial.
MakeFigure;
color_bank = brewermap(3, 'Accent');
n_trial = size(resp_f, 2);
mean_resp = mean(resp_f, 4); % averaged over rois.
n_epoch = size(resp_f, 3);
% n_epoch = min(n_epoch, 24);

max_f = max(mean_resp(:));
min_f = min(mean_resp(:));
for ii = 1:1:n_epoch
    if n_epoch == 24
        subplot(3, 8, ii);
    end
    if n_epoch == 60
        subplot(6, 10, ii);
    end
    if n_epoch == 8
        subplot(2, 8, ii);
    end
    if n_epoch == 64 | n_epoch == 58
       subplot(8, 8, ii);
    end
    
    if n_epoch == 16
       subplot(4, 4, ii);
    end
    
    if n_epoch == 5
        subplot(5, 1, ii)
    end
    
    hold on;
    for tt = 1:1:n_trial
        plot(t, mean_resp(:, tt, ii),'color',color_bank(tt, :), 'LineWidth', 2);
    end
    if ii == 1
        legend({'different trials'});
    end
    set(gca, 'YLim', [min_f, max_f]);
    
    line1 = plot([stim_onset, stim_onset], get(gca, 'YLim'), 'k--');
    line1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    title(['Epoch:', num2str(ii)]);
    %     ConfAxis('fontSize', 8);
end

end