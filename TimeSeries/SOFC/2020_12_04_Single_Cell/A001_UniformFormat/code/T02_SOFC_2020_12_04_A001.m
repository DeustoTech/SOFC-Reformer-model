%
% Selecion de variables de control, de estado y de perturbaciones. Creación del objeto ControlSystem de la libreria "Modeling And Control"
% 
%
clear all
%

%load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat')
load("/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat")

%%
dataset01 = [dataset01{:}];
%% 0 Uniform Time Stamp

dataset02 = UniformTimeStamp(dataset01,'DT',minutes(2));

%% Media Movil
dataset03 = MediaMovil(dataset02,5);
%% Podemos ver las relaciones lineales entre las disitntas variables

LinearCoor(dataset03)

%% 3 - Elegimos las entradas y salidas

ControlVars  = {'H2_act','Air_act'};

Disturbances = {'T_Oven_01'};

StateVars = { 'T_C_In'  , 'T_C_Out' ,               ...
              'i_act2'  , 'V_act'   ,               ...
              'v_H2_act', 'v_CO_act','v_CO2_act','v_CH4_act','v_O2_act'};
%
%%
vars = [ControlVars(:)' Disturbances(:)' StateVars(:)'];

for i = 1:581
    dataset03(i).DataSet = dataset03(i).DataSet(:,vars);
end
%%
ics = ControlSystem(dataset03,ControlVars,Disturbances,StateVars);
%%
fileout = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/cs01.mat";

save(fileout,'ics')

%%



