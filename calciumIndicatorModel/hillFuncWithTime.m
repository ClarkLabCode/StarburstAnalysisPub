 %% set up
clear
clc
close all
addpath(genpath('src'))
tic
%%
timeFunc=@(c,n,kd,tau) tau./(1+((c.^n)./(kd.^n)));

[KdG,nG,tauG,DrG]=getConstants("GCaMP");

[KdO,nO,tauO,DrO]=getConstants("OBG");
maxC=50;
minC=0;
X=linspace(minC,maxC,1000*(maxC-minC))';
YG=timeFunc(X,nG,KdG,tauG);
YO=timeFunc(X,nO,KdO,tauO);

saveColors=colororder;

figure;

% testFunc=@(x) 1./(1+(x./0.3).^2);
% X=linspace(-5,5,100);
ytg=timeFunc(X,nG,KdG,tauG);
yto=timeFunc(X,nO,KdO,tauO);
ytg=(ytg-min(ytg))/(max(ytg)-min(ytg));
yto=(yto-min(yto))/(max(yto)-min(yto));
semilogx(X,yto,'LineWidth',2)
hold on;
semilogx(X,ytg,'LineWidth',2)
% loglog(X,YG,'LineWidth',2)
xline(KdO,'--','Color',saveColors(1,:),'LineWidth',2)
xline(KdG,'--','Color',saveColors(2,:),'LineWidth',2)
yline(0.5,'--','Color','k','LineWidth',1)



%%
hillFunc=@(c,n,kd) (c.^n)./(kd.^n+c.^n);

[KdG,nG,tauG,DrG]=getConstants("GCaMP");

[KdO,nO,tauO,DrO]=getConstants("OBG");
maxC=50;
minC=0;
X=linspace(minC,maxC,1000*(maxC-minC))';
YG=hillFunc(X,nG,KdG);
YO=hillFunc(X,nO,KdO);

saveColors=colororder;

figure;
x0=10;
y0=10;
width=300;
height=615;
set(gcf,'units','points','position',[x0,y0,width,height])

semilogx(X,YO,'LineWidth',2)
hold on;
semilogx(X,YG,'LineWidth',2)
xline(KdO,'--','Color',saveColors(1,:),'LineWidth',2)
xline(KdG,'--','Color',saveColors(2,:),'LineWidth',2)
yline(0.5,'--','Color','k','LineWidth',1)


xlabel('Ca^{2+} ({\mu}M)','FontSize',11)
ylabel('Fraction Bound','FontSize',11)
legend('OGB','GCaMP','Location','best')
ylim([-0.05 1.05])
xlim([1e-3 105])
x0=10;
y0=10;
width=240;
height=170;
set(gcf,'units','points','position',[x0,y0,width,height])
box off
ax=gca;
ax.FontSize=9;
ax.LabelFontSizeMultiplier=1;
ax.TitleFontSizeMultiplier=1;
yticks([0 .5 1])
yticklabels(["0" "0.5" "1"]);
xticks([1e-3 1e-2 1e-1 1 10 100])
xticklabels({'10^{-3}' ,'10^{-2}', '10^{-1}', '10^{0}', '10^{1}' ,'10^{-2}'});
toc