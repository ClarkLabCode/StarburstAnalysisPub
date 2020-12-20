function SAC_Plot_Utils_PlotSigPoint(axis,pval,alpha_1, alpha_2, alpha_3, plotVerValue, showPValueFlag)
% how many points,
pPlotStar = pval < alpha_1;
pPlotDoubleStar = pval < alpha_2;
pPlotTripleStar = pval < alpha_3;


hold on
single_star = '*';

text(axis(pPlotStar)-0.02, ones(1,sum(pPlotStar)) * plotVerValue, single_star,...
    'HorizontalAlignment','Center');
text(axis(pPlotDoubleStar)-0.02, ones(1,sum(pPlotDoubleStar)) * plotVerValue * 1.1, single_star,...
    'HorizontalAlignment','Center');
text(axis(pPlotTripleStar)-0.02, ones(1,sum(pPlotTripleStar)) * plotVerValue * 1.2, single_star,...
    'HorizontalAlignment','Center');

hold off

if showPValueFlag
    for ii = 1:1:length(axis)
        text(axis(ii),plotVerValue *  1.5,['p:',num2str(pval(ii))],'Rotation',90);
    end
end
end