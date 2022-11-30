%%
clear 
load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')

control_ds = norm_control_ds;
state_ds   = norm_state_ds;
%%
full_ds = [state_ds control_ds];
%%
figure(1)
clf
vars =  full_ds.Properties.VariableNames;
nvars = length(vars);

ni = 0;
nj = 0;
for ivar = vars(1:end-1)
    ni = ni + 1;
    nj = 0;
    %
    for jvar = vars(1:end-1)
        nj = nj + 1;
        if nj <= ni
           continue  
        end
        subplot(nvars-1,nvars-1,(nvars-1)*(ni-1)+nj)
        is = scatter(full_ds.(ivar{:}),full_ds.(jvar{:}),[],full_ds.Temperature);
        is.Marker = '.';
      
        xlabel([ivar{:}],'Interpreter','latex','FontSize',8)
        ylabel([jvar{:}],'Interpreter','latex','FontSize',8)

    end
end
%%
svar = state_ds.Properties.VariableNames;
i = 0;
figure(1)
for ivar = svar
    i = i + 1;
   subplot(3,3,i)
   scatter(control_ds.Air_Fuel_Ratio,state_ds.(ivar{:}),[],control_ds.Temperature) 
   xlabel('Air_Fuel_Ratio','Interpreter','latex')
   ylabel(ivar{:},'Interpreter','latex')
end
i = 0;
figure(2)
for ivar = svar
    i = i + 1;
   subplot(3,3,i)
   scatter(control_ds.Steam_Fuel_Ratio,state_ds.(ivar{:}),[],control_ds.Temperature) 
   xlabel('Air_Fuel_Ratio','Interpreter','latex')
   ylabel(ivar{:},'Interpreter','latex')
end