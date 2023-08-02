function T4T5_Scintillator_Utils_Replot_Dev(resp)
%% significance point.
alpha = 0.05;
%%
x_axis_dt = ([0:6 12]')/60*1000;
n_dir = 2;
n_par = 2;
color_bank = [[1,0,0];[0,0,1]]; % for positive and negative.
lineStyle_bank = {':','-.'}; % for prefered and null

title_str = {'Positive', 'Negative'};
MakeFigure;
for pp = 1:1:n_par
    % two directions.
    subplot(2, 4, pp);
    color_use = color_bank(pp,:);
    for dd = 1:1:n_dir
        resp_ave_this = resp{pp}{dd}.resp_ave;
        resp_sem_this = resp{pp}{dd}.resp_sem;
        lineStyle_use = lineStyle_bank{dd};
        
        PlotXY_Juyue(x_axis_dt, resp_ave_this,'errorBarFlag',1,'sem',resp_sem_this,...
            'colorMean', color_use, 'colorError',color_use, 'lineStyle', lineStyle_use); hold on;
        %         set(gca,'YLim',[0,0.2]);
    end
    xlabel('\Delta t (ms)');
    ylabel('\DeltaF /F');
    title(title_str{pp});
    legend('preferred', 'null');
    ConfAxis('fontSize', 12);
end

%% next, averaged the polarity first. add significant point.
subplot(2, 4,3);
for pp = 1:1:n_par
    color_use = color_bank(pp,:);
    
    resp_ave_this = resp{pp}{3}.resp_ave;
    resp_sem_this = resp{pp}{3}.resp_sem;
    [~, p_value_this,~] = ttest(squeeze(resp{pp}{3}.resp_ind)');
    PlotXY_Juyue(x_axis_dt,resp_ave_this,'errorBarFlag',1,'sem',resp_sem_this,...
        'colorMean', color_use, 'colorError',color_use); hold on;
    SAC_Plot_Utils_PlotSigPoint(x_axis_dt,resp_ave_this,p_value_this,alpha,false);
%     FigPlot_SK_Utils_GliderSignificance(x_axis_dt,p_value_this, alpha, maxValue ,false);
end
xlabel('\Delta t (ms)');
ylabel('\DeltaF /F');
legend('positive', 'negative');
title('preferred - null');
ConfAxis('fontSize', 12);

end
