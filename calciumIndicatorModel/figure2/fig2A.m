% Generate Figure 2A
addpath(genpath('../src'))
% define hill function
hillFunc=@(c,n,kd) (c.^n)./(kd.^n+c.^n);

% get biophysical constants
[KdG,nG,tauG,DrG]=getConstants("GCaMP");
[KdO,nO,tauO,DrO]=getConstants("OBG");

% set calcium range 
maxC=50; % uM
minC=0;  % uM

% make x-axis (calicum concentration range)
X=linspace(minC,maxC,1000*(maxC-minC))';

% get y axis values (fration bound) for each indicator type
YG=hillFunc(X,nG,KdG);
YO=hillFunc(X,nO,KdO);

%% make figure 

% plot values
figure
semilogx(X,YO,'LineWidth',2,'Color',"#663399")
hold on;
semilogx(X,YG,'LineWidth',2,'Color',"#FF6633")

% add lines for KD values for eahc indicator
xline(KdO,'--','Color',"#663399",'LineWidth',2)
xline(KdG,'--','Color',"#FF6633",'LineWidth',2)

% add zero line 
yline(0.5,'--','Color','k','LineWidth',1)

% add labels
xlabel('Ca^{2+} \mu M','FontSize',11)
ylabel('Fraction Bound','FontSize',11)
legend('OGB','GCaMP6f','Location','best')

% turn off boxes
legend boxoff 
box off

% set axis labels and limits 
ylim([-0.05 1.05])
xlim([1e-3 105])
yticks([0 .5 1])
yticklabels(["0" "0.5" "1"]);
xticks([1e-3 1e-2 1e-1 1 10 100])
xticklabels({'10^{-3}' ,'10^{-2}', '10^{-1}', '10^{0}', '10^{1}' ,'10^{-2}'});


