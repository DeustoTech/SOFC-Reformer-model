clear
load('TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat')

%%
no_vars = dataset02(1).vars([1 3:14]);

newds = RemoveVars(dataset02,no_vars);

%%
in_vars = dataset01{1}.DataSet.Properties.VariableNames(27:2:36);
%%

ds = dataset01{1}.DataSet(:,in_vars)