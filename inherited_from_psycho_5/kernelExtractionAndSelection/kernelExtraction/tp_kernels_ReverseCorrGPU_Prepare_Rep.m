function [respDataGPU,stimDataGPU,numElementsSummed,stimDataVar] = tp_kernels_ReverseCorrGPU_Prepare_Rep(respData,stimIndexes,stimData,maxTau,repStimIndInFrame);
nRoi = length(respData);
nT = size(stimData,1);
nMultiBars = size(stimData,2);
respDataGPUMat = zeros(nT,nRoi);
numElementsSummed = zeros(nRoi,1);
startingPoint = zeros(nRoi,1);
endingPoint = zeros(nRoi,1);

repStimPlusMaxTau = bsxfun(@plus,repmat((1:1:maxTau)',1,size(repStimIndInFrame,2)),repStimIndInFrame(end,:));
repStimAll = cat(1,repStimIndInFrame,repStimPlusMaxTau);
repStimAll = repStimAll(:);
%if the repStimAll is longer than stimulus, cut it. the  The repeated segments has not stop when the experiments ceased. 
repStimAll(repStimAll >= nT) = [];
for rr = 1:1:nRoi
    respDataMeanSub = respData{rr} - mean(respData{rr});
    respDataGPUMat(stimIndexes{rr},rr) = single(respDataMeanSub);
    respDataGPUMat(repStimAll,rr) = zeros(size(repStimAll)); % necessary...over lapping...
    
    startingPoint(rr) = stimIndexes{rr}(1);
    endingPoint(rr) = stimIndexes{rr}(end);
end

startingPointAll = max(startingPoint) + 2 * maxTau;
endingPointAll = min(endingPoint);

for rr = 1:1:nRoi
    numRep = ismember(stimIndexes{rr},uint32(repStimAll));
    % you should also minus the point where there is a huge movement. 
    numElementsSummed(rr) = sum(stimIndexes{rr} <= endingPointAll & stimIndexes{rr} >= startingPointAll & ~numRep);
end
respDataGPUMat = respDataGPUMat(startingPointAll:endingPointAll,:);
% numElementsSummed = sum(respDataGPUMat~=0)'; % should be the same as the
% above calculation. double check.

%very bad... you should keep your zero to zero...
% respDataGPUMat = respDataGPUMat - repmat(mean(respDataGPUMat),[size(respDataGPUMat,1),1]);
respDataGPU{1} = single(respDataGPUMat);
% stim
stimDataGPU = cell(1,nMultiBars);
stimDataGPUMat = stimData;

stimDataGPUMat = stimDataGPUMat(startingPointAll:endingPointAll,:);
stimDataGPUMat = stimDataGPUMat - repmat(mean(stimDataGPUMat),[size(stimDataGPUMat,1),1]);
stimDataVar = var(stimDataGPUMat);
for qq = 1:1:nMultiBars
    stimDataGPU{qq} = single(repmat(stimDataGPUMat(:,qq),[1,nRoi]));
end
