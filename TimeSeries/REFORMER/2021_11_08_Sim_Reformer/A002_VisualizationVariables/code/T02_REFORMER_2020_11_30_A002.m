%% Distribución de Controles 
clear 
load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')

cds = control_dataset;
state_ds   = state_dataset;
%%
fmt = {'Interpreter','latex','FontSize',25}
fig = figure('unit','norm','pos',[0 0 0.7 0.7])
set(fig,'renderer','Painters')

subplot(2,2,4)
plot3(cds.Air_Fuel_Ratio,cds.Steam_Fuel_Ratio,cds.Temperature,'.','MarkerSize',4);
xlabel("$u_{af}$",fmt{:})
ylabel("$u_{sf}$",fmt{:})
zlabel("$u_{T}$",fmt{:})

grid on
box
path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T01-ReformingDiesel/docs/report/img"
%print(fig,'-depsc',fullfile(path,'controldistri.eps'));

%%

fmt = {'Interpreter','latex','FontSize',25}

subplot(2,2,1)
histogram(cds.Air_Fuel_Ratio);
title('$u_{af}$',fmt{:})
ylabel('#')
subplot(2,2,2)
histogram(cds.Steam_Fuel_Ratio);
title('$u_{sf}$',fmt{:})
ylabel('#')
subplot(2,2,3)
histogram(cds.Temperature);
title('$u_{T}$',fmt{:})
ylabel('#')

print(fig,'-depsc',fullfile(path,'controldistri_histo.eps'));
