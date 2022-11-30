clear 

load('TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
ds = dataset01;

%% inlet distribution
ids_inlet_mass = ds(:,4:9);

figure(1)
for idx = 1:size(ids_inlet_mass,2)
   subplot(3,2,idx)
   histogram(ids_inlet_mass{:,idx},'Normalization','probability')
   ylim([0 0.08])
   title(ids_inlet_mass.Properties.VariableNames{idx},'Interpreter','none')
end
%%
ids_outlet_mass = ds(:,26:33);

figure(2)
for idx = 1:size(ids_outlet_mass,2)
   subplot(3,3,idx)
   histogram(ids_outlet_mass{:,idx},'Normalization','probability')
   ylim([0 0.1])
   title(ids_outlet_mass.Properties.VariableNames{idx},'Interpreter','none')
end

%%
clf
coor_matrix = corr(ids_outlet_mass{:,:});
surf(abs(coor_matrix))
view(0,-90)
colorbar
colormap jet

%% en el caso de la predicción del modelo del reformador backward 
% nos gustaria saber si existe alguna dependencia entre las componentes 
% de la salida
histogram(ds.Temperature)
Tmin = min(ds.Temperature);
Tmax = max(ds.Temperature);
Temp_span = linspace(Tmin,Tmax,500);
dTemp = uniquetol(diff(Temp_span));

%%
% for iT = Temp_span
%     bs = abs(iT - ds.Temperature) > dTemp;
%     coor_matrix = corr(ids_outlet_mass{bs,:});
%     surf(double(abs(coor_matrix)>0.9))
%     view(0,-90)
%     colorbar
%     colormap jet
%     title("Temperature = "+iT)
%     pause(1)
% end

%%
ds_target_SOFC = ids_outlet_mass;
%
ds_target_SOFC.Ar_mass_out = [];
ds_target_SOFC.N2_mass_out = [];
ds_target_SOFC.C_soot_mass_out = [];
%
ds_target_SOFC.other = ids_outlet_mass.Ar_mass_out + ids_outlet_mass.N2_mass_out + ids_outlet_mass.C_soot_mass_out;
%%
figure(1)
clf
plot3(ds.Air_Fuel_Ratio,ds.Steam_Fuel_Ratio,ds.H2_mass_out,'.')
grid on
title('H2 molar fraction')
%%
figure(2)
clf
plot3(ds.Air_Fuel_Ratio,ds.Steam_Fuel_Ratio,ds.CO_mass_out,'.')
grid on
title('H2 molar fraction')


%%
figure(3)
clf
scatter3(ds.H2O_mass_out,ds.CO_mass_out,ds.Air_Fuel_Ratio,[],ds.Temperature)

Tmin = min(ds.Temperature);
Tmax = max(ds.Temperature);
iter = 0
for iT = linspace(Tmin,Tmax,9)
    iter = iter + 1;
   idx_bo = abs(ds.Temperature-iT)< 10 ;
   subplot(3,3,iter)
   scatter3(ds.H2_mass_out(idx_bo), ...
               ds.H2O_mass_out(idx_bo), ...
               ds.Air_Fuel_Ratio(idx_bo),[],ds.CO_mass_out(idx_bo))
    grid on
    xlabel('H2O')
    ylabel('CO')
    title("Air/Fuel | T = "+iT)
end


%%
Inputs_forward = [ds.Temperature,ds.Air_Fuel_Ratio,ds.Steam_Fuel_Ratio];
Outputs_forward = ids_outlet_mass{:,:};
%
%inet_forward = feedforwardnet([3 4 8]);
inet_forward = cascadeforwardnet([3 5 8]);

inet_forward.performParam.regularization = 1e-8;
%inet_forward.layers{end}.transferFcn = 'poslin';

inet_forward = train(inet_forward,Inputs_forward',Outputs_forward');
%%
Inputs_backward = [ds.Temperature  ds_target_SOFC{:,:}];
Outputs_backward = [ds.Air_Fuel_Ratio,ds.Steam_Fuel_Ratio];

%inet_backward = feedforwardnet([8 5 3]);
inet_backward = cascadeforwardnet([8 5 3]);

%inet_backward = train(inet_backward,Inputs_backward',Outputs_backward');
%%
%inet_inlet_composition = feedforwardnet([2 4]);
inet_inlet_composition = cascadeforwardnet([6]);

Inputs_inlet = [ds.Air_Fuel_Ratio,ds.Steam_Fuel_Ratio];
Outputs_inlet = ids_inlet_mass{:,:};
%inet_inlet_composition = train(inet_inlet_composition,Inputs_inlet',Outputs_inlet');
%%


%%
path_file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/personal/phd/GreenHouseFolder/GreenHouseModel/TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output';

%genFunction(inet_forward,fullfile(path_file,'forward_reformer_net.m'),'MatrixOnly','yes')
%genFunction(inet_backward,fullfile(path_file,'backward_reformer_net.m'),'MatrixOnly','yes')
%genFunction(inet_inlet_composition,fullfile(path_file,'inlet_reformer_net.m'),'MatrixOnly','yes')

