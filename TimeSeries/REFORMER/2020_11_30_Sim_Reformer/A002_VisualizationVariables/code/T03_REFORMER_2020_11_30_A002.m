%% Visualizacion de estados vs controles
clear 
load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')

path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T01-ReformingDiesel/docs/report/img"

path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/ReformerModelling-Paper/img';

fig = figure('unit','norm','pos',[0 0 0.5 0.7])
set(fig,'renderer','Painters')
cds = control_dataset;
state_ds   = state_dataset;
%
fmt = {'Interpreter','latex','FontSize',40};
%

x_H2 = state_ds.H2_mole_out;
x_CO = state_ds.CO_mole_out;

%
u_T = cds.Temperature;
u_sf = cds.Steam_Fuel_Ratio;
u_af = cds.Air_Fuel_Ratio;

%%
scatter3(u_sf,u_af,x_H2,[],u_T,'.');
colormap('jet')
xlabel('$u_{s}$',fmt{:})
ylabel('$u_{a}$',fmt{:})
title('$x_{H2}$',fmt{:})
ic = colorbar;
ic.Label.FontSize = 30;
ic.Label.Interpreter = 'latex';
ic.Label.String = 'Temperature';
print(fig,fullfile(path,'x_H2.eps'),'-depsc')
%%
scatter3(u_sf,u_af,x_CO,[],u_T,'.');
colormap('jet')
xlabel('$u_{s}$',fmt{:})
ylabel('$u_{a}$',fmt{:})

title('$x_{CO}$',fmt{:})
ic = colorbar;
ic.Label.FontSize = 30;
ic.Label.Interpreter = 'latex';
ic.Label.String = 'Temperature';
print(fig,fullfile(path,'x_CO.eps'),'-depsc')
