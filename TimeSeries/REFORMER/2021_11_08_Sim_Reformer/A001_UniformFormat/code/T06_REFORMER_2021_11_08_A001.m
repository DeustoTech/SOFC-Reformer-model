clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/dataset02_massfractions.mat')

%%
Input = reformer_mass(:,{'steamfuelRatio','airfuelRatio','Temperatur'});
Output = reformer_mass(:,{'outlet_H2O','outlet_CO','outlet_CO2',  'outlet_H2',  'outlet_CH4' ,'outlet_N2',            ...
                          'inlet_H2O'             ,'inlet_CO2'                               ,'inlet_N2' , 'inlet_C','inlet_O2'});
                      
%%
figure(1)

vars = Input.Properties.VariableNames;
iter = 0;
for ivar = vars
   iter = iter + 1;
   subplot(3,1,iter )

   histogram(Input.(ivar{:}) )
   title(ivar,'Interpreter','none')
end

figure(2)
vars = Output.Properties.VariableNames;
iter = 0;
for ivar = vars
   iter = iter + 1;
   subplot(3,4,iter )

   histogram(Output.(ivar{:}) )
   title(ivar,'Interpreter','none')
end