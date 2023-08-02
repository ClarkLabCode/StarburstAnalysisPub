function [red, green] = SAC_utils_load_raw_movie_5D_movie(file)
    data = load(file);
    green = double(data.stim.frames(:,:,2,:,:));
    red   = double(data.stim.frames(:,:,1,:,:));
    if length(size(green)) == 5
        green = squeeze(permute(green, [1, 2, 5, 4, 3]));
        red = squeeze(permute(red, [1, 2, 5, 4, 3]));
    end
end