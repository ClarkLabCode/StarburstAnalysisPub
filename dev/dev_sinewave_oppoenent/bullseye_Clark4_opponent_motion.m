function[]=bullseye_Clark3(varargin)
% ***************************** Start common stimulus file header *****************************
global filename;
if nargin==0
    window=SDE_screenInit();
    Ard_s=arduino_openCOM;
    tND=thorlabs_openCOM(0);
    stimoffset=[0 0];
else
    handles=varargin{1};
    window=handles.window;
    tND=handles.tND;
    Ard_s=handles.Ard_s;
    stimoffset(1)=-4/3.33*str2double(get(handles.XoffsetETXT,'string'));
    stimoffset(2)=-4/3.33*str2double(get(handles.YoffsetETXT,'string'));
end
if ~isempty(tND) fw=1; fwpos=getWheelpos(tND); else fwpos=-9999; end
if ~isempty(Ard_s) fwrite(Ard_s,50); fwrite(Ard_s,48); else disp('Arduino controller board error'); Ard_s=1; end
% ***************************** End common stimulus file header *****************************

[screenXpixels, screenYpixels] = Screen('WindowSize', window);
Screen('Flip', window);
ifi = Screen('GetFlipInterval', window);
[xCenter, yCenter] = RectCenter([0 0 screenXpixels screenYpixels]);

glob.screendims=[screenXpixels, screenYpixels];
glob.screenifi=ifi;

filterMode = 0;

nreps=1;

load('stimseq/C4_sinusoid_opponent.mat');

[stimframes,nrings,nstim]=size(cont);
pars=stimulus_parameters;

% stimpars: 1=nrings, 2=pixperpatternpix, 3=patternlifetime, 4=totalframes, 5=ND wheel position, 6=prestimblankperiod, 7=poststimpause
for stimn=1:nstim
    stim(stimn,:)=[nrings pars.SPPS(stimn) pars.SPLT(stimn) stimframes.*pars.SPLT(stimn) 3 1 5];  % 1 pix = 3.33 µm.
end


pl=[];
for block=1:nreps
    tn=1:nstim;
%     pl=[pl tn];    %present stimuli in defined sequence
        pl=[pl Shuffle(tn)];
end
pl

StimulusOnseTime=zeros(stim(1,4),length(pl));

for trialn=1:length(pl)
    
    tic
    curstim=pl(trialn);
    disp(sprintf('Trial n: %d, stim n: %d', trialn, curstim));
    
    stimpars=stim(curstim,:);
    
    stimseq=squeeze(cont(:,:,curstim));
    stimseq=(stimseq+1)./2;     % turn into 0-based intensity values
    figure(100);
    imagesc(stimseq); set(gca,'clim', [0 1]);
    drawnow;
    
    if stimpars(5)~=9
        disp(sprintf('Desired filterpos = %d',stimpars(5)));
        if fw fprintf(tND,sprintf('pos=%d',stimpars(5))); else disp('Filterwheel is inactive'); end
    end
    
    nrings=stimpars(1);
    pixperpatch=stimpars(2);
    stimpatternlifetime=stimpars(3);
    nframes=stimpars(4);
    
    
    framesubcounter=0;
    prestimblankframes=round(stimpars(6)/ifi);
    
    nframes=stimpars(4)+prestimblankframes;
    
    once=1;
    n=1;
    stimseqcount=0;
    a=0;
    stimon=0;
    framesubcount=stimpatternlifetime;
    nframes
    while (~KbCheck) && n<=nframes
        
        switch stimon
            case 0
                if n>=prestimblankframes
                    stimon=1;
                end
                [VBLTimestamp StimulusOnseTime(n,trialn)]=Screen('Flip', window);
                if once
                    fwrite(Ard_s,49);
                    once=0;
                end
            case 1
                if framesubcount==stimpatternlifetime
                    stimseqcount=stimseqcount+1;
                end
                for ringn=nrings:-1:1
                    dstRect = [0 0 ringn ringn] .* pixperpatch*2;
                    centeredspot = CenterRectOnPointd(dstRect, xCenter+stimoffset(1), yCenter+stimoffset(2));
                    Screen('FillOval', window, stimseq(stimseqcount,ringn), centeredspot);
                end
                
                [VBLTimestamp StimulusOnseTime(n,trialn)]=Screen('Flip', window);
                
                if framesubcount==stimpatternlifetime
                    a=~a;
                    fwrite(Ard_s,50+a);
                    framesubcount=0;
                end
                framesubcount=framesubcount+1;
        end
        
        n=n+1;
        
    end
    [vbl lastflip] = Screen('Flip', window);
    fwrite(Ard_s,50);
    fwrite(Ard_s,48);
    
    if KbCheck
        'here - presentation terminated'
        break;
    end
    pause(stim(curstim,7));
    toc
end
Screen('FillRect', window, 0.5); Screen('Flip', window);

figure(100);
hist(StimulusOnseTime(2:end)-StimulusOnseTime(1:end-1),20);
% set(gcf,'position', [539   443   500   200]);

% ***************************** Start common stimulus file footer *****************************
if nargin==0  sca; else Screen('Flip', window); end
runtimecode=com.mathworks.mlservices.MLEditorServices.getEditorApplication.getActiveEditor.getDocument;
runtimecode=char(runtimecode.getText(0,runtimecode.getLength));
try
    filename=get(handles.fnameETXT,'string');
catch
    filename='';
end
filename = uiputfile('*.mat','*.mat',filename);
if filename
    save(filename,'stim','pl','fwpos','StimulusOnseTime','runtimecode','glob');
    pre=filename(1:end-7);
    fcounter=str2num(filename(end-6:end-4)); fcounter=fcounter+1;
    filename=sprintf('%s%03d.mat',pre,fcounter);
    try set(handles.fnameETXT,'string',filename); end
end
% ***************************** End common stimulus file footer *****************************
