clear all
%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat')
load(pathdata('2021_04_27_MergeData',1,'ics.mat'))
%%
[mu_vars,std_vars] = NormalizeData(ics);
%%
ics_no = ics;
ics = SetNormalization(ics,mu_vars,std_vars);
%%
figure(4)

opts = {'LR',1e-3,'MaxIter',20000,'miniBatchSize',64};
[pred,opt_params] = NAR(ics,'opts',opts);
%%

%%
%close all
ind = 2;

[XTest,Outputs] = GenNARXData(ics,'ind',ind);

YTest = full(pred(XTest',opt_params));

%
tspan  = [ics.tspan{ind}(2:end)];
In  = [ics.Inputs{ind}(:,2:end)];
Dis = [ics.Disturbances{ind}(:,2:end)];
Out = YTest;
%
newcs = Data2cs(ics,tspan,In,Out,Dis);
%
OutGroups = {1,2,3:4};
InGroups  = {1:5};
figure(1)
plot(ics_no,'ind',ind,'OutGroups',OutGroups,'InGroups',InGroups)
figure(2)
plot(newcs,'ind',1,'OutGroups',OutGroups,'InGroups',InGroups)
figure(3)
plot([ics.Outputs{ind}(:,2:end)]' - YTest')
legend(ics.OutputVars)

%%
savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output/model01mat';

save(savepath)
