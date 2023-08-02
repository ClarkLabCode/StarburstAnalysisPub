
% close all
addpath(genpath('../src'))
clear 
clc
tic
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
factor=1;
startTime=0.001*runTime;
filtLength=2e3; %ms
repCount=5;
lagTime = [filtLength:-1000/stimFreq:0];
loopLength=length(lagTime);
lagList=[loopLength:-1:0];

[KdG,nG,tauG,DrG]=getConstants("GCaMP");
[KdO,nO,tauO,DrO]=getConstants("OBG");

% define filter
t = [0:timeStepSize:filtLength];
time=defineTime(runTime,timeStepSize);
samplingTimes=mod((time.*stimFreq/1000)-0.5,1)==0;
sampleIndices=find(samplingTimes);

x=[-10:1:10];
a=2;
z=2;
b=4;
c=12;
d=1000;
g=.2;
h=.5;
fx1 =@(p) exp(-(p+a).^2./(2*b));
fx2 =@(p) exp(-(p-z).^2./(2*c));
ft1 =@(T) ((2*T/d)-((T.^3)/(g*(d^3)))).*exp(-(T./d)/g);
ft2 =@(T) (T/d).*exp(-(T/d)/h);

filtFuncALL=@(p,T) (ft1(T'))*fx1(p) - 0.5.* (ft2(T'))*fx2(p);

test=250;

% Random 2d Noise 
filt = ft1(t)'*fx1(x) - 0.5* ft2(t)'*fx2(x);
filt = flip(filt);
stim=zeros(length(time),length(x));


top=max(max(filt));
bot=min(min(filt));
r=top-bot;
perc=round(abs(bot)*100/r);
rwb=[linspace(0,1,perc)' linspace(0,1,perc)' ones(perc,1); ones(100-perc,1) linspace(0.98,0,100-perc)' linspace(0.98,0,100-perc)'];

samplingTimes=mod((time.*stimFreq/1000)-0.5,1)==0;
sampleIndices=find(samplingTimes);
stimTEST=1.*(time>=startTime);
startFrame=find(stimTEST,1,'first');

ax1=figure;
imagesc(x,flip(t),filt); 
hold on;
colormap(ax1,rwb);

%%
plotAvG=zeros(length(lagTime),length(x));
plotAvO=zeros(length(lagTime),length(x));
for j=1:repCount
    
    for kk=1:length(x)   
        stim(:,kk)=makeGausDistStim(time,stimFreq,startTime,stdev,av);
        stim(1:startFrame,kk)=ones(size(stim(1:startFrame,kk)));
    end
    
    % Apply filter 
    response=zeros(length(time)-length(filt),1);
    for tt=1:length(time)-length(filt)
        prod=stim(tt:tt+length(filt)-1,:).*filt;
        response(tt+length(filt))=sum(sum(prod));
        
    end
    toc
    % calibrate for CO
        C0=factor.*KdG;
        responseWithBase=(1+0.5.*response./std(response))*C0;
        calciumG=responseWithBase-responseWithBase.*(responseWithBase<0);
        
        C0=factor.*KdO;
        responseWithBase=(1+0.5.*response./std(response))*C0;
        calciumO=responseWithBase-responseWithBase.*(responseWithBase<0);
    % Run Simulation GCaMP 
        [FG,dFG]=caToF(calciumG,timeStepSize,startTime,"GCaMP",save,saveDir,tag);
        [FO,dFO]=caToF(calciumG,timeStepSize,startTime,"OBG",save,saveDir,tag);
        
    %Reverse Correlate GCaMP 
        inputStim=stim(sampleIndices,:)-mean(mean(stim(sampleIndices,:)));
        dFG=dFG(sampleIndices);
        inputdFG=dFG-mean(dFG);
        dFO=dFO(sampleIndices);
        inputdFO=dFO-mean(dFO);
        toc
        for mm=1:loopLength
            LL=-1*lagList(mm);
            newGFilt(mm,:)=regress(circshift(inputdFG,LL),inputStim);
            newOFilt(mm,:)=regress(circshift(inputdFO,LL),inputStim);
        end

        plotAvG=plotAvG+newGFilt;
        plotAvO=plotAvO+newOFilt;
        toc
end





plotAvG=plotAvG/2*j;
plotAvO=plotAvO/2*j;

%%
top=max(max(plotAvG));
bot=min(min(plotAvG));
r=top-bot;
perc=round(abs(bot)*100/r);
rwbG=[linspace(0,1,perc)' linspace(0,1,perc)' ones(perc,1); ones(100-perc,1) linspace(0.98,0,100-perc)' linspace(0.98,0,100-perc)'];

top=max(max(plotAvO));
bot=min(min(plotAvO));
r=top-bot;
perc=round(abs(bot)*100/r);
rwbO=[linspace(0,1,perc)' linspace(0,1,perc)' ones(perc,1); ones(100-perc,1) linspace(0.98,0,100-perc)' linspace(0.98,0,100-perc)'];

ax2=figure;

imagesc(x,lagTime,plotAvO); 
hold on;
colormap(ax2,rwbO);

ax3=figure;

imagesc(x,lagTime,plotAvG); 
hold on;
colormap(ax3,rwbG);
toc

toc
