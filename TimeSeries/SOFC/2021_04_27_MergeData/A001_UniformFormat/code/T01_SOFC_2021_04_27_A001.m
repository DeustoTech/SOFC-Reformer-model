%%
clear 
%%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset02.mat')
first = dataset02;
%%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset03.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/dataset03.mat')
second = dataset03;
%
for i = 1:length(second)
second(i).DataSet.v_O2_act = [];
second(i).DataSet.Properties.VariableNames{9} = 'v_O2_act';
end
%%
vars = {};
vars = {'T_Oven_01','i_act2','V_act', ...
         'v_H2_act','v_CO_act','v_CO2_act','v_CH4_act','v_O2_act', ...
         'H2O_tar','CH4_tar','CO2_tar','H2_tar','CO_tar','N2_tar','Air_tar'};
    %%
%vars = {'T_Oven_01','i_act2','V_act', ...
%        'v_H2_act','v_CH4_act','v_O2_act', ...
%        'H2O_tar','CH4_tar','H2_tar','Air_tar'};
%%
for i = 1:length(second)
    second(i).DataSet.Properties.VariableNames{1} = 'T_Oven_01';

end
for i = 1:4
    first(i).DataSet.Properties.VariableNames{21} = 'H2_tar';
    first(i).DataSet.Properties.VariableNames{22} = 'Air_tar';
end
%%
newds = [];

i = 0;
for iTs = [first second]
    i = i + 1;
    newds(i).DateTime = iTs.DateTime';
    for ivar = vars
        %
        try 
            newds(i).(ivar{:}) = iTs.DataSet.(ivar{:});
            
        catch
            ivar
           if strfind(ivar{:},'tar')
                newds(i).(ivar{:}) = iTs.DataSet.T_Oven_01*0;
           end
        end
        %
    end
end
%%
nn = (length(first) + length(second));
iTs = arrayfun(@(i) struct2table(newds(i)),1:nn, 'UniformOutput',0);
%%
iTs = arrayfun(@(iiTs) TableSeries(iiTs{:}),iTs, 'UniformOutput',1);

%%
for i = 1:nn
    iTs(i).DateTime = iTs(i).DateTime';
end
%%
%savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/dataset_full.mat';
savepath = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/dataset_full.mat';

save(savepath,'iTs');
