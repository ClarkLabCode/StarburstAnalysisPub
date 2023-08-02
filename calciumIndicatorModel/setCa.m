clear 
clc
addpath(genpath('src'))
close all

% make the set calcium plots
dt_in_ms=1;
start = 1e2;       % ms
width = 8e2;     % ms
time_in_ms=4*start+width; 
time=defineTime(time_in_ms,dt_in_ms);

save=0;
saveDir='test';
tag='test';
%% step up
numOfPlots=5;
h1Range=zeros(1,numOfPlots);
h2Range=linspace(0.05,0.8,numOfPlots);
h3Range=h1Range;

for ii=1:numOfPlots
    h=[h1Range(ii) h2Range(ii) h3Range(ii)];
    func=defCacFunc(h,start,width,'step');
    CaData1(:,ii)=func(time);
    [FO1(:,ii),dFO1(:,ii)]=caToF(CaData1(:,ii),dt_in_ms,start,'OBG',save,saveDir,tag);
    [FG1(:,ii),dFG1(:,ii)]=caToF(CaData1(:,ii),dt_in_ms,start,'GCaMP',save,saveDir,tag);
end
%% step down
h1Range=0.8*ones(1,numOfPlots);
h2Range=linspace(0.05,0.5,numOfPlots);
h3Range=h1Range;

for ii=1:numOfPlots
    h=[h1Range(ii) h2Range(ii) h3Range(ii)];
    func=defCacFunc(h,start,width,'step');
    CaData2(:,ii)=func(time);
    [FO2(:,ii),dFO2(:,ii)]=caToF(CaData2(:,ii),dt_in_ms,start,'OBG',save,saveDir,tag);
    [FG2(:,ii),dFG2(:,ii)]=caToF(CaData2(:,ii),dt_in_ms,start,'GCaMP',save,saveDir,tag);
end
%% amplitude variety
freq = 3;         % Hz  
phase = 0;         % ms
height = 0.01;      % uM
start = 1e2;       % ms
% width =3*(10e3/freq);     % ms
width=1000;
maxAmp= 0.4; % uM
minAmp= 0.1; % uM
ampRange=linspace(minAmp,maxAmp,numOfPlots);
for ii=1:numOfPlots
    amp=ampRange(ii);
    parameters=[amp,freq,phase,height];
    func=defCacFunc(parameters,start,width,'cos');
    CaData3(:,ii)=func(time);
    [FO3(:,ii),dFO3(:,ii)]=caToF(CaData3(:,ii),dt_in_ms,start,'OBG',save,saveDir,tag);
    [FG3(:,ii),dFG3(:,ii)]=caToF(CaData3(:,ii),dt_in_ms,start,'GCaMP',save,saveDir,tag);
end

%% baseline variety 

amp=0.2;
maxH= 0.45; % uM
minH= 0.01; % uM
heightRange=linspace(minH,maxH,numOfPlots);
for ii=1:numOfPlots
    height=heightRange(ii);
    parameters=[amp,freq,phase,height];
    func=defCacFunc(parameters,start,width,'cos');
    CaData4(:,ii)=func(time);
    [FO4(:,ii),dFO4(:,ii)]=caToF(CaData4(:,ii),dt_in_ms,start,'OBG',save,saveDir,tag);
    [FG4(:,ii),dFG4(:,ii)]=caToF(CaData4(:,ii),dt_in_ms,start,'GCaMP',save,saveDir,tag);
end

% maxOF1=max(max(dFO1));
% maxOF2=max(max(dFO2));
% maxOF3=max(max(dFO3));
% maxOF4=max(max(dFO4));
% 
% minOF1=min(min(dFO1));
% minOF2=min(min(dFO2));
% minOF3=min(min(dFO3));
% minOF4=min(min(dFO4));
% 
% maxGF1=max(max(dFG1));
% maxGF2=max(max(dFG2));
% maxGF3=max(max(dFG3));
% maxGF4=max(max(dFG4));
% 
% minGF1=min(min(dFG1));
% minGF2=min(min(dFG2));
% minGF3=min(min(dFG3));
% minGF4=min(min(dFG4));
% 
% minOF=min([minOF1 minOF2 minOF3 minOF4]);
% minGF=min([minGF1 minGF2 minGF3 minGF4]);
% 
% maxOF=max([maxOF1 maxOF2 maxOF3 maxOF4]);
% maxGF=max([maxGF1 maxGF2 maxGF3 maxGF4]);

[KdO,n,tau,Dr]=getConstants("OBG");
[KdG,n,tau,Dr]=getConstants("GCaMP");


yLim1=[-0.03 1];
% yLim2=[2*minOF maxOF-2*minOF];
% yLim3=[2*minGF maxGF-2*minGF];

fig=figure;

cm = colormap(['winter']);

for ii=1:numOfPlots
    colorVals(ii,:) = cm(1+round((ii-1)/numOfPlots*256),:);
end



subplot (3,4,1)
plot(time,CaData1)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
yline(0,'LineWidth',1.25)
yline(KdO,'LineWidth',1.25,'Color','k')
yline(KdG,'LineWidth',1.25,"Color",'b')
ylim(yLim1)
ylabel('Ca^{+} (\mu M)')
box off

subplot (3,4,2)
plot(time,CaData2)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
% yticklabels({})
yline(0,'LineWidth',1.25)
yline(KdO,'LineWidth',1.25,'Color','k')
yline(KdG,'LineWidth',1.25,"Color",'b')
ylim(yLim1)
box off

subplot (3,4,3)
plot(time,CaData3)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
yticklabels({})
yline(0,'LineWidth',1.25)
yline(KdO,'LineWidth',1.25,'Color','k')
yline(KdG,'LineWidth',1.25,"Color",'b')
ylim(yLim1)
box off

subplot (3,4,4)
plot(time,CaData4)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
yticklabels({})
yline(0,'LineWidth',1.25)
yline(KdO,'LineWidth',1.25,'Color','k')
yline(KdG,'LineWidth',1.25,"Color",'b')
ylim(yLim1)
box off


subplot(3,4,5)
plot(time,dFO1)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
yline(0,'LineWidth',1.25)
% ylim(yLim2);
ylim([-1 11])
ylabel('OGB \Delta F/F')
box off

subplot(3,4,6)
plot(time,dFO2)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
%yticklabels({})
yline(0,'LineWidth',1.25)
ylim([-1.2 0.2])
% ylim(yLim2);
box off

subplot(3,4,7)
plot(time,dFO3)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
%yticklabels({})
yline(0,'LineWidth',1.25)
ylim([-0.5 7.5])
% ylim(yLim2)
box off

subplot(3,4,8)
plot(time,dFO4)
set(gca,'colororder',colorVals);
xlim([0 time_in_ms])
xticks([100:400:time_in_ms])
xticklabels({})
%yticklabels({})
yline(0,'LineWidth',1.25)
ylim([-0.5 6])
% ylim(yLim2)
box off

subplot(3,4,9)
plot(time,dFG1)
set(gca,'colororder',colorVals);
xticks([100:400:time_in_ms])
xticklabels([0:400:time_in_ms]./1e3)
xlim([0 time_in_ms])
% ylim(yLim3)
ylim([-1 26])
yline(0,'LineWidth',1.25)
ylabel('GCaMP \Delta F/F')
box off

subplot(3,4,10)
plot(time,dFG2)
set(gca,'colororder',colorVals);
xticks([100:400:time_in_ms])
xticklabels([0:400:time_in_ms]./1e3)
xlim([0 time_in_ms])
% %yticklabels({})
ylim([-1.2 0.2])
yline(0,'LineWidth',1.25)
% ylim(yLim3)
box off

subplot(3,4,11)
plot(time,dFG3)
set(gca,'colororder',colorVals);
xticks([100:400:time_in_ms])
xticklabels([0:400:time_in_ms]./1e3)
xlim([0 time_in_ms])
ylim([-1 26])
% %yticklabels({})
yline(0,'LineWidth',1.25)
% ylim(yLim3)
box off

subplot(3,4,12)
plot(time,dFG4)
set(gca,'colororder',colorVals);
xticks([100:400:time_in_ms])
xticklabels([0:400:time_in_ms]./1e3)
xlim([0 time_in_ms])
ylim([-1 12])
%yticklabels({})
yline(0,'LineWidth',1.25)
% ylim(yLim3)

box off


% x0=10;
% y0=10;
% width=300;
% height=200;
% set(gcf,'units','points','position',[x0,y0,width,height])
% omg=gcf();
% han=axes(fig,'visible','off'); 
% %han.Title.Visible='on';
% han.XLabel.Visible='on';
% %han.YLabel.Visible='on';
% %ylabel(han,'yourYLabel');
% xlabel(han,'time (s)');
% %title(han,'yourTitle');

