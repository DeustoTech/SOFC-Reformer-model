clear 

load('TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')

%% 1- Remove VarNames

dataset01 = RemoveVarNames(dataset01);
%% 2 - Vemos todas las correlaciones 
dataset02 = dataset01(:,[1 2 10:20 29:36]);
figure(1)
LinearCoorAna(dataset02);
title('Variables Linear Coorelation')

%% 3 - Elegimos los controles y estados
Vars =  dataset01.Properties.VariableNames;

ControlVars = {'Steam_Fuel_Ratio','Air_Fuel_Ratio','Temperature'};
StateVars   = {'N2_mole','O2_mole','CO2_mole','H2O_mole','Argon_mole','C_mole','H_mole' ...
               'H2O_C_ratio','O_C_ratio', ...
               'Ar_mole_out','CH4_mole_out','CO_mole_out','CO2_mole_out','H2_mole_out','H2O_mole_out','N2_mole_out','C_soot_mole_out'};
%
dataset02_control = dataset01(:,ControlVars);
dataset03_state   = dataset01(:,StateVars);
%
%% 4 -  Linear Correlation of Control Variables
figure(2)
[ControlCoor,ControlCoor_bolean] = LinearCoorAna(dataset02_control);
title('Control Variables Linear Coorelation')
% De manera que no existe correlacion lineal entre las 
% variables de control en el mismo instante de tiempo
%% 5 - Linear Correlation of State Variables
figure(3)
[StateCoor,StateCoor_bolean] = LinearCoorAna(dataset03_state);
title('State Variables Linear Coorelation')

%% 6 - Linear Correlation Control-States
dataset04_fulldata = [dataset03_state dataset02_control];
%
figure(4)
[FullCoor,FullCoor_bolean,iplot] = LinearCoorAna(dataset04_fulldata);
%iplot.NodeCData = [zeros(1,17),ones(1,3)];
title('Variables Linear Coorelation')

%% 7 - Quitamos la relacion lineal entre steam_fuel_ratio y H20_C_ratio
dataset05_state = dataset03_state;
dataset05_state(:,4) = [];
%%
dataset06_fulldata = [dataset05_state dataset02_control];
%
figure(5)
[FullCoor,FullCoor_bolean,iplot,G] = LinearCoorAna(dataset06_fulldata,'FontSize',10);
iplot.NodeCData = [zeros(1,16),ones(1,3)];
title('Variables Linear Coorelation')
%%
control_dataset = dataset02_control;
state_dataset   = dataset03_state;
save("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset02.mat','control_dataset','state_dataset')