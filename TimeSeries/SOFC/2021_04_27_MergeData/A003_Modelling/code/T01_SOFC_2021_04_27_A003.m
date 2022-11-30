clear all
%
%%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat')
load(fullfile(loadpath('2021_04_27_MergeData',1),'ics.mat'))
%%
[mu_vars,std_vars] = NormalizeData(ics);
%mu_vars.out(2:end) = 0;
%std_vars.out(2:end) = 100;

%%
ics = SetNormalization(ics,mu_vars,std_vars);
%%
iNARX = NARX;
iNARX.No = 2;
iNARX.Ni = 2;
iNARX.Nd = 2;

%iNARX = NARX_norm;
%iNARX = NARX_LongTerm;
%iNARX.Nt = 10;

iNARX = compile(iNARX,ics,'MiniBatchSize',32);
%%

figure(4)
%
opts = {'LR',1e-3,'MaxIter',20000};
iNARX.params.num = 0.1*iNARX.params.num;

iNARX = train(iNARX,ics,'opts',opts);
%%
figure(3)
for j = 1:32 
    clf
    try
        PlotPrediction(iNARX,ics,'ind',j,'InGroups',{1,2:6},'OutGroups',{1,2:5},'Nt',40,'normalize',0,'init',1)
        pause(0.1)
    end
end
%%
figure('unit','norm','pos',[0 0 0.5 0.9 ],'color','w')
clf
ErrorPlotPrediction(iNARX,ics,'Nt',30)

%%
