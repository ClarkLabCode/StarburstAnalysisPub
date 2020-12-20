function [movie_bckg_sub, bckg_mask] = SAC_BlackgroundSubtraction(movie, dimThreshLevel)
plot_flag = 1;

%% get darkest pixels in each line
mean_f = mean(mean(cat(3, movie{:}), 3), 4);
bckg_mask = zeros(size(mean_f));
for ii = 1:size(mean_f, 1)
    dimThresh = percentileThreshMatrix(mean_f(ii, :),dimThreshLevel);
    bckg_mask(ii, :) = mean_f(ii, :) < dimThresh;
end

if plot_flag
    bckg_mask_plot = zeros(size(bckg_mask));
    for ii = 1:1:size(bckg_mask, 1)
        bckg_mask_plot(ii, :) = double(bckg_mask(ii,:)) * ii;
    end
    show_roi_mask(mean_f,  bckg_mask_plot);
    sgtitle('background rois')
end

%% get the bleedthrough movie.
n_epoch = length(movie);
movie_size = size(movie{1});
bckg_movie = cell(n_epoch, 1);
for ee = 1:1:n_epoch
    bckg_movie{ee} = zeros([movie_size(1), 1, movie_size(3), movie_size(4)]);
    for rr = 1:1:movie_size(1) - 1
        n_pixel = sum(bckg_mask(rr, :));
        bckg_movie{ee}(rr, :, :, :) = sum(movie{ee}(rr,:,:,:).* bckg_mask(rr, :), 2)/n_pixel;
    end
end

%% background subtacted raw fluorescence
movie_bckg_sub = cell(n_epoch, 1);
for ee = 1:1:n_epoch
    movie_bckg_sub{ee} = movie{ee} - repmat(bckg_movie{ee}, [1, movie_size(2), 1, 1]);
end

end
