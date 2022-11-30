clear all
%
load(MainPath+"AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat")
%%
[mu_vars,std_vars] = NormalizeData(ics);
%%
ics_no = ics;
ics = SetNormalization(ics,mu_vars,std_vars);
%%
figure(4)

opts = {'LR',1e-2,'MaxIter',1e4,'miniBatchSize',32};
[pred,opt_params] = MultiLayerPercepNARX_dt_norm(ics,'opts',opts);
%%

%%
%close all
ind = 3;

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
savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output/model01_dt.mat';

save(savepath)
