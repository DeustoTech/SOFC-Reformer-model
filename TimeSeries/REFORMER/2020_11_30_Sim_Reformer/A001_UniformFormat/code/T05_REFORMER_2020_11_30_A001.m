%%
clear
load('TimeSeries/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
ds = dataset01;

%% no trabajo T < 650
ds((ds.Temperature < 650),:) = [];


%%
ids_outlet_mass = ds(:,26:33);

%%
ds_target_SOFC = ids_outlet_mass;
%
ds_target_SOFC.Ar_mass_out = [];
ds_target_SOFC.N2_mass_out = [];
ds_target_SOFC.C_soot_mass_out = [];
%
ds_target_SOFC.other = ids_outlet_mass.Ar_mass_out + ids_outlet_mass.N2_mass_out + ids_outlet_mass.C_soot_mass_out;

Temperature_target = ds.Temperature;
%% Creamos el muestre en el hipercubo de 6 dimensiones
max_values = max(ds_target_SOFC{:,:});
min_values = min(ds_target_SOFC{:,:});

dim = length(max_values);
n_muestreo = 2500;
muestreo =  min_values + (max_values - min_values).*rand(n_muestreo,dim);
%%
muestreo_perm = permute(muestreo,[3 2 1]);

%% 
Tmin = min(Temperature_target);
Tmax = max(Temperature_target);

Temp_span = linspace(Tmin,Tmax,80);
diff_Temp_span = diff(Temp_span);

dT = diff_Temp_span(1);

cell_muestreo = {};
cell_new_muestreo = {};
cell_min_data = {};
cell_ind_min = {};

for idx_temp = 1:length(Temp_span)-1
    bl_inx = (Temperature_target >= Temp_span(idx_temp)).*(Temperature_target < Temp_span(idx_temp)+diff_Temp_span(idx_temp));
    bl_inx = logical(bl_inx);

    ids_t_SOFC = ds_target_SOFC{bl_inx,:};
    
    distance = sum((ids_t_SOFC - muestreo_perm).^2,2);
    
    [mindata,ind_min]=min(distance,[],1);

    mindata = [mindata(:)];
    ind_min = [ind_min(:)];
    
    new_muestreo = ids_t_SOFC(ind_min,:);
    new_muestreo((mindata<0.1^2),:) = muestreo((mindata<0.1^2),:);
    

    cell_muestreo{idx_temp} = muestreo;
    cell_new_muestreo{idx_temp} = new_muestreo;
    cell_min_data{idx_temp} = mindata;
    cell_ind_min{idx_temp} = ind_min;
    cell_temp{idx_temp} = Temp_span(idx_temp) + 0*mindata;
end

%%
if false 
idx_temp = 1;
clf
for iter = 1:length(ind_min)
    bar([cell_muestreo{idx_temp}(iter,:);cell_new_muestreo{idx_temp}(iter,:)]')
    legend('muestra','proyeccion')
    title("muestra = "+iter + " | min = "+cell_min_data{idx_temp}(iter))
    if cell_min_data{idx_temp}(iter)<0.1^2
        'hola'
    end
    pause(0.1)
end
end
%% build dataset

min_data_ds    = vertcat(cell_min_data{:});
muestreo_data  = vertcat(cell_muestreo{:});
new_muestreo_data  = vertcat(cell_new_muestreo{:});

Temp_data_ds   = vertcat(cell_temp{:});
%%
% distancia menos 0.2 se pone en cero el valor 
% de manera que lo que sale de inet_bo es pequeño entonces el punto esta en
% el convex hull

distance_tol = 0.01;
distance_hull = min_data_ds;
distance_hull(distance_hull < distance_tol^2) = 0;
inet_bo = cascadeforwardnet([10 10]);
%inet_bo = feedforwardnet([10 10]);
inet_bo = train(inet_bo,[Temp_data_ds muestreo_data]',distance_hull');

%%
%path_file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/personal/phd/GreenHouseFolder/GreenHouseModel/TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output';
%genFunction(inet_bo,fullfile(path_file,'check_convex_hull.m'),'MatrixOnly','yes')
%genFunction(inet_backward,fullfile(path_file,'backward_reformer_net.m'),'MatrixOnly','yes')
%genFunction(inet_inlet_composition,fullfile(path_file,'inlet_reformer_net.m'),'MatrixOnly','yes')


%%
rng(10)
inet = cascadeforwardnet([10]);
%inet = feedforwardnet([21 6]);
%inet = cascadeforwardnet([21 6]);

%inet.layers{1}.transferFcn = 'poslin';
inet = train(inet,[Temp_data_ds muestreo_data]',new_muestreo_data');

%%
%genFunction(inet,fullfile(path_file,'proyection_in_convex_hull.m'),'MatrixOnly','yes')

%%
S = {'CH4','CO','CO2','H2','H2O','other'};

idx_temp = 1;

for iter = 1:length(ind_min)
    
    TT = cell_temp{idx_temp}(iter);
    if inet_bo([TT cell_muestreo{idx_temp}(iter,:)]') < distance_tol
        % entonces esta en el convex hull no es necesario 
        % cambiarlo 
        pred_muestreo = cell_muestreo{idx_temp}(iter,:);
        title_pred = 'no proyectado';
    else
        % este dato esta lejos  del convex hull por lo que es necesario
        % proyectarlo 
        pred_muestreo = inet([TT cell_muestreo{idx_temp}(iter,:)]')';
        title_pred = 'proyectado';

    end
    bar([cell_muestreo{idx_temp}(iter,:);cell_new_muestreo{idx_temp}(iter,:);pred_muestreo]')
    legend('muestra','proyeccion','predicha')
    title("muestra = "+iter + " | min distance = "+cell_min_data{idx_temp}(iter) + " | T = "+TT+"K"+" | "+title_pred)
    xticklabels(S)
    
    pause()
    iter
end
%%

fig = figure(1);
fig.Color = 'w'
fig.Units = 'norm';
fig.Position = [0 0 0.6 0.6];
S = {'CH4','CO','CO2','H2','H2O','other'};

numsample = [1 2 3 4 5 6];
numTemp = 10*[1 2 3 4 5 6];

for count = 1:6

    iter = numsample(count);
    idx_temp = numTemp(count);
    TT = cell_temp{idx_temp}(iter);
    if inet_bo([TT cell_muestreo{idx_temp}(iter,:)]') < distance_tol
        % entonces esta en el convex hull no es necesario 
        % cambiarlo 
        pred_muestreo = cell_muestreo{idx_temp}(iter,:);
        title_pred = 'no proyectado';
    else
        % este dato esta lejos  del convex hull por lo que es necesario
        % proyectarlo 
        pred_muestreo = inet([TT cell_muestreo{idx_temp}(iter,:)]')';
        title_pred = 'proyectado';

    end
    subplot(3,2,count)
    bar([cell_muestreo{idx_temp}(iter,:);cell_new_muestreo{idx_temp}(iter,:);pred_muestreo]')
    grid on
    ylim([0 0.8])
    if count == 2
    legend('$\vec{\omega}_{out}$','$\vec{\omega}_{out}^P$','$\mathcal{P}^\sigma(\vec{\omega}_{out},T_r)$','Interpreter','latex','FontSize',15)
    end
    title("$T_r = "+num2str(TT,'%.0f')+" K$",'Interpreter','latex','FontSize',15)
    xticklabels(S)
    
    iter
end
%%
path_file = 'TimeSeries/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output';
genFunction(inet,fullfile(path_file,'proyection_in_convex_hull.m'),'MatrixOnly','yes')

%genFunction(inet_bo,fullfile(path_file,'check_convex_hull.m'),'MatrixOnly','yes')
%genFunction(inet,fullfile(path_file,'distance_dataset.m'),'MatrixOnly','yes')


