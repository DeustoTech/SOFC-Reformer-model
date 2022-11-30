%%
clear
load('TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
%
%
dataset01(:,contains(dataset01.Properties.VariableNames,'mole')) = [];
dataset01(:,contains(dataset01.Properties.VariableNames,'ratio')) = [];
dataset01(:,contains(dataset01.Properties.VariableNames,'VarName')) = [];
%dataset01(:,contains(dataset01.Properties.VariableNames,'Ratio')) = [];

head(dataset01)

filepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/personal/phd/GreenHouseFolder/GreenHouseModel/TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output';
save(fullfile(filepath,'T07_REFORMER_2020_11_30_A001.mat'),'dataset01')
