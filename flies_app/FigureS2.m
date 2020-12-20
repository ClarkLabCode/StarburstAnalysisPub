function FigureS2
%% Code for Figure S2ABCEF; Figure S2D was drawn in Illustrator

%% Figure S2A
% T4 Progressive will be plotted first, then T5 progressive; this includes
% their responses to apparent motion stimuli and next-nearest neighbor
% stimuli

roiExtractionFile = 'IcaRoiExtraction';
roiSizeIcaMin = 5;

stimulusResponseAlignment = false;
secondsInterleaveUse = .1;
subInterleaveBarPair = false;
plotIndividualROIs = false;
plotIndividualFlies = false;
plotFlyAverage = true;
pauseForManyPlots = true;
snipShift =  -200;
duration = 1400;
%%%%
barToCenter = 2;
calculateModelMatrix = false;
esiThreshesCell = {0.3, 0.3, 0.4, 0.4}; % Includes T4 Prog/Reg, then T5 Prog/Reg
% This is to show that higher thresholds are fine
% esiThreshCell = {0.5, 0.5, 0.6, 0.6};
epochsForIdentification = {'Still', 'Square Left', 'Square Right', 'Square Up', 'Square Down', 'Left Light Edge', 'Left Dark Edge','Right Light Edge', 'Right Dark Edge'};
ignoreNeighboringBars = false; % This is the default; we're just making sure it's set here except for the one case where we're combining old and new data
figurePlotName = 'BarTraces';
traceColor = [1 0 0];
plottingFunction = 'PlotBarPairROISummary';
% traceColor = [1 0 0];
% plottingFunction = 'PlotBarPairROISummaryColormapAsTraces';
% plottingFunction = 'PlotBarPairROISummarySpaceMean';
% plottingFunction = 'PlotBarPairROISummaryTrace';
% traceColor = {[1 0 .5], [1 0.64 .5], [0 .5 1], [1 .5 1]};
% plottingFunction = 'PlotBarPairROISummaryPoint';
% traceColor = [1 0 0];
% plottingFunction = 'PlotBarPairROISummaryPointMotIncrease';
% plottingFunction = 'PlotBarPairROISummarySpacetimeMeanPoint';
% plottingFunction = 'PlotBarPairROISummarySpaceTimeMean';
% plottingFunction = 'PlotBarPairRectTest';

roiSelectionFile = 'SelectEdgeResponsiveRois';

% ---- T4 Single ROI Fly -----
% Fly ID 549, ROI 19 is a good progressive T4 fly for single bar
dataPathsBarPair = GetPathsFromDatabase('T4T5', {'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave', 'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave_blockRepeat', 'barPair_5dBars_8p_150msD_1sOn_1sInt_neighFlash'}, 'GC6f', '', '', 'expressionSystemName', 'in', {'GAL4-UAS', 'Split GAL4-UAS'}, 'genotype', 'not like', '%GluCli%', 'date', '<', '2017 October 23', 'flyId', '=', '549');
epochsForSelectivity = {'Left Light Edge', 'Left Dark Edge', 'Right Light Edge', 'Right Dark Edge'};
esiThreshCell = esiThreshesCell{1};
plotIndividualROIs = 19;
plotFlyAverage = false;
pauseForManyPlots = false;
ignoreNeighboringBars = true;
figureNames = {'Figure S2A Prog T4'};
figureNamePrepend = 'Single Roi ';
% ----------------------------

repeatDataPreprocess = false;
varsToIgnoreForReprocess = {'analysisFile', 'plottingFunction', 'traceColor', 'figureName', 'ignoreNeighboringBars', 'calculateModelMatrix', 'barToCenter', 'duration', 'snipShift', 'plotIndividualROIs', 'plotIndividualFlies', 'subInterleaveBarPair', 'plotFlyAverage', 'pauseForManyPlots', 'stimulusResponseAlignment'};


figureName = strcat(figureNames, {figureNamePrepend});

epochsToPlot = [];
numIgnore = 13;
combOpp = 0;
plotTime = [0 1000];
varsToIgnoreForReprocess = [varsToIgnoreForReprocess 'combOpp', 'numIgnore', 'plotTime', 'epochsToPlot'];

barPairIndAnalyses = RunAnalysis('dataPath', dataPathsBarPair, 'analysisFile', {'BarPairNewCompiledRoiAnalysis'}, 'figureName', figureName, 'progRegSplit', true, 'plotIndividualROIs', plotIndividualROIs, 'plotIndividualFlies', plotIndividualFlies, 'plotFlyAverage', plotFlyAverage, 'pauseForManyPlots', pauseForManyPlots, 'stimulusResponseAlignment', stimulusResponseAlignment, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelectivity, 'snipShift', snipShift, 'duration', duration, 'subInterleaveBarPair', subInterleaveBarPair, 'secondsInterleaveUse', secondsInterleaveUse, 'forceRois', false, 'roiSelectionFile', roiSelectionFile, 'plottingFunction', plottingFunction, 'barToCenter', barToCenter, 'traceColor', traceColor, 'figurePlotName', figurePlotName, 'calculateModelMatrix', calculateModelMatrix, 'ignoreNeighboringBars', ignoreNeighboringBars, 'esiThresh', esiThreshCell, 'repeatDataPreprocess', repeatDataPreprocess, 'filterWatershed', true, 'roiSizeIcaMin', roiSizeIcaMin, 'varsToIgnoreForReprocess', varsToIgnoreForReprocess);

imgAx = [];axParents = [];
for i = 1:length(barPairIndAnalyses.analysis)
    imgAx = [imgAx barPairIndAnalyses.analysis{i}.allImgAx];
    axes(imgAx(end)); colorbar;
    axParents = [axParents unique([barPairIndAnalyses.analysis{i}.allImgAx.Parent])];
end


% For T4 data
minCT4 = min(min([imgAx(1:8).findobj('Type', 'Image').CData]));
maxCT4 = max(max([imgAx(1:8).findobj('Type', 'Image').CData]));

[axParents(1:end/2).Colormap] = deal(colormap(b2r(minCT4, maxCT4)));
[imgAx(1:end/2).CLim] = deal([minCT4 maxCT4]);

% ---- T5 Single ROI Fly -----
% Fly ID 506, ROI 3 is a good progressive T5 fly for single bar
dataPathsBarPair = GetPathsFromDatabase('T4T5', {'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave', 'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave_blockRepeat', 'barPair_5dBars_8p_150msD_1sOn_1sInt_neighFlash'}, 'GC6f', '', '', 'expressionSystemName', 'in', {'GAL4-UAS', 'Split GAL4-UAS'}, 'genotype', 'not like', '%GluCli%', 'date', '<', '2017 October 23', 'flyId', '=', '506');
epochsForSelectivity = {'Left Dark Edge', 'Left Light Edge', 'Right Dark Edge', 'Right Light Edge'};
esiThreshCell = esiThreshesCell{3};
plotIndividualROIs = 3;
plotFlyAverage = false;
pauseForManyPlots = false;
ignoreNeighboringBars = true;
figureNames = {'Figure S2A Prog T5'};
figureNamePrepend = 'Single Roi ';
% ----------------------------

figureName = strcat(figureNames, {figureNamePrepend});

barPairIndAnalyses = RunAnalysis('dataPath', dataPathsBarPair, 'analysisFile', {'BarPairNewCompiledRoiAnalysis'}, 'figureName', figureName, 'progRegSplit', true, 'plotIndividualROIs', plotIndividualROIs, 'plotIndividualFlies', plotIndividualFlies, 'plotFlyAverage', plotFlyAverage, 'pauseForManyPlots', pauseForManyPlots, 'stimulusResponseAlignment', stimulusResponseAlignment, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelectivity, 'snipShift', snipShift, 'duration', duration, 'subInterleaveBarPair', subInterleaveBarPair, 'secondsInterleaveUse', secondsInterleaveUse, 'forceRois', false, 'roiSelectionFile', roiSelectionFile, 'plottingFunction', plottingFunction, 'barToCenter', barToCenter, 'traceColor', traceColor, 'figurePlotName', figurePlotName, 'calculateModelMatrix', calculateModelMatrix, 'ignoreNeighboringBars', ignoreNeighboringBars, 'esiThresh', esiThreshCell, 'repeatDataPreprocess', repeatDataPreprocess, 'filterWatershed', true, 'roiSizeIcaMin', roiSizeIcaMin, 'varsToIgnoreForReprocess', varsToIgnoreForReprocess);

imgAx = [];axParents = [];
for i = 1:length(barPairIndAnalyses.analysis)
    imgAx = [imgAx barPairIndAnalyses.analysis{i}.allImgAx];
    axes(imgAx(end)); colorbar;
    axParents = [axParents unique([barPairIndAnalyses.analysis{i}.allImgAx.Parent])];
end

% For T5 data
minCT5 = min(min([imgAx(1:8).findobj('Type', 'Image').CData]));
maxCT5 = max(max([imgAx(1:8).findobj('Type', 'Image').CData]));

[axParents(end/2+1:end).Colormap] = deal(colormap(b2r(minCT5, maxCT5)));
[imgAx(end/2+1:end).CLim] = deal([minCT5 maxCT5]);

%% Figure S2B and S2C
% Here, responses to all stimuli from both progressive and regressive T4
% and T5 will be plotted,  S2B has only the single bar responses from
% progressive T4 and T5, along with the space averages on the right of each
% response, and S2C has all the apparent motion responses from both cell
% types
roiExtractionFile = 'IcaRoiExtraction';
roiSizeIcaMin = 5;

stimulusResponseAlignment = false;
secondsInterleaveUse = .1;
subInterleaveBarPair = false;
plotIndividualROIs = false;
plotIndividualFlies = false;
plotFlyAverage = true;
pauseForManyPlots = true;
snipShift =  -200;
duration = 1400;
%%%%
barToCenter = 2;
calculateModelMatrix = false;
esiThreshCell = {0.3, 0.3, 0.4, 0.4};
% This is to show that higher thresholds are fine
% esiThreshCell = {0.5, 0.5, 0.6, 0.6};
epochsForIdentification = {'Still', 'Square Left', 'Square Right', 'Square Up', 'Square Down', 'Left Light Edge', 'Left Dark Edge','Right Light Edge', 'Right Dark Edge'};
ignoreNeighboringBars = false; % This is the default; we're just making sure it's set here except for the one case where we're combining old and new data
figurePlotName = 'BarTraces';
traceColor = [1 0 0];
% plottingFunction = 'PlotBarPairROISummary';
% traceColor = [1 0 0];
% plottingFunction = 'PlotBarPairROISummaryColormapAsTraces';
% plottingFunction = 'PlotBarPairROISummarySpaceMean';
% plottingFunction = 'PlotBarPairROISummaryTrace';
% traceColor = {[1 0 .5], [1 0.64 .5], [0 .5 1], [1 .5 1]};
% plottingFunction = 'PlotBarPairROISummaryPoint';
% traceColor = [1 0 0];
% plottingFunction = 'PlotBarPairROISummaryPointMotIncrease';
% plottingFunction = 'PlotBarPairROISummarySpacetimeMeanPoint';
plottingFunction = 'PlotBarPairROISummarySpaceTimeMean';
% plottingFunction = 'PlotBarPairRectTest';
epochsForSelectivity = {...
    'Left Light Edge', 'Left Dark Edge', 'Right Light Edge', 'Right Dark Edge';...
    'Right Light Edge', 'Right Dark Edge', 'Left Light Edge', 'Left Dark Edge';...
    'Left Dark Edge', 'Left Light Edge', 'Right Dark Edge', 'Right Light Edge';...
    'Right Dark Edge', 'Right Light Edge', 'Left Dark Edge', 'Left Light Edge'...
    };
roiSelectionFile = 'SelectEdgeResponsiveRois';
figureNames = {'Prog T4', 'Reg T4', 'Prog T5', 'Reg T5'};

% --------All Data------------
dataPathsBarPair = GetPathsFromDatabase('T4T5', {'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave', 'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave_blockRepeat', 'barPair_5dBars_8p_150msD_1sOn_1sInt_neighFlash'}, 'GC6f', '', '', 'expressionSystemName', 'in', {'GAL4-UAS', 'Split GAL4-UAS'}, 'genotype', 'not like', '%GluCli%', 'date', '<', '2017 October 23');
dataPathsBarPair([26]) = []; % Ignoring this file because it had weird timing problems
ignoreNeighboringBars = true;
figureNamePrepend = 'Figure S2BC ';

% Skip processing of flies
repeatDataPreprocess = false;
varsToIgnoreForReprocess = {'analysisFile', 'plottingFunction', 'traceColor', 'figureName', 'ignoreNeighboringBars', 'calculateModelMatrix', 'barToCenter', 'duration', 'snipShift', 'plotIndividualROIs', 'plotIndividualFlies', 'subInterleaveBarPair', 'plotFlyAverage', 'pauseForManyPlots', 'stimulusResponseAlignment'};


figureName = strcat({figureNamePrepend}, figureNames);

epochsToPlot = [];
numIgnore = 13;
combOpp = 0;
plotTime = [0 1000];
varsToIgnoreForReprocess = [varsToIgnoreForReprocess 'combOpp', 'numIgnore', 'plotTime', 'epochsToPlot'];

% barPairIndAnalyses = RunAnalysis('dataPath', dataPathsBarPair, 'analysisFile', {'PlotTimeTraces'}, 'figureName', figureName, 'progRegSplit', true, 'numIgnore', numIgnore, 'combOpp', combOpp, 'epochsToPlot', epochsToPlot, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelectivity, 'snipShift', snipShift, 'duration', duration, 'subInterleaveBarPair', subInterleaveBarPair, 'secondsInterleaveUse', secondsInterleaveUse, 'forceRois', false, 'roiSelectionFile', roiSelectionFile, 'plottingFunction', plottingFunction, 'barToCenter', barToCenter, 'traceColor', traceColor, 'figurePlotName', figurePlotName, 'calculateModelMatrix', calculateModelMatrix, 'ignoreNeighboringBars', ignoreNeighboringBars, 'esiThresh', esiThreshCell, 'repeatDataPreprocess', repeatDataPreprocess, 'filterWatershed', true, 'roiSizeIcaMin', roiSizeIcaMin, 'varsToIgnoreForReprocess', varsToIgnoreForReprocess);
barPairIndAnalyses = RunAnalysis('dataPath', dataPathsBarPair, 'analysisFile', {'BarPairNewCompiledRoiAnalysis'}, 'figureName', figureName, 'progRegSplit', true, 'plotIndividualROIs', plotIndividualROIs, 'plotIndividualFlies', plotIndividualFlies, 'plotFlyAverage', plotFlyAverage, 'pauseForManyPlots', pauseForManyPlots, 'stimulusResponseAlignment', stimulusResponseAlignment, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelectivity, 'snipShift', snipShift, 'duration', duration, 'subInterleaveBarPair', subInterleaveBarPair, 'secondsInterleaveUse', secondsInterleaveUse, 'forceRois', false, 'roiSelectionFile', roiSelectionFile, 'plottingFunction', plottingFunction, 'barToCenter', barToCenter, 'traceColor', traceColor, 'figurePlotName', figurePlotName, 'calculateModelMatrix', calculateModelMatrix, 'ignoreNeighboringBars', ignoreNeighboringBars, 'esiThresh', esiThreshCell, 'repeatDataPreprocess', repeatDataPreprocess, 'filterWatershed', true, 'roiSizeIcaMin', roiSizeIcaMin, 'varsToIgnoreForReprocess', varsToIgnoreForReprocess);
% barPairIndAnalyses = RunAnalysis('dataPath', dataPathsBarPair, 'analysisFile', {'PlotRoisOnMask'}, 'progRegSplit', true, 'plotIndividualROIs', plotIndividualROIs, 'plotIndividualFlies', plotIndividualFlies, 'roiExtractionFile',roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelectivity, 'snipShift', -500, 'duration', 2000, 'forceRois', false, 'roiSelectionFile', roiSelectionFile, 'getUniqueFliesFlag', false, 'repeatDataPreprocess', repeatDataPreprocess, 'filterWatershed', true, 'ignoreNeighboringBars', ignoreNeighboringBars, 'secondsInterleaveUse', secondsInterleaveUse, 'filterWatershed', true, 'roiSizeIcaMin', roiSizeIcaMin );
imgAx = [];tmAx = [];spcAx = [];spctmAx = [];axParents = [];
for i = 1:length(barPairIndAnalyses.analysis)
    imgAx = [imgAx barPairIndAnalyses.analysis{i}.allImgAx];
    axes(imgAx(end)); colorbar;
    tmAx = [tmAx barPairIndAnalyses.analysis{i}.allTmAvgAx];
    spcAx = [spcAx barPairIndAnalyses.analysis{i}.allSpcAvgAx];
    spctmAx = [spctmAx barPairIndAnalyses.analysis{i}.allSpctmAvgAx];
    axParents = [axParents unique([barPairIndAnalyses.analysis{i}.allImgAx.Parent])];
end
% axParents = unique([imgAx.Parent]);


imgBetCT = length(imgAx)/4;
% Below is for raw data
minCT4 = min(min([imgAx([1:8]+[0:imgBetCT:end/2-1]').findobj('Type', 'Image').CData]));
maxCT4 = max(max([imgAx([1:8]+[0:imgBetCT:end/2-1]').findobj('Type', 'Image').CData]));
minCT5 = min(min([imgAx([1:8]+[end/2:imgBetCT:end-1]').findobj('Type', 'Image').CData]));
maxCT5 = max(max([imgAx([1:8]+[end/2:imgBetCT:end-1]').findobj('Type', 'Image').CData]));
% Below is for linear models
% minCT4 = min(min([imgAx([43:50]+[0:imgBetCT:end/2-1]').findobj('Type', 'Image').CData]));
% maxCT4 = max(max([imgAx([43:50]+[0:imgBetCT:end/2-1]').findobj('Type', 'Image').CData]));
% minCT5 = min(min([imgAx([43:50]+[end/2:imgBetCT:end-1]').findobj('Type', 'Image').CData]));
% maxCT5 = max(max([imgAx([43:50]+[end/2:imgBetCT:end-1]').findobj('Type', 'Image').CData]));

mnTAx = min([tmAx.YLim]);% = deal([-0.2 0.4]);
mxTAx = max([tmAx.YLim]);

mnSAx = min([spcAx.YLim]);
mxSAx = max([spcAx.YLim]);

mnSTAx = min([spctmAx.YLim]);
mxSTAx = max([spctmAx.YLim]);

[axParents(1:end/2).Colormap] = deal(colormap(b2r(minCT4, maxCT4)));
[imgAx(1:end/2).CLim] = deal([minCT4 maxCT4]);
[axParents(end/2+1:end).Colormap] = deal(colormap(b2r(minCT5, maxCT5)));
[imgAx(end/2+1:end).CLim] = deal([minCT5 maxCT5]);

[tmAx.YLim] = deal([mnTAx mxTAx]);
[spcAx.YLim] = deal([mnSAx mxSAx]);
[spctmAx.YLim] = deal([mnSTAx mxSTAx]);

%% Figure S2D
% Drawn in Illustrator

%% Figure S2E
% This requires the code from Figure S2B and S2C to be run. Six plots come
% out but only the fourth and fifth ones ('... progPosNeg...' and '...
% regPosNeg...') are published in the paper. Note that the resulting plots
% are mirrored on both axes from what was published because of the
% semantics of the presentation, but show that the overlap of second phases
% is the maximum correlation!

barPairAnalysisStructs = [barPairIndAnalyses.analysis{:}];
allRoiResps = cat(3, barPairAnalysisStructs.roiResps);
allRoiModelResps = cat(3, barPairAnalysisStructs.roiModelResps);
numRois = arrayfun(@(x) sum(x.numROIs), barPairAnalysisStructs);

params = barPairAnalysisStructs(1).params;
numPhases = barPairAnalysisStructs(1).numPhases;
optimalResponseField = 'PlusSingle'; %This isn't really true, as different ROIs will have different optima, but it's only for plotting...
plotPlots = false;
[allRoiCovarStruct, allRoiRespStruct] = BarPairCovarianceAnalysis(allRoiResps, allRoiModelResps, params, optimalResponseField, snipShift, duration, barToCenter, numPhases, numRois, figureNamePrepend, plotPlots);

covarTaken = 'meanSecondBarPres';

covarMat = allRoiCovarStruct.(covarTaken);
respMat = allRoiRespStruct.(covarTaken);
numPerCellType = numRois;

figName = ['Figure S2E ' covarTaken];
respInts = 1:numPhases*8;

covarMat = covarMat(respInts, respInts);
respMat = respMat(:, respInts);


% Var analysis
BarPairVarExplainedAnalysis(covarMat, respMat, numPerCellType, numPhases, figName);

%% Figure S2F
% Only the apparent motion responses were published from the following
% (specifically the 'Real Figure S2F...' plots)
roiExtractionFile = 'IcaRoiExtraction';
roiSizeIcaMin = 5;

stimulusResponseAlignment = false;
secondsInterleaveUse = .1;
subInterleaveBarPair = false;
plotIndividualROIs = false;
plotIndividualFlies = false;
plotFlyAverage = true;
pauseForManyPlots = true;
snipShift =  -200;
duration = 1400;
%%%%
barToCenter = 2;
calculateModelMatrix = false;
% This is to show that higher thresholds are fine
esiThreshCell = {0.5, 0.5, 0.6, 0.6};
epochsForIdentification = {'Still', 'Square Left', 'Square Right', 'Square Up', 'Square Down', 'Left Light Edge', 'Left Dark Edge','Right Light Edge', 'Right Dark Edge'};
ignoreNeighboringBars = false; % This is the default; we're just making sure it's set here except for the one case where we're combining old and new data
figurePlotName = 'BarTracesHigherEsi';

plottingFunction = 'PlotBarPairROISummaryTrace';
traceColor = {[1 0 .5], [1 0.64 .5], [0 .5 1], [1 .5 1]};
epochsForSelectivity = {...
    'Left Light Edge', 'Left Dark Edge', 'Right Light Edge', 'Right Dark Edge';...
    'Right Light Edge', 'Right Dark Edge', 'Left Light Edge', 'Left Dark Edge';...
    'Left Dark Edge', 'Left Light Edge', 'Right Dark Edge', 'Right Light Edge';...
    'Right Dark Edge', 'Right Light Edge', 'Left Dark Edge', 'Left Light Edge'...
    };
roiSelectionFile = 'SelectEdgeResponsiveRois';
figureNames = {'Prog T4', 'Reg T4', 'Prog T5', 'Reg T5'};

% --------All Data------------
dataPathsBarPair = GetPathsFromDatabase('T4T5', {'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave', 'barPair_5degBars_8phases_150msDelay_1sOn_1sInterleave_blockRepeat', 'barPair_5dBars_8p_150msD_1sOn_1sInt_neighFlash'}, 'GC6f', '', '', 'expressionSystemName', 'in', {'GAL4-UAS', 'Split GAL4-UAS'}, 'genotype', 'not like', '%GluCli%', 'date', '<', '2017 October 23');
dataPathsBarPair([26]) = []; % Ignoring this file because it had weird timing problems
ignoreNeighboringBars = true;
figureNamePrepend = ' Figure S2F ';

% Skip processing of flies
repeatDataPreprocess = false;
varsToIgnoreForReprocess = {'analysisFile', 'plottingFunction', 'traceColor', 'figureName', 'ignoreNeighboringBars', 'calculateModelMatrix', 'barToCenter', 'duration', 'snipShift', 'plotIndividualROIs', 'plotIndividualFlies', 'subInterleaveBarPair', 'plotFlyAverage', 'pauseForManyPlots', 'stimulusResponseAlignment'};


figureName = strcat({figureNamePrepend}, figureNames);

epochsToPlot = [];
numIgnore = 13;
combOpp = 0;
plotTime = [0 1000];
varsToIgnoreForReprocess = [varsToIgnoreForReprocess 'combOpp', 'numIgnore', 'plotTime', 'epochsToPlot'];

barPairIndAnalyses = RunAnalysis('dataPath', dataPathsBarPair, 'analysisFile', {'BarPairNewCompiledRoiAnalysis'}, 'figureName', figureName, 'progRegSplit', true, 'plotIndividualROIs', plotIndividualROIs, 'plotIndividualFlies', plotIndividualFlies, 'plotFlyAverage', plotFlyAverage, 'pauseForManyPlots', pauseForManyPlots, 'stimulusResponseAlignment', stimulusResponseAlignment, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelectivity, 'snipShift', snipShift, 'duration', duration, 'subInterleaveBarPair', subInterleaveBarPair, 'secondsInterleaveUse', secondsInterleaveUse, 'forceRois', false, 'roiSelectionFile', roiSelectionFile, 'plottingFunction', plottingFunction, 'barToCenter', barToCenter, 'traceColor', traceColor, 'figurePlotName', figurePlotName, 'calculateModelMatrix', calculateModelMatrix, 'ignoreNeighboringBars', ignoreNeighboringBars, 'esiThresh', esiThreshCell, 'repeatDataPreprocess', repeatDataPreprocess, 'filterWatershed', true, 'roiSizeIcaMin', roiSizeIcaMin, 'varsToIgnoreForReprocess', varsToIgnoreForReprocess);


