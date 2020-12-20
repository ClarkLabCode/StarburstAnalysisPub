% finalTitle = ['Progressive Positive ' num2str(numROIs(1)) sprintf(',%d', numROIs(2:end))];
% finalTitle = ['Progressive Positive'];
% progPosPrefDir = 'L+'; % Remember that we're in a left dominated world
% progPosNullDir = 'R+';
% uncorrBarsEpoch = strcmp(epochNames, 'Uncorrelated Bars');
% if ~any(uncorrBarsEpoch)
%     prefUncorrBarsEpoch = strcmp(epochNames, 'L Uncorrelated Bars');
%     nullUncorrBarsEpoch = strcmp(epochNames, 'R Uncorrelated Bars');
%     uncorrBarsEpoch = [find(prefUncorrBarsEpoch) find(nullUncorrBarsEpoch)];
% else
%     uncorrBarsEpoch = [find(uncorrBarsEpoch) find(uncorrBarsEpoch)];
% end
% progPosPrefEpochs = cellfun(@(foundInds) ~isempty(foundInds) && foundInds(1)==1, strfind(epochNames, progPosPrefDir));
% progPosNullEpochs = cellfun(@(foundInds) ~isempty(foundInds) && foundInds(1)==1, strfind(epochNames, progPosNullDir));
% prefEpochs = find(progPosPrefEpochs);
% nullEpochs = find(progPosNullEpochs);
prefEpochs = analysis.prefEpochs;
nullEpochs = analysis.nullEpochs;
subplotNums = {2, 2, 1};

snipShift = -2000; % For time traces--we start plotting 2000ms before the start of the correlated noise stimulus
duration = 8000; % For time traces--we stop plotting 8000ms after we start plotting; correlated noise stimuli are 4s long, so we stop plotting 2000ms after they stop showing


tVals = linspace(snipShift, snipShift+duration, size(52, 1));
dataX = 1:8;
finalTitle = ['Progressive Positive'];

averagedFliesTime = [];
averagedFliesTimeSem = [];
PlotAllCurves(subplotNums, tVals, dataX, prefEpochs, nullEpochs, finalTitle,...
    averagedFliesTime, averagedFliesTimeSem, resp.respMatIndPlot, resp.respMatPlot, resp.respMatSemPlot,...
    resp.respMatDiffPlot, resp.respMatDiffIndPlot, resp.respMatDiffSemPlot,...
    resp.respMatUncorrDiffIndPlot, resp.respMatUncorrDiffSemPlot, 'prefPosNullNeg');

