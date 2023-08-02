stim_name = 'grating_8_direction';
cell_name_all = SAC_GetFiles_GivenStimulus(stim_name);
process_movie_flag = 0;
if process_movie_flag
    for ii = 1:1:length(cell_name_all)
        SAC_PreProcess_5D_Movie(cell_name_all{ii});
    end
end

%%
epoch_str = {'E', 'NE', 'N', 'NW', 'W', 'SW', 'S', 'SE'};
directions = linspace(0, 1, 9) * 2 * pi;
directions = directions(1:8);
%%
epoch_ID = (1:8)';
resp = SAC_GetResponse_OneStim(stim_name);

for ii = 1:1:length(cell_name_all)
    gratings_plot_one_branch(resp(ii), epoch_str, directions);
    sgtitle(['Recording: ', cell_name_all(ii)], 'Interpreter', 'none');
    MySaveFig_Juyue(gcf, 'SAC_gratings_', cell_name_all{ii}, 'nFigSave',2,'fileType',{'png','fig'});
end
