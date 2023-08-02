%% set up workspace
clc
clear 
close all
addpath(genpath('src'))

%% Parameters 
save=0;
saveDir='test';
tag='test';
rng(5);
stdev=1;
av=0;
timeStepSize=0.1; % ms
runTime=100e3; %ms
stimFreq=200; %Hz
tau=0.05e3; %ms
filtLength=1e3; %ms
stdFactor=0.25;
avFactor=0.5;
[KdG,nG,tauG,DrG]=getConstants("GCaMP");
[KdO,nO,tauO,DrO]=getConstants("OBG");
%% define filter
t = [0:timeStepSize:filtLength];
time=defineTime(runTime,timeStepSize);
filtFunc=@(t) t.*exp(-t/tau);
filt=defineFilter(time,filtLength,filtFunc);
%% Random 1d Noise 
samplingTimes=mod((time.*stimFreq/1000)-0.5,1)==0;
sampleIndices=find(samplingTimes);
for j=1:10
startTime=0.001*runTime;
stim=makeGausDistStim(time,stimFreq,startTime,stdev,av);



%% Apply filter 

response=filter(filt,1,stim);
response=response-mean(response);


factor=[0.33 1 3];

for i=1:length(factor)
%% calibrate for CO
    C0=factor(i).*KdG;
    responseWithBase=(1+0.5.*response./std(response))*C0;
    calciumG(:,i,j)=responseWithBase-responseWithBase.*(responseWithBase<0);
    
%% Run Simulation GCaMP 
    [FG(:,i,j),dFG(:,i,j)]=caToF(calciumG(:,i,j),timeStepSize,startTime,"GCaMP",save,saveDir,tag);
    
%% Reverse Correlate GCaMP 
    thisDF=dFG(:,i,j);
    [coeffG(:,i,j),timeLagG(:,i,j)]=findCorrCoeff_T(1000/stimFreq,stim(sampleIndices),thisDF(sampleIndices),filtLength,0,'test','test');    
%     [coeffG(:,i,j),timeLagG(:,i,j)]=findCorrCoeff_T(timeStepSize,stim,dFG(:,i,j),filtLength,0,'test','test');
%% calibrate for CO    
    C0=factor(i).*KdO;
    responseWithBase=(1+0.5.*response./std(response))*C0;
    calciumO(:,i,j)=responseWithBase-responseWithBase.*(responseWithBase<0);  
%% Run Simulation OBG
    
    [FO(:,i,j),dFO(:,i,j)]=caToF(calciumO(:,i,j),timeStepSize,startTime,"OBG",save,saveDir,tag);
    
%% Reverse Correlate OGB
    thisDF=dFO(:,i,j);
    [coeffO(:,i,j),timeLagO(:,i,j)]=findCorrCoeff_T(1000/stimFreq,stim(sampleIndices),thisDF(sampleIndices),filtLength,0,'test','test');
%     [coeffO(:,i,j),timeLagO(:,i,j)]=findCorrCoeff_T(1,stim,dFO(:,i,j),filtLength,0,'test','test');
end
end
coeffO=mean(coeffO,3);
coeffG=mean(coeffG,3);
%% Plot everything 

filtNorm=(filt-min(filt))./(max(filt)-min(filt));
GCampNorm=(coeffG-min(coeffG))./(max(coeffG)-min(coeffG));
OBGNorm=(coeffO-min(coeffO))./(max(coeffO)-min(coeffO)); 




%% grouped figure 

fig=figure,hold on;

subplot(4,1,1)
plot(time(1:3e3/timeStepSize),stim(1:3e3/timeStepSize))
ylabel('input')
xticks([0:500:3000]);
xticklabels('');
box off

subplot(4,1,2)
plot(time(1:3e3/timeStepSize),calciumO(1:3e3/timeStepSize,:,1)./KdO);
ylabel('Ca^{+}/Kd')
xticks([0:500:3000]);
xticklabels('');
box off

subplot(4,1,3)
plot(time(1:3e3/timeStepSize),dFO(1:3e3/timeStepSize,:,1))
ylabel('OGB \Delta F/F')
xticks([0:500:3000]);
xticklabels('');
box off

subplot(4,1,4)
plot(time(1:3e3/timeStepSize),dFG(1:3e3/timeStepSize,:,1))
ylabel('GCaMP \Delta F/F')
box off
xticks([0:500:3000]);
xticklabels([0:500:10000]./1000);


omg=gcf();
han=axes(fig,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
%han.YLabel.Visible='on';
%ylabel(han,'yourYLabel');
xlabel(han,'time (s)');
%title(han,'yourTitle');
% subplot(5,1,7)
% plot(timeLagO(:,:,1),OBGNorm)
% plot(t,filtNorm,"--")
% 
% subplot(5,1,8)
% plot(timeLagG(:,:,1),GCampNorm)
% plot(t,filtNorm,"--")


figure, hold on;
subplot(2,1,2)
plot(timeLagG(:,1,1),GCampNorm(:,1),timeLagG(:,2,1),GCampNorm(:,2),timeLagG(:,3,1),GCampNorm(:,3),t,filtNorm,'--')
title('GCaMP')
xticks([0:200:10000]);
xticklabels([0:200:10000]./1000);
xlabel('time (s)')
box off

subplot(2,1,1)
plot(timeLagO(:,1,1),OBGNorm(:,1),timeLagO(:,2,1),OBGNorm(:,2),timeLagO(:,3,1),OBGNorm(:,3),t,filtNorm,'--')
xticks([0:200:10000]);
xticklabels('');


legend("C0=0.33Kd","C0=Kd","C0=3Kd","Original Filter")
title('OBG')
box off





%% new thing 

% avdFG=mean(dFG,1);
% avdFO=mean(dFO,1);
% 
% maxG=max(dFG);
% maxO=max(dFO);
% 
% dataOt=avdFO./maxO;
% dataGt=avdFG./maxG;
% dataO=reshape(dataOt,[3,100]);
% dataG=reshape(dataGt,[3,100]);

% 
% xO=factor.*KdO; 
% stderrorO= std( dataO );
% stderrorG= std( dataG ) ./ sqrt( length( dataG ));
% 
% curve1O = y + stderrorO;
% curve2O = y - stderrorO;
% x2O = [xO, fliplr(xO)];
% inBetweenO = [curve1O, fliplr(curve2O)];
% 
% curve1G = y + stderrorG;
% curve2G = y - stderrorG;
% x2G = [xG, fliplr(xG)];
% inBetweenG = [curve1G, fliplr(curve2G)];

% 
% figure, hold on
% 
% 
% 
% plot(factor.*KdO,mean(avdFO./maxO,3))
% 
% plot(factor.*KdG,mean(avdFG./maxG,3))
% 
% plot(factor.*KdO,dataO,'.')
% 
% plot(factor.*KdG,dataG,'.')
% 
% legend('OBG',"GCaMP")
% xlabel('C0 Value')
% ylabel('<\Delta F/F>/max(\Delta F/F>)')