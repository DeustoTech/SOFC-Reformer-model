clear all
%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat')
load(pathdata('2021_04_27_MergeData',1,'ics.mat'));
%%
%%
[mu_vars,std_vars] = NormalizeData(ics);
%%

ics_no = ics;
ics = SetNormalization(ics,mu_vars,std_vars);
%%

imodel = NN;
%iNARX = NARX_LongTerm;
%iNARX.Nt = 10;

imodel = compile(imodel,ics,'MiniBatchSize',64);
%%

figure(4)
%
opts = {'LR',1e-2,'MaxIter',10000};
imodel.params.num = 0.1*imodel.params.num;

imodel = train(imodel,ics,'opts',opts);
%%
figure(3)
PlotPrediction(imodel,ics,'ind',1,'InGroups',{1,2:6},'OutGroups',{1,2:5},'Nt',40,'normalize',0,'init',1)

%%
figure('unit','norm','pos',[0 0 0.45 1 ],'color','w')
clf
ErrorPlotPrediction(imodel,ics,'Nt',30)

%%
%savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output/model03_NN.mat';

save(fullfile(savepath,'model03_NN.mat'))
