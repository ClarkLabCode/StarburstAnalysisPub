function edges_main()
% load T4T5
colors_null_pref = {[23,31,89]/100; [89,23,31]/100};
line_style = {'-', '--'};
cell_type = 1;
response = get_response(cell_type);
which_fly = 10;
which_roi = 6;
resp = get_one_fly_one_roi(response, which_fly, which_roi);

resp = squeeze(mean(resp, 2));
MakeFigure;
figure_edges_plot_edges_response(resp, colors, line_style)(resp, colors_null_pref, line_style);

end

function plot_all_flies_rois(response, colors, line_style)
n_flies_used = size(response, 3);
% each fly has different amount of rois. 156. start to end. ignore absolute
% time 0. average three trials together? just plot the first trial.
for ff = 1:1:n_flies_used
    MakeFigure;
    n_roi = size(response{1, 1, ff}, 2);
    for rr = 1:1:n_roi
        
        for dd = 1:1:2
            for pp = 1:1:2
                resp(:, dd, pp) = response{1, (dd-1) * 2 + pp, ff}(1:156, rr);
            end
        end
        subplot(4, 5, rr);
        plot_edges(resp, colors, line_style);
        sgtitle(['fly#', num2str(ff)]);
    end
end
end

