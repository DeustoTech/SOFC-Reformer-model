clear
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/personal/phd/GreenHouseFolder/GreenHouseModel/TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
ds = dataset01;

%%
MM = Molar_kg_mol;
MM_simulink = Simulink.Bus.createObject(MM);
MM_vec = struct2array(MM)';
%

%%
idx  = 500;

%        H2 .   O2   H2O .   N2 .   CO .  CH4 .  CO2 .  Diesel . Ar .Csoot
Target= [ ds.H2_mass_out(idx), ...      % H2
          0, ...                        % O2
          ds.H2O_mass_out(idx), ...     % H2O
          ds.N2_mass_out(idx), ...      % N2
          ds.CO_mass_out(idx), ...      % CO
          ds.CH4_mass_out(idx), ...     % CH4
          ds.CO2_mass_out(idx), ...     % CO2
          0, ...                        % Diesel
          ds.Ar_mass_out(idx), ...      % Ar
          ds.C_soot_mass_out(idx), ...  % Csoot
          ];
Temperature = ds.Temperature(idx);
Target = 1e-3*Target;
Target = Target./MM_vec';
%%

set_param('M006_refor_control','StopTime','10')
r = sim('M006_refor_control');
%%
out = r.logsout.getElement('out');
out = out.Values.Data;
%%
figure(1)
clf
S = {'H2','O2','H2O','N2','CO','CH4','CO2','Diesel','Ar','Csoot'}


subplot(2,1,1)
Target_norm = Target./sum(Target);
Real_norm   = out(end,:)./sum(out(end,:));
bar([Target_norm' Real_norm'],'grouped')
legend('Target','Obtain')
xticklabels(S)
subplot(2,1,2)
hold on
plot(r.tout,sum(out,2))
yline(sum(Target))


%%
Air = r.logsout.getElement('Air');
Air.Values.Data