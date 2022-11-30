clear
load('TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
%%
iter = 0;
ds_old = ds;
for ids = ds
    iter = iter + 1;
   for ivar = ids{:}.Properties.VariableNames(3:end)
      ds{iter}.(ivar{:}) = smoothdata(ids{:}.(ivar{:}),1,'SmoothingFactor',0.01);
   end
end


%%
vars =  {'Air_01_tar', 'H2_tar','CO2_tar','CO_tar','Air_02_tar','CH4_tar','N2_tar'};

Mair = 28.97;    % g/mol;
MH2  = 2.0158;   % g/mol;
MCO2 = 44.00;    % g/mol;
MCO = 28.01;    % g/mol;
MCH4 = 16.0425;  % g/mol;
MN2  = 28.01340; % g/mol;
%
MM = {Mair,MH2,MCO2,MCO,Mair,MCH4,MN2};
%
T0 = 273.15; % K
P0 = 1e5; % Pa
%
R = 8.314; % J/(mol K)
%%
for i = 1:length(vars)
    for j = 1:length(ds)
         ds{j}.(vars{i}) = ds{j}.(vars{i})*(1e-6*P0*MM{i})/(R*T0*60);
    end
end

MH2O = 18.01528; % g/mol
for j = 1:length(ds)
    ds{j}.pump_set = ds{j}.pump_set*(1e-6*P0*MH2O)/(R*T0*3600);
end
%%
newds = {};
new_vars = [{'Datetime','T1','T3','T4','T5','pump_set'} vars {'I153','U153'}];

for j = 1:length(ds)
   newds{j} = ds{j}(:,new_vars);
   newds{j}.Properties.VariableNames{1} = 'DateTime';
   newds{j}.Properties.VariableNames{2} = 'T_out_air';
   newds{j}.Properties.VariableNames{3} = 'T_int_fuel';
   newds{j}.Properties.VariableNames{4} = 'T_out_fuel';
   newds{j}.Properties.VariableNames{5} = 'T_int_air';
   newds{j}.FuelMass = sum(newds{j}{:,{'pump_set','H2_tar','CO2_tar','CO_tar','CH4_tar','N2_tar'}},2);
   newds{j}.AirMass = sum(newds{j}{:,{'Air_01_tar','Air_02_tar'}},2);
   %
   newds{j}.dT_air = newds{j}.T_out_air - newds{j}.T_int_air;
   newds{j}.dT_fuel = newds{j}.T_out_fuel- newds{j}.T_int_fuel;
   
   
end

%%
newds_Ts = arrayfun(@(i) TableSeries(newds{i}),1:length(newds))

%%


%%
ds_all = vertcat(newds{1:30});

%%

input_vars = {'pump_set','H2_tar','CO2_tar','CO_tar','CH4_tar','N2_tar','Air_01_tar','Air_02_tar','T_int_air','T_int_fuel','I153'};
input_vars = {'pump_set','CO_tar','CO2_tar','H2_tar','CH4_tar','N2_tar','AirMass','T_int_air','T_int_fuel','I153'};

inputs = ds_all(:,input_vars);

mu_in = mean(inputs{:,:},1);
std_in = std(inputs{:,:},[],1);

output_vars = {'U153','dT_air','dT_fuel'};
outputs = ds_all(:,output_vars);

mu_out = mean(outputs{:,:},1);
std_out = std(outputs{:,:},[],1);
%%
nin = length(input_vars);
nout = length(output_vars);

hd = linspace(nin,nout,3);

hd = floor(hd);
%hd = hd(2:end);
%
rng(100)
inet = feedforwardnet(hd);
inet.performParam.regularization = 1e-5;
%%
input_norm = (inputs{:,:}' - mu_in' )./std_in';
output_norm = (outputs{:,:}' - mu_out' )./std_out';

inet.trainParam.mu_dec = 1/10;
inet.trainParam.mu_inc = 10;

%rng(100)
rng(1000)

[inet,r] = train(inet,input_norm,output_norm);

fcn_pred = @(in) inet((in' - mu_in')./std_in').*std_out' + mu_out';

%%
pathfile =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output';
save(fullfile(pathfile,'model01'),'fcn_pred','input_vars','output_vars','newds');

pathfile =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output';
params_SOFC.mu_in = mu_in;
params_SOFC.std_in = std_in;
params_SOFC.mu_out = mu_out;
params_SOFC.std_out = std_out;

save(fullfile(pathfile,'params_SOFC'),'params_SOFC');

%%

file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/';
file = fullfile(file,'SOFC_mf.m');
genFunction(inet,file,'MatrixOnly','yes')
%%
file =    '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/validate_data.mat';

save(file,'newds','input_vars','fcn_pred','output_vars','r')

%%
figure(2)
plot(log(r.perf))

fig = figure(1);
clf
hold on 
plot(log(r.perf),'LineWidth',2,'LineStyle','-')
ylabel('$log(mse)$','Interpreter','latex','FontSize',20)
xlim([0 250])
xlabel('$epochs$','Interpreter','latex','FontSize',20)
grid on
legend('$\mathcal{H}(\cdot)$','FontSize',20,'Interpreter','Latex')

path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img';
fig.Children(2).FontSize = 20;

fig.Children(2).XAxis.TickLabelInterpreter = 'latex';
fig.Children(2).YAxis.TickLabelInterpreter = 'latex';
print(fig,fullfile(path,'perform_nn_SOFC.eps'),'-depsc')
