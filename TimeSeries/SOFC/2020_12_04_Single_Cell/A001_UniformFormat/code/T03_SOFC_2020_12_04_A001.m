
clear 
%pathfolder = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/SOFC-Cell-Modelling-Paper/img/';


%load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat')
load("/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat")
%%
dataset01 = [dataset01{:}];
dataset01 = Concat(dataset01);
%%
%fig = figure('unit','norm','pos',[0 0 0.5 0.4]);
%fig.Renderer = 'painters';
ShowDataSelect(dataset01,{1:2,3:8,9:14,15:18,19,20,21:22,23:27},'window',1500)
%
%pathfile =  pathfolder+"showdata_singlecell.eps";
%print(fig,'-depsc',pathfile)
%%
%pathfile =  pathfolder+"dt_singlecell.eps";
%fig = figure('unit','norm','pos',[0 0 0.4 0.5]);
%
clf
ShowDiffTspan(dataset01,'window',1501);
%print(fig,'-depsc',pathfile)

%%

dataset01 = cut(dataset01,minutes(5));
%%
%pathfile =  pathfolder+"dt_singlecell_split.eps";
%fig = figure('unit','norm','pos',[0 0 0.4 0.5]);
ShowDiffTspan(dataset01,'window',1500);
%print(fig,'-depsc',pathfile)
%%
dataset02 = UniformTimeStamp(dataset01,'DT',minutes(2));

%savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat';
savepath = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat";
save(savepath,'dataset02')
