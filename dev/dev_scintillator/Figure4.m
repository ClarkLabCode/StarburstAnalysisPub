function Figure4(forceRois, roisForced)
% Figure 4ABCD -- includes Supplemental Figure 4CD
% -- NOTE 1: the published plot has a significance of 0.01, Bonferroni
%    corrected (two asterisks) for T5 progressive preferred negative dt=2
%    (33 ms) responses. This was a mistake, the significance should
%    actually have been at the 0.05 level, Bonferroni corrected (one star)
% -- NOTE 2: You can always replace the savedAnalysis/ folder with
%    savedAnalysisPaper/ to access the old ROI state them using the
%    function RestorePaperRois
if forceRois
    % This function is a replica of IcaRoiExtraction, but using this under
    % forceRois both preserves previously created ROIs (which would've been
    % done anyway) and also allows us to use paper ROIs when forceRois is
    % set to false
    roiExtractionFile = 'WriteUp_T4T5_IcaRoiExtraction'; % ICA extraction for ROIs, as described in the paper
    if roisForced
        % If new ROIs were already extracted in a previous function, make
        % sure they don't get reextracted here.
        forceRois = false;
    else
        % We ensure here that new ROIs are extracted for all flies, since
        % some flies aren't used for this analysis
        epochsForIdentification =  {'Square Left', 'Square Right', 'Square Up', 'Square Down', 'Left Light Edge', 'Left Dark Edge','Right Light Edge', 'Right Dark Edge'}; % We use the probe epochs for ICA, as they're the most responsive
        dataPathsLMTestT4 = GetPathsFromDatabase('T4T5',{'LDEdge_velSweep_lobulaMedullaTest'},'GC6f','','', 'comments', 'like', '%t4%', 'date', '<', '2016-07-01');
        dataPathsLMTestT5 = GetPathsFromDatabase('T4T5',{'LDEdge_velSweep_lobulaMedullaTest'},'GC6f','','', 'comments', 'like', '%t5%', 'date', '<', '2016-07-01');
        RunAnalysis('dataPath', [dataPathsLMTestT4; dataPathsLMTestT5], 'roiExtractionFile', roiExtractionFileDendrites, 'epochsForIdentification', epochsForIdentification, 'forceRois', forceRois);
    end
else
    % Paper ROIs are used when forceRois is set to false, by setting the
    % original IcaRoiExtraction as the extraction file
    roiExtractionFile = 'IcaRoiExtraction';
end

epochsForIdentification =  {'Square Left', 'Square Right', 'Square Up', 'Square Down', 'Left Light Edge', 'Left Dark Edge','Right Light Edge', 'Right Dark Edge'}; % We use the probe epochs for ICA, as they're the most responsive
roiSelectionFile = 'SelectResponsiveRois';
% epochsForSelection are in the order T4 (the 'Light') progressive (because
% of 'Left'), then T4 regressive ('Right'), T5 ('Dark') progressive, T5
% regressive
epochsForSelection = {'~Left Light Edge', 'Left Dark Edge', 'Right Light Edge', 'Right Dark Edge';'~Right Light Edge', 'Right Dark Edge', 'Left Light Edge', 'Left Dark Edge';'~Left Dark Edge', 'Left Light Edge', 'Right Dark Edge', 'Right Light Edge';'~Right Dark Edge', 'Right Light Edge', 'Left Dark Edge', 'Left Light Edge'};
progRegSplit = true; % Takes care of combining left and right eye surgeries into progressive/regressive splits
overallCorrelationThresh = 0.4; % Selects only ROIs whose correlation threshold is >0.4, as in the main figure of the paper
esiThreshCell = {0.3, 0.3, 0.4, 0.4}; % This is in order of the epochsForSelection--so T4, T4, T5, T5

snipShift = -2000; % For time traces--we start plotting 2000ms before the start of the correlated noise stimulus
duration = 8000; % For time traces--we stop plotting 8000ms after we start plotting; correlated noise stimuli are 4s long, so we stop plotting 2000ms after they stop showing
labelXNum = ([0:6 12])/60*1000; % dt from 0 to 6, then 12 in steps of 16 ms
roundLabel = round(labelXNum, 1); % The label for the above dt values
labelXCell = strsplit(num2str(roundLabel)); % Needs to be in a cell for it to work
labelX = 'Time (ms)'; % x-label
labelY = 'DF/F'; % y-label
plotNameAppend = ' mean per fly'; % Allows us to plot out other Supp Fig 4s without a problem
figureNames = {'STM 60Hz T4'; 'STM 60Hz T4';'STM 60Hz T5';'STM 60Hz T5'}; % Allows us to plot out other Supp Fig 4s without a problem
figureNames = strcat(figureNames, plotNameAppend); % Allows us to plot out other Supp Fig 4s without a problem
analysisFile = 'SweepTwoPhotonAnalysis'; % This is the file we use to analyze the returned data and make the plots

plotOrderChange = false; % Important to get the data in the correct subplots
dataPaths60Pos = GetPathsFromDatabase('T4T5',{'STM_Vdt_up3_180hz_1d','STM_dtSweep_5dbars_60Hz_pos4s_blockRandom'},'GC6f','','');
posAnalysis = RunAnalysis('dataPath', dataPaths60Pos, 'analysisFile', analysisFile, 'figureName', figureNames, 'dataX', labelXNum, 'tickX', labelXNum, 'tickLabelX', labelXCell, 'labelX', labelX, 'labelY', labelY, 'progRegSplit', progRegSplit, 'esiThresh', esiThreshCell, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity',  epochsForSelection, 'snipShift', snipShift, 'duration', duration, 'roiSelectionFile', roiSelectionFile, 'plotOrderChange', plotOrderChange, 'overallCorrelationThresh', overallCorrelationThresh, 'forceRois', forceRois);
T4PosProgNumFlies = length(posAnalysis.analysis{1}.numROIs); % 17
T4PosProgNumRois = sum(posAnalysis.analysis{1}.numROIs); % 102
T4PosRegNumFlies = length(posAnalysis.analysis{2}.numROIs); % 17
T4PosRegNumRois = sum(posAnalysis.analysis{2}.numROIs); % 110
T5PosProgNumFlies = length(posAnalysis.analysis{3}.numROIs); % 19
T5PosProgNumRois = sum(posAnalysis.analysis{3}.numROIs); % 148
T5PosRegNumFlies = length(posAnalysis.analysis{4}.numROIs); % 23
T5PosRegNumRois = sum(posAnalysis.analysis{4}.numROIs); % 216
save('T4T5_scintillator_T4T5_Pos', 'posAnalysis');

plotOrderChange = true; % Important to get the data in the correct subplots
dataPaths60Neg = GetPathsFromDatabase('T4T5',{'STM_Vdt_up3_180hz_1d_rPhi','STM_dtSweep_5dbars_60Hz_neg4s_blockRandom'},'GC6f','','');
negAnalysis = RunAnalysis('dataPath', dataPaths60Neg, 'analysisFile', analysisFile, 'figureName', figureNames, 'dataX', labelXNum, 'tickX', labelXNum, 'tickLabelX', labelXCell, 'labelX', labelX, 'labelY', labelY, 'progRegSplit', progRegSplit, 'esiThresh', esiThreshCell, 'roiExtractionFile', roiExtractionFile,'epochsForIdentification', epochsForIdentification,'epochsForSelectivity', epochsForSelection, 'snipShift', snipShift, 'duration', duration, 'roiSelectionFile', roiSelectionFile, 'plotOrderChange', plotOrderChange, 'overallCorrelationThresh', overallCorrelationThresh, 'forceRois', forceRois);
T4NegProgNumFlies = length(negAnalysis.analysis{1}.numROIs); % 18
T4NegProgNumRois = sum(negAnalysis.analysis{1}.numROIs); % 85
T4NegRegNumFlies = length(negAnalysis.analysis{2}.numROIs); % 16
T4NegRegNumRois = sum(negAnalysis.analysis{2}.numROIs); % 116
T5NegProgNumFlies = length(negAnalysis.analysis{3}.numROIs); % 15
T5NegProgNumRois = sum(negAnalysis.analysis{3}.numROIs); % 140
T5NegRegNumFlies = length(negAnalysis.analysis{4}.numROIs); % 20
T5NegRegNumRois = sum(negAnalysis.analysis{4}.numROIs); % 222
save('T4T5_scintillator_T4T5_Neg', 'posAnalysis');
