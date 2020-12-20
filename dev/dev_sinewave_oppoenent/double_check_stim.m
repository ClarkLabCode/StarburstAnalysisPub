load('D:\Dropbox\BorghuisClark - SAC Calcium\stimulus_parameter\C4_sinusoid_opponent.mat')

MakeFigure;
for ii = 1:24
    subplot(3, 8, ii)
    imagesc(squeeze(cont(:,:,ii)));
    colormap(gray);
    colorbar;
end