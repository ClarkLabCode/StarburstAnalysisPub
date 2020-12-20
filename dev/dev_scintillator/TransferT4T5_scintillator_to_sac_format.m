%% TODO organize these code nicely.

cell_type = 4;

sysConfig = GetSystemConfiguration;
datapath = fullfile(sysConfig.cached_T4T5_data_path, 'T4T5_scintillator_T4T5_Neuron_2016.mat'); %% This is data is run from Neuron2016/figureCode/Figure4

data = load(datapath);
%% There is no way that you can formalize the data in the same way. since different flies. That is going to be okay.
%% positive and negative separate then. 

resp_set = {data.posAnalysis.analysis{cell_type}, data.negAnalysis.analysis{cell_type}};
resp_reorganize = cell(2, 1);
for pp = 1:1:2
    resp = resp_set{pp};
    
    %% double check whether this is true.
    preferred_epochs = [resp.prefEpochs(1:end-1)];
    null_epochs = [resp.nullEpochs(1:end-1)];
 
    %% get useful points.
    resp_pref.resp_ave = resp.respMatPlot(preferred_epochs);
    resp_pref.resp_sem = resp.respMatSemPlot(preferred_epochs);
    resp_pref.resp_ind = resp.respMatIndPlot(preferred_epochs,:);

    resp_null.resp_ave = resp.respMatPlot(null_epochs);
    resp_null.resp_sem = resp.respMatSemPlot(null_epochs);
    resp_null.resp_ind = resp.respMatIndPlot(null_epochs,:);
    
    resp_diff.resp_ave = resp.respMatDiffPlot(preferred_epochs);
    resp_diff.resp_sem = resp.respMatDiffSemPlot(preferred_epochs);
    resp_diff.resp_ind = resp.respMatDiffIndPlot(preferred_epochs, :);
    
    resp_summary = cell(3, 1);
    resp_summary{1} = resp_pref;
    resp_summary{2} = resp_null;
    resp_summary{3} = resp_diff;
    
    resp_reorganize{pp} = resp_summary;
end

%%
T4T5_Scintillator_Utils_Replot_Dev(resp_reorganize)


