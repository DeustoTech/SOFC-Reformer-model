clear
load('TimeSeries/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
load('TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/nearst_nn_params.mat')
load('meta_SOFC_ds.mat')

ds = dataset01;
SOFC_Temperature = 700;

%%
MM = Molar_kg_mol;
%MM_simulink = Simulink.Bus.createObject(MM);
MM_vec = struct2array(MM)';
%

%%
idx  = 500;
Tr = ds.Temperature(idx);
%Target = Target./MM_vec';
%%
load('TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
%% constant
p = SOFC_p;
x0_SOFC= SOFC_init;
%%
ids = ds{3};
%
Tmu = mean(ids{:,4:13},2);
Ts = mean(Tmu);
outlet_xi_anode = ids(:,[14:(14+5)]);
%
inlet_vf_anode = ids(:,20:27);
inlet_vf_anode.pump_set  = (1/60)*inlet_vf_anode.pump_set;
inlet_vf_anode.Properties.VariableNames{end} = 'H2O_tar';
inlet_vf_anode = array2table(p.slpm2mol*inlet_vf_anode{:,:},'VariableNames',inlet_vf_anode.Properties.VariableNames);
%
target_vf_anode = inlet_vf_anode(10,:);
%
H2_target  = target_vf_anode.H2_tar;
CO2_target = target_vf_anode.CO2_tar;
CO_target  = target_vf_anode.CO_tar;
CH4_target = target_vf_anode.CH4_tar;
N2_target  = target_vf_anode.N2_tar;
H2O_target = target_vf_anode.H2O_tar;

idx = 1;
Target = [ data.H2(idx)   ; ... H2
           0           ; ... O2
           data.H2O(idx)  ; ... H2O
           data.N2(idx)   ; ... N2
           data.CO(idx)   ; ... CO
           CH4_target  ; ... CH4
           data.CO2(idx)  ; ... CO2
           0           ; ... Diesel
           0           ; ... Ar
           0          ]'; ... Csoot
           
TotalMassTarget = 1e-3;
%
Target = Target/TotalMassTarget;

%%
% 
inlet_vf_cathode.Air_tar = inlet_vf_anode.Air_01_tar + inlet_vf_anode.Air_02_tar;
inlet_vf_cathode.Air_tar = inlet_vf_cathode.Air_tar;
inlet_vf_cathode = struct2table(inlet_vf_cathode);
%
inlet_vf_anode.Air_01_tar = [];
inlet_vf_anode.Air_02_tar = [];
%
I     = ids.I153;
Vreal = ids.U153;
%
tspan = days(ids.Datetime - ids.Datetime(1));

Tend  = tspan(end);
%%

%MM = Molar_kg_mol;

H2  = inlet_vf_anode.H2_tar;
H2O = inlet_vf_anode.H2O_tar;
N2  = inlet_vf_anode.N2_tar;
CO  = inlet_vf_anode.CO_tar;
CH4 = inlet_vf_anode.CH4_tar;
CO2 = inlet_vf_anode.CO2_tar;
Diesel = CO2*0;
O2  = H2*0;
Ar = H2*0;
Csoot = H2*0;

%
anode_mol_inlet_flow.signals.values = [H2 O2 H2O N2 CO CH4 CO2 Diesel Ar Csoot]; 
anode_mol_inlet_flow.signals.dimensions = 10;
anode_mol_inlet_flow.time = tspan;

air_mol_inlet_flow.signals.values = inlet_vf_cathode.Air_tar;
air_mol_inlet_flow.signals.dimensions = 1;
air_mol_inlet_flow.time = tspan;

%% Current
Is.time = tspan;
Is.signals.values = I;
Is.signals.dimensions = 1;

%%
SOFC_parameters = SOFC_p;
SOFC_x0 = SOFC_init;

SOFC_x0.pa  = 0* SOFC_x0.pa + 1;
SOFC_x0.pc  = 0* SOFC_x0.pc + 1;
%%

set_param('M008_refor_control_SOFC','StopTime',num2str(Tend))
r= sim('M008_refor_control_SOFC');
%%
% 
%   for x = 1:10
%       disp(x)
%   end
% 
%%
out = r.logsout.getElement('out');
out = out.Values.Data;
%%
figure(1)
clf
S = {'\color[rgb]{1 0 0}H2', ...
      'O2', ...
      '\color[rgb]{1 0 0}H2O', ...
      'N2', ...
      '\color[rgb]{1 0 0}CO',  ...
      '\color[rgb]{1 0 0}CH4', ...
      '\color[rgb]{1 0 0}CO2', ...
      'Diesel', ...
      'Ar', ...
      'Csoot'};
%
subplot(2,1,1)
Target_norm = Target./sum(Target);
Real_norm   = out(end,:)./sum(out(end,:));
ibarp = bar([Target_norm' Real_norm'],'grouped')
legend('Target','Obtain')
xticklabels(S)
subplot(2,1,2)
hold on
plot(r.tout,sum(out,2))
yline(sum(Target))

%%
rl = r.logsout;

figure(8)
clf
subplot(2,1,1)
Target_norm_Red = [Target_norm([1 3 5 6 7]) sum(Target_norm([2 4 8 9 10]))];
Target_norm_Red = Target_norm_Red./sum(Target_norm_Red);
%
Real_norm_Red = [Real_norm([1 3 5 6 7]) sum(Real_norm([2 4 8 9 10]))];
Real_norm_Red = Real_norm_Red./sum(Real_norm_Red); 
%
ibarp = bar([Target_norm_Red' Real_norm_Red'],'grouped');

S = {'\color[rgb]{1 0 0}H2', ...
      '\color[rgb]{1 0 0}H2O', ...
      '\color[rgb]{1 0 0}CO',  ...
      '\color[rgb]{1 0 0}CH4', ...
      '\color[rgb]{1 0 0}CO2', ...
      'others'};

xticklabels(S)

legend('target','obtain')

subplot(2,1,2)


Diesel = rl.getElement('Diesel').Values.Data;
Air = rl.getElement('Air').Values.Data;
Steam = rl.getElement('Steam').Values.Data;

inlet_reformer = [Diesel Air Steam];
inlet_reformer = inlet_reformer./sum(inlet_reformer,2);
%
subplot(2,1,2)
bar(mean(inlet_reformer))
xticklabels({'Diesel','Air','Steam'})

%%

%%
rl = r.logsout;
%%
pa   = rl.getElement('pa').Values.Data;
vf_a = 100*pa./sum(pa,2);
pc   = rl.getElement('pc').Values.Data;
vf_c = 100*pc./sum(pc,2);
qin  = rl.getElement('qin_anode').Values.Data;
qin  = 100*qin./sum(qin,2);
%
qin_cath = rl.getElement('qin_cath').Values.Data;
qin_cath = 100*qin_cath./sum(qin_cath,2);
%
pa_out = rl.getElement('pa_out').Values.Data;
pa_out = 100*pa_out./sum(pa_out,2);
%
%
pc_out = rl.getElement('pc_out').Values.Data;
pc_out = 100*pc_out./sum(pc_out,2);

Gases = {'H2','O2','H2O','N2','CO','CH4','CO2','Diesel'};
figure(1)
clf 
sty = {'LineWidth',2};
%
subplot(3,2,1)
plot(r.tout,zeros(length(r.tout),10)'+qin',sty{:})
title('Inlet Anode Concentration')
legend(Gases)
ylim([-10 100])

%
subplot(3,2,3)
plot(r.tout,vf_a',sty{:})
title('Anode  %')
ylim([-10 100])
legend(Gases)
%
subplot(3,2,5)
plot(r.tout,pa_out,sty{:})
title('Outlet Anode Concentration')
legend(Gases)
ylim([-10 100])

%
subplot(3,2,2)
plot(r.tout,zeros(length(r.tout),10)'+qin_cath',sty{:})
title('Inlet Cathode Concentration')
legend(Gases)
ylim([-10 100])

%
subplot(3,2,4)
plot(r.tout,vf_c',sty{:})
title('Cathode%')
ylim([-10 100])
legend(Gases)
ylim([-10 100])

%
subplot(3,2,6)
plot(r.tout,pc_out,sty{:})
title('Outlet Cathode Concentration')
legend(Gases)
ylim([-10 100])

%%
% 

I = rl.getElement('I').Values.Data;
V = rl.getElement('V').Values.Data;
%
I_interp = interp1(rl.getElement('I').Values.Time,rl.getElement('I').Values.Data,r.tout);
%
figure(1)
clf
plot(I_interp,V.*I_interp)


%%
figure(1)
clf
hold on
plot(r.tout,Diesel)
plot(r.tout,Air)
plot(r.tout,Steam)
ylim([0 0.0006])
legend('Diesel','Air','Steam')
