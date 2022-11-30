clear 
%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/dataset_full.mat')
load(fullfile(loadpath('2021_04_27_MergeData',1),'dataset_full.mat'))
%%


iTs_full = Concat(iTs);

%%
%LinearCoor(iTs_full,'alpha',0.9)
%%
figure(2)
plot(iTs_full.DataSet.v_CO_act,iTs_full.DataSet.v_CO2_act,'*')

%%
volume_vars = iTs(1).vars(4:8);
nds = length(iTs);

for i = 1:nds
   for ivar =  volume_vars
        booleans = iTs(i).DataSet.(ivar{:}) < 0;
        iTs(i).DataSet.(ivar{:})(booleans) = 0;
   end
end


%%
iTs = RemoveRowMaxGrad(iTs,'v_O2_act',0.1);
iTs = UniformTimeStamp(iTs,'DT',minutes(5));
iTs = MediaMovil(iTs,2);

%%
%iTs = iTs([4 10 15]);
%iTs = RemoveRowsNan(iTs);
%%

InputVars = {'T_Oven_01', ...
                'Air_tar','H2O_tar','CO_tar','H2_tar','CO2_tar','CH4_tar'};
%
%InputVars = {'T_Oven_01', ...
%                'Air_tar','H2O_tar','H2_tar','CH4_tar'};
%
%%
DisturbanceVars = {'i_act2'};
%
OutputVars = {'V_act','v_H2_act','v_CO_act','v_CO2_act','v_CH4_act','v_O2_act'};  

%OutputVars = {'V_act','v_H2_act','v_CH4_act','v_O2_act'};  

%%
ics = ControlSystem(iTs,InputVars,DisturbanceVars,OutputVars);


%filesave =     "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output";

filesave = savepath;
save(fullfile(filesave,"ics.mat"),'ics')
