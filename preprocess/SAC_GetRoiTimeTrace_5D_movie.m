function resp = SAC_GetRoiTimeTrace_5D_movie(roi_mask, movie, is_one_roi)
%% data format.
% resp: [time, trial, movie, roi]
n_epoch = length(movie);

if is_one_roi
    roi_mask(roi_mask > 0) = 1;
end

n_roi = max(roi_mask(:));
movie_size = size(movie{1});
n_time = movie_size(4);
n_trial = movie_size(3);
resp = zeros(n_time, n_trial, n_epoch, n_roi);
for rr = 1:1:n_roi
    roimask_this = (roi_mask(:) == rr);
    n_pixel = sum(roimask_this);
    for ee = 1:1:n_epoch
        for tt = 1:1:n_trial
            movie_this = reshape(movie{ee}(:,:,tt,:), movie_size(1)*movie_size(2),n_time)';
            resp(:,tt,ee,rr) = movie_this * roimask_this/n_pixel;
        end
    end
end

if is_one_roi
    resp(:,:,:,1) = resp;
end
end