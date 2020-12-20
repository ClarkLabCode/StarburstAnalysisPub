function stimtime = SAC_Load_Stimtime(stimtime_file)
    data = load(stimtime_file);
    StimulusOnseTime = data.StimulusOnseTime;
    nframeperseq = data.stim(1,5);
%     stimtime = StimulusOnseTime(1:nframeperseq:end,:) - StimulusOnseTime(1,:);
    stimtime = repmat(StimulusOnseTime(1:nframeperseq:end,1) - StimulusOnseTime(1,1), [1, 5]);
end