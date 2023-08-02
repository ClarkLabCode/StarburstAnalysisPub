
function PlotAllCurves(subplotNums, tVals, dataX, prefEpochs, nullEpochs, finalTitle, averagedFliesTime, averagedFliesTimeSem, respMatIndPlot, respMatPlot, respMatSemPlot, respMatDiffPlot, respMatDiffIndPlot, respMatDiffSemPlot, respMatUncorrDiffIndPlot, respMatUncorrDiffSemPlot, prefNullCombo)
% Plot all the curves in one bundle!
% dt1Epoch = find([params(nullEpochs).delay]==1, 1, 'first');
dt1Epoch = 14;
MakeFigure;
subplot(subplotNums{:});
PlotSemCurves(dataX, prefEpochs, nullEpochs, finalTitle, respMatIndPlot, respMatPlot, respMatSemPlot, respMatDiffPlot, respMatDiffSemPlot, respMatUncorrDiffIndPlot, respMatUncorrDiffSemPlot, prefNullCombo);
%  PlotSemCurves(dataX, prefEpochs, nullEpochs, finalTitle, respMatIndPlot, respMatUncorrDiffPlot, respMatUncorrDiffSemPlot, respMatDiffPlot, respMatDiffSemPlot, respMatUncorrDiffPlot, respMatUncorrDiffSemPlot, prefNullCombo);

% Not needed for paper!
%  figure(plotFigureIndividualFlies);
%  subplot(subplotNums{:});
%  PlotIndividualFlies(dataX, finalTitle, respMatPlot, respMatIndPlot, prefEpochs,nullEpochs)

% Not needed for paper!
%  figure(plotFigureDiffSem)
%  subplot(subplotNums{:});
%  PlotDiffSemCurves(dataX, prefEpochs, finalTitle, respMatDiffPlot, respMatDiffSemPlot, respMatDiffIndPlot);

% subplot(subplotNums{:});
% PlotTimeTraces(tVals, finalTitle, averagedFliesTime,averagedFliesTimeSem,prefEpochs, nullEpochs, dt1Epoch)
end

function PlotSemCurves(dataX, prefEpochs, nullEpochs, finalTitle, respMatIndPlot, respMatPlot, respMatSemPlot, respMatDiffPlot, respMatDiffSemPlot, respMatUncorrDiffIndPlot, respMatUncorrDiffSemPlot, prefNullCombo)
% Plots dem SEM curves!
zUnpaired = (respMatPlot(prefEpochs(1:end-1), :)-respMatPlot(nullEpochs(1:end-1), :))./sqrt(respMatSemPlot(prefEpochs(1:end-1), :).^2+respMatSemPlot(nullEpochs(1:end-1), :).^2);
zPrefUncorr = (respMatPlot(prefEpochs(1:end-1), :)-respMatPlot(prefEpochs(end), :))./sqrt(respMatSemPlot(prefEpochs(1:end-1), :).^2+respMatSemPlot(prefEpochs(end), :).^2);
zNullUncorr = (respMatPlot(nullEpochs(1:end-1), :)-respMatPlot(nullEpochs(end), :))./sqrt(respMatSemPlot(nullEpochs(1:end-1), :).^2+respMatSemPlot(nullEpochs(end), :).^2);
zPaired = (respMatDiffPlot(prefEpochs(1:end-1), :))./sqrt(respMatDiffSemPlot(prefEpochs(1:end-1), :).^2);
%  zPrefUncorr = (respMatUncorrDiffIndPlot(prefEpochs(1:end-1), :))./sqrt(respMatUncorrDiffSemPlot(prefEpochs(1:end-1), :).^2);
%  zNullUncorr = (respMatUncorrDiffIndPlot(nullEpochs(1:end-1), :))./sqrt(respMatUncorrDiffSemPlot(nullEpochs(1:end-1), :).^2);
%  zVals = [zPrefUncorr zNullUncorr zUnpaired zPaired];
% Plot null as negative dt values
switch prefNullCombo
    case 'bothPos'
        % Plot pref and null on top of each other
        PlotXvsY(dataX(1:end)',[respMatPlot(prefEpochs(1:end-1),:) respMatPlot(nullEpochs(1:end-1),:) repmat(respMatPlot(nullEpochs(end),:), length(dataX), 1)],'error',[respMatSemPlot(prefEpochs(1:end-1),:) respMatSemPlot(nullEpochs(1:end-1),:) repmat(respMatSemPlot(nullEpochs(end),:), length(dataX), 1)], 'color', [1 0 0; 0 0 1; .5 .5 .5]);
    case 'prefPosNullNeg'
        currAx = gca;
        if isempty(currAx.findobj('Type', 'ErrorBar'))
            colorLines = [1 0 0; 0.5 0.5 0.5];
        else
            colorLines = [0 0 1; 0.5 0.5 0.5];
        end
        PlotXvsY(dataX(1:end)',[[respMatPlot(nullEpochs(end-1:-1:2),:); respMatPlot(prefEpochs(1:end-1),:)] repmat(respMatPlot(nullEpochs(end),:), length(dataX), 1)],'error',[[respMatSemPlot(nullEpochs(end-1:-1:2),:); respMatSemPlot(prefEpochs(1:end-1),:)] repmat(respMatSemPlot(nullEpochs(end),:), length(dataX), 1)], 'color', colorLines);
end



%  for zValInd = 1:length(dataX)-1
%      text(dataX(zValInd),respMatPlot(prefEpochs(1)), sprintf('%0.2d\\newline ', zVals(zValInd,:)), 'Rotation', 45, 'FontSize', 5)
%  end
%  text(dataX(end), respMatPlot(end), 'Z Pref\newline Z Null\newline Z Unpaired\newline Z Paired');

dataPointsPref = respMatPlot(prefEpochs,:);
dataPointsPrefSem = respMatSemPlot(prefEpochs,:);
dataPointsNull = respMatPlot(nullEpochs,:);
dataPointsNullSem = respMatSemPlot(nullEpochs,:);
zPrefUncorr = abs(zPrefUncorr);
zNullUncorr = abs(zNullUncorr);
dataPointsComboBest = [dataPointsPref(zPrefUncorr>2)+dataPointsPrefSem(zPrefUncorr>2); dataPointsNull(zNullUncorr>2)+dataPointsNullSem(zNullUncorr>2)];
dataPointsComboBestSem = [dataPointsPrefSem(zPrefUncorr>2); dataPointsNullSem(zNullUncorr>2)];
[maxVal, maxInd] = max(dataPointsComboBest);

comparisonNum = length(nullEpochs)+length(prefEpochs)-2; % subtract 2 for uncorrelated epochs
pThresh = 0.05;
pThresh = pThresh/comparisonNum;
zThresh = norminv(1-pThresh);

pThreshStrict = 0.01;
pThreshStrict = pThreshStrict/comparisonNum;
zThreshStrict = norminv(1-pThreshStrict);

% TTEST!
%  [~, pPrefUncorr] = ttest(respMatIndPlot(prefEpochs(1:end-1), :)', respMatIndPlot(prefEpochs(end)*ones(length(prefEpochs)-1, 1), :)'); %2 is index of CIS epoch
%  [~, pNullUncorr] = ttest(respMatIndPlot(nullEpochs(1:end-1), :)', respMatIndPlot(nullEpochs(end)*ones(length(prefEpochs)-1, 1), :)'); %2 is index of CIS epoch
% Signrank test
for i = 1:length(prefEpochs(1:end-1))
    pPrefUncorr(i) = signrank(respMatIndPlot(prefEpochs(i), :)', respMatIndPlot(prefEpochs(end), :)'); % end is uncorr epoch response
    pNullUncorr(i) = signrank(respMatIndPlot(nullEpochs(i), :)', respMatIndPlot(nullEpochs(end), :)'); % end is uncorr epoch response
    %     pPrefNullAbs(i) = signrank(respMatUncorrDiffIndPlot(prefEpochs(i), :)', -respMatUncorrDiffIndPlot(nullEpochs(i), :)');
    pPrefNullAbs(i) = signrank(respMatIndPlot(prefEpochs(i), :)' - respMatIndPlot(prefEpochs(end), :)', -(respMatIndPlot(nullEpochs(i), :)' - respMatIndPlot(nullEpochs(end), :)'));
end


dataPointsComboAll = [dataPointsPref+dataPointsPrefSem; dataPointsNull+dataPointsNullSem];
dataPointsComboAllSem = [dataPointsPrefSem; dataPointsNullSem];
[maxOverall, maxOverallInd] = max(dataPointsComboAll);

maxVal = maxOverall;
shiftUp = dataPointsComboAllSem(maxOverallInd);

plotY = maxVal + shiftUp;
switch prefNullCombo
    case 'bothPos'
        
        % Preferred
        % Sign rank p-threshold
        text(dataX(pPrefUncorr<pThresh & pPrefUncorr>pThreshStrict), plotY*ones(sum(pPrefUncorr<pThresh & pPrefUncorr>pThreshStrict), 1), '*', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [1 0 0]);
        text(dataX(pPrefUncorr<pThreshStrict), plotY*ones(sum(pPrefUncorr<pThreshStrict), 1), '**', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [1 0 0]);
        % Z-threshold (not used anymore)
        %     text(dataX(zPrefUncorr>zThresh & zPrefUncorr<zThreshStrict), plotY*ones(sum(zPrefUncorr>zThresh & zPrefUncorr<zThreshStrict), 1), '*', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [1 0 0]);
        %     text(dataX(zPrefUncorr>zThreshStrict), plotY*ones(sum(zPrefUncorr>zThreshStrict), 1), '**', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [1 0 0]);
        % p-values in text
        %         text(dataX(1:end-1), plotY*ones(length(dataX)-1, 1), strcat('p=',cellfun(@num2str, num2cell(pPrefUncorr), 'UniformOutput', false)), 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [1 0 0], 'Rotation', 70);
        
        % Null
        % Sign rank p-threshold
        text(dataX(pNullUncorr<pThresh & pNullUncorr>pThreshStrict), (plotY+shiftUp)*ones(sum(pNullUncorr<pThresh & pNullUncorr>pThreshStrict), 1), '*', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 1]);
        text(dataX(pNullUncorr<pThreshStrict), (plotY+shiftUp)*ones(sum(pNullUncorr<pThreshStrict), 1), '**', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 1]);
        % Z-threshold (not used anymore)
        %     text(dataX(zNullUncorr>zThresh & zNullUncorr<zThreshStrict), (plotY+shiftUp)*ones(sum(zNullUncorr>zThresh & zNullUncorr<zThreshStrict), 1), '*', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 1]);
        %     text(dataX(zNullUncorr>zThreshStrict), (plotY+shiftUp)*ones(sum(zNullUncorr>zThreshStrict), 1), '**', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 1]);
        % p-values in text
        %         text(dataX(1:end-1), (plotY+shiftUp)*ones(length(dataX)-1, 1), strcat('p=',cellfun(@num2str, num2cell(pNullUncorr), 'UniformOutput', false)), 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 1], 'Rotation', 70);
        
        %         text(dataX(1:end), (plotY+2*shiftUp)*ones(length(dataX), 1), strcat('p=',cellfun(@num2str, num2cell(pPrefNullAbs), 'UniformOutput', false)), 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 1 0], 'Rotation', 70);
        
    case 'prefPosNullNeg'
        % Combine preferred and null
        %         text(dataX(1:end), (plotY+shiftUp)*ones(length(dataX), 1), strcat('p=',cellfun(@num2str, num2cell([pNullUncorr(end:-1:2) pPrefUncorr]), 'UniformOutput', false)), 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 0], 'Rotation', 70);
end

currAx = axis;
if currAx(end) < plotY + 2*shiftUp;
    currAx(end) = plotY + 2*shiftUp;
    axis(currAx);
end

hold on;
PlotConstLine(dataPointsNull(end),1);

ConfAxis('fTitle',finalTitle);%ConfAxis(varargin{:},'labelX',labelX,'labelY',[yAxis],'fTitle',finalTitle);
%  legend({'Preferred\newline ** Z>3 from uncorr\newline * Z>2 from uncorr', 'Null\newline ** Z>3 from uncorr\newline * Z>2 from uncorr'})
legend({'Preferred', 'U', 'U', 'Null'}, 'Location', 'NorthEastOutside')
text(0, 0, sprintf('** p<%0.1d from uncorr\\newline * p<%0.1d from uncorr', pThreshStrict, pThresh), 'VerticalAlignment', 'bottom',  'HorizontalAlignment', 'left');

end

function PlotDiffSemCurves(dataX, prefEpochs, finalTitle, respMatDiffPlot, respMatDiffSemPlot, respMatDiffIndPlot)
% Diff sem plots!
dataX = dataX(dataX>=0);
zPaired = (respMatDiffPlot(prefEpochs(1:end-1), :))./sqrt(respMatDiffSemPlot(prefEpochs(1:end-1), :).^2);


currAx = gca;
if isempty(currAx.findobj('Type', 'ErrorBar'))
    colorLines = [1 0 0];
else
    colorLines = [0 0 1];
end
PlotXvsY(dataX',respMatDiffPlot(prefEpochs,:),'error',respMatDiffSemPlot(prefEpochs,:), 'color', colorLines);
hold on
dataPoints = respMatDiffPlot(prefEpochs,:);
dataPointsSem = respMatDiffSemPlot(prefEpochs,:);
zPaired = abs(zPaired);
[maxVal, maxInd] = max(dataPoints(zPaired>2)+dataPointsSem(zPaired>2));

comparisonNum = length(prefEpochs)-1; % subtract 1 for uncorrelated epoch
pThresh = 0.05;
pThresh = pThresh/comparisonNum;
zThresh = norminv(1-pThresh);

pThreshStrict = 0.01;
pThreshStrict = pThreshStrict/comparisonNum;
zThreshStrict = norminv(1-pThreshStrict);

for i = 1:length(prefEpochs(1:end-1))
    pPrefUncorr(i) = signtest(respMatDiffIndPlot(prefEpochs(i), :)', respMatDiffIndPlot(prefEpochs(end), :)'); % end is uncorr epoch response
    %     pNullUncorr(i) = signtest(respMatDiffIndPlot(nullEpochs(i), :)', respMatDiffIndPlot(nullEpochs(end), :)'); % end is uncorr epoch response
end


if ~isempty(maxVal)
    plotY = maxVal + dataPointsSem(maxInd);
    %      text(dataX(pPrefUncorr<pThresh & pPrefUncorr>pThreshStrict), plotY*ones(sum(pPrefUncorr<pThresh & pPrefUncorr>pThreshStrict), 1), '*', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 0]);
    %      text(dataX(pPrefUncorr<pThreshStrict), plotY*ones(sum(pPrefUncorr<pThreshStrict), 1), '**', 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 0]);
    text(dataX(1:end-1), plotY*ones(length(dataX)-1, 1), strcat('p=',cellfun(@num2str, num2cell(pPrefUncorr), 'UniformOutput', false)), 'FontSize', 10, 'HorizontalAlignment', 'center', 'Color', [0 0 0], 'Rotation', 90);
    
    currAx = axis;
    if currAx(end) < plotY + dataPointsSem(maxInd);
        currAx(end) = plotY + dataPointsSem(maxInd);
        axis(currAx);
    end
end
ConfAxis('fTitle',finalTitle);
legend({sprintf('Preferred-Null')}, 'Location', 'NorthEastOutside');
text(0, 0, sprintf('** p<%0.1d from uncorr\\newline * p<%0.1d from uncorr', pThreshStrict, pThresh), 'VerticalAlignment', 'bottom',  'HorizontalAlignment', 'left');

end

function PlotTimeTraces(tVals, finalTitle, averagedFliesTime,averagedFliesTimeSem,prefEpochs, nullEpochs, dt1Epoch)
% Time traces!
colorsPref = bsxfun(@times, (1-((1:length(prefEpochs))-1)/length(prefEpochs))', repmat([1 0 0], length(prefEpochs),1));
colorsNull = bsxfun(@times, (1-((1:length(nullEpochs))-1)/length(nullEpochs))', repmat([0 0 1], length(nullEpochs),1));
colors = [colorsPref; colorsNull];
timeTraces = cat(2, averagedFliesTime{1}{[prefEpochs(dt1Epoch) nullEpochs([dt1Epoch end])]});
timeTraceErrors = cat(2, averagedFliesTimeSem{1}{[prefEpochs(dt1Epoch) nullEpochs([dt1Epoch end])]});
PlotXvsY(tVals', timeTraces, 'error', timeTraceErrors, 'color', [colors([1 length(prefEpochs)+1], :); 0 1 0 ]);
ConfAxis('fTitle',finalTitle);
legend({'dt=1 preferred', 'dt=1 null', 'Uncorrelated Epochs'});
end

function PlotIndividualFlies(dataX, finalTitle, respMatPlot, respMatIndPlot, prefEpochs,nullEpochs)
% Individual flies dt sweep!
% Plot mean twice--first for legend, then to be on top in graph
numFlies = size(respMatIndPlot, 2);
if length(dataX) == 2*(length(prefEpochs)-1)
    dataToPlot = [ respMatPlot([nullEpochs(end-1:-1:2) prefEpochs],:) respMatIndPlot([nullEpochs(end-1:-1:2) prefEpochs], :) respMatPlot([nullEpochs(end-1:-1:2) prefEpochs],:)];
    currAx = gca;
    if isempty(currAx.findobj('Type', 'ErrorBar'))
        colors = [ 1 0 0; repmat([1 .8 .8], numFlies, 1); 1 0 0];
    else
        colors = [ 0 0 1; repmat([.8 .8 1], numFlies, 1); 0 0 1];
    end
else
    dataToPlot = [ respMatPlot(prefEpochs,:) respMatPlot(nullEpochs,:) respMatIndPlot(prefEpochs, :) respMatIndPlot(nullEpochs, :) respMatPlot(prefEpochs,:) respMatPlot(nullEpochs,:)];
    colors = [ 1 0 0; 0 0 1;repmat([1 .8 .8], numFlies, 1); repmat([.8 .8 1], numFlies, 1); 1 0 0; 0 0 1];
end
if length(dataX) == 1
    dataX = dataX * ones(size(dataToPlot));
end
if ~isempty(dataToPlot)
    PlotXvsY(dataX', dataToPlot, 'color', colors);
    ConfAxis('fTitle',finalTitle);%ConfAxis(varargin{:},'labelX',labelX,'labelY',[yAxis],'fTitle',finalTitle, 'MarkerStyle','*');
    legend({'Preferred', 'Null', 'Individual Fly'})
end
end