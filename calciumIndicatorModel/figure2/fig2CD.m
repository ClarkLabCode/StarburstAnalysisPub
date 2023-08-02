close all
addpath(genpath('../src'))
save=0;
saveDir='test';
tag='test';
rng(5);
stdev=0.5;
av=0;
timeStepSize=0.1; % ms
runTime=100e3; %ms
stimFreq=200; %Hz
tau=0.05e3; %ms
filtLength=1e3; %ms
[KdG,nG,tauG,DrG]=getConstants("GCaMP");
[KdO,nO,tauO,DrO]=getConstants("OBG");

t = [0:timeStepSize:filtLength];
time=defineTime(runTime,timeStepSize);
startTime=0.001*runTime;
filtFunc=@(t) t.*exp(-t/tau);
filt=defineFilter(time,filtLength,filtFunc);
filt=timeStepSize.*filt./(sum(filt).*timeStepSize);
sum(filt);
%% Random 1d Noise 
samplingTimes=mod((time.*stimFreq/1000)-0.5,1)==0;
sampleIndices=find(samplingTimes);
stimTEST=1.*(time>=startTime);
startFrame=find(stimTEST,1,'first');
stim=makeGausDistStim(time,stimFreq,startTime,stdev,av);
% stim(1:startFrame)=ones(size(stim(1:startFrame)));
response=filter(filt,1,stim);

% response=response./mean(response);
% response(1:startFrame+length(filt)*timeStepSize)=mean(response);

% 
figure, hold on
subplot(4,1,1)
plot(time(1:3e3/timeStepSize),stim(1:3e3/timeStepSize))
xline(startTime);
% figure, hold on 
% plot(time(1:3e3/timeStepSize),response(1:3e3/timeStepSize))
% xline(startTime);
factor=[0.33 1 3];

for i=1:length(factor)
    C0=factor(i).*KdG;
    responseWithBase=(1+0.5.*response./std(response))*C0;
    calciumG(:,i)=responseWithBase-responseWithBase.*(responseWithBase<0);
    [FG(:,i),dFG(:,i)]=caToF(calciumG(:,i),timeStepSize,startTime,"GCaMP",save,saveDir,tag);
    thisDF=dFG(:,i);
    [coeffG(:,i),timeLagG(:,i)]=findCorrCoeff_T(1000/stimFreq,stim(sampleIndices),thisDF(sampleIndices),filtLength,0,'test','test');

    C0=factor(i).*KdO;
    responseWithBase=(1+0.5.*response./std(response))*C0;
    calciumO(:,i)=responseWithBase-responseWithBase.*(responseWithBase<0);
    [FO(:,i),dFO(:,i)]=caToF(calciumO(:,i),timeStepSize,startTime,"OBG",save,saveDir,tag);
    thisDF=dFO(:,i);
    [coeffO(:,i),timeLagO(:,i)]=findCorrCoeff_T(1000/stimFreq,stim(sampleIndices),thisDF(sampleIndices),filtLength,0,'test','test');
end
subplot(4,1,2)
plot(time(1:3e3/timeStepSize),calciumG(1:3e3/timeStepSize,:)./KdG);    

subplot(4,1,3)
plot(time(1:3e3/timeStepSize),dFO(1:3e3/timeStepSize,1),time(1:3e3/timeStepSize),dFO(1:3e3/timeStepSize,2),time(1:3e3/timeStepSize),dFO(1:3e3/timeStepSize,3))
subplot(4,1,4)
plot(time(1:3e3/timeStepSize),dFG(1:3e3/timeStepSize,1),time(1:3e3/timeStepSize),dFG(1:3e3/timeStepSize,2),time(1:3e3/timeStepSize),dFG(1:3e3/timeStepSize,3))



coeffO=timeStepSize.*coeffO./(sum(coeffO).*(filtLength/length(coeffO)));
coeffG=timeStepSize.*coeffG./(sum(coeffG).*(filtLength/length(coeffG)));
coeffO=coeffO./max(coeffO);
coeffG=coeffG./max(coeffG);

filt=filt./max(filt);

figure
%OBG1d
subplot(1,2,1)
plot(timeLagO(100:end,1),coeffO(100:end,1),timeLagO(100:end,2,1),coeffO(100:end,2),timeLagO(100:end,3),coeffO(100:end,3),t(1:5000),filt(1:5000),'-')
xticks([0:200:5000]);
xticklabels('');
legend("C_0=0.33K_D","C_0=K_D","C_0=3K_D","Original Filter")
legend boxoff
xlim([0 500])
% ylim([-0.05 1.05])
title('OGB')
box off

%gcamp1d
subplot(1,2,2)
plot(timeLagG(100:end,1,1),coeffG(100:end,1),timeLagG(100:end,2,1),coeffG(100:end,2),timeLagG(100:end,3,1),coeffG(100:end,3),t(1:5000),filt(1:5000),'-')
title('GCaMP6f')
xticks([0:200:5000]);
xticklabels([0:200:5000]./1000);
xlim([0 500])
% ylim([-0.05 1.05])
box off
