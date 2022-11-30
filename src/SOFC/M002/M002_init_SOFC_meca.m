
clear
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/nearst_nn_params.mat')

%% constant
p = SOFC_p;
x0_SOFC= SOFC_init;
%%
ids = ds{30};

Tmu = mean(ids{:,4:13},2);
p.Temperature = mean(Tmu);
outlet_xi_anode = ids(:,[14:(14+5)]);

inlet_vf_anode = ids(:,20:27);
inlet_vf_anode.pump_set  = (1/60)*inlet_vf_anode.pump_set;
inlet_vf_anode.Properties.VariableNames{end} = 'H2O_tar';
inlet_vf_anode = array2table(p.slpm2mol*inlet_vf_anode{:,:},'VariableNames',inlet_vf_anode.Properties.VariableNames);

%
inlet_vf_cathode.Air_tar = inlet_vf_anode.Air_01_tar + inlet_vf_anode.Air_02_tar;
inlet_vf_cathode.Air_tar = inlet_vf_cathode.Air_tar;
inlet_vf_cathode = struct2table(inlet_vf_cathode);

inlet_vf_anode.Air_01_tar = [];
inlet_vf_anode.Air_02_tar = [];
%
I     = ids.I153;
Vreal = ids.U153;
%
tspan = seconds(ids.Datetime - ids.Datetime(1));
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
I_signal.time = tspan;
I_signal.signals.values = I;
I_signal.signals.dimensions = 1;

%%
SOFC_parameters = SOFC_p;
SOFC_x0 = SOFC_init;
%%
%
set_param('M002_SOFC_meca','StopTime',num2str(Tend))
r = sim('M002_SOFC_meca');
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
fig = figure(2);
fig.Units = 'norm';
fig.Position = [0 0 0.4 0.7]
fig.Color = 'w'
sty={'LineWidth',2};
clf
I = rl.getElement('I').Values.Data;
V = rl.getElement('V').Values.Data;

subplot(3,2,1)
plot(r.tout,I,sty{:})
xlabel('time')
ylabel('I[A]')
grid on

legend('real')

subplot(3,2,3)
hold on

plot(r.tout,V,sty{:})
plot(tspan,Vreal,sty{:})

xlabel('time')
ylabel('V[A]')
grid on

legend('sim','real')
subplot(3,2,5)
hold on
plot(r.tout,V.*I,sty{:})
plot(tspan,ids.U153.*ids.I153,sty{:})

xlabel('time')
ylabel('W_e')
grid on

legend('sim','real')


subplot(2,2,2)
cla
hold on
ET = rl.getElement('ET').Values.Data;
plot(I,V,'.-',sty{:})
plot(ids.I153,ids.U153,'.-',sty{:})
plot(I,ET,'.-',sty{:})

legend('pred','real','ET')
grid on
xlabel('I[A]')
ylabel('V[V]')

grid on
%
subplot(2,2,4)
hold on
plot3(I,V.*I,r.tout,'.-',sty{:})
plot(ids.I153,ids.I153.*ids.U153,'.-',sty{:})

grid on
zlabel('time')
xlabel('I[A]')
ylabel('W_e[W]')
view(0,90)
legend('pred','real','ET')

%%
fig = figure(3);
fig.Color = 'w';
clf
subplot(2,1,1)
hold on 

ttspan = ids.Datetime(1) + seconds(tspan);
% [H2 O2 H2O N2 CO CH4 CO2]
plot(ttspan,outlet_xi_anode.H2_act,sty{:})
plot(ttspan,outlet_xi_anode.O2_act,sty{:})
plot(ttspan,0*outlet_xi_anode.O2_act,sty{:})
plot(ttspan,outlet_xi_anode.N2_act,sty{:})
plot(ttspan,outlet_xi_anode.CO_act,sty{:})
plot(ttspan,outlet_xi_anode.CH4_act,sty{:})
plot(ttspan,outlet_xi_anode.CO2_act,sty{:})
%plot(tspan,0*outlet_xi_anode.CO2_act,sty{:})
ylabel('%','Interpreter','latex')
legend('H2','O2','H2O','N2','CO','CH4','CO2')
title('Outlet Anode Dry Concentration - Real','Interpreter','latex','FontSize',15)
grid on
ylim([-10 100])

subplot(2,1,2)
ttspan = ids.Datetime(1) + seconds(r.tout);

dry_pa_out = rl.getElement('pa_out').Values.Data;
dry_pa_out(:,3) = 0;
dry_pa_out = 100*dry_pa_out./sum(dry_pa_out,2);
plot(ttspan,dry_pa_out(:,1:end-1),sty{:})
title('Outlet Anode Dry Concentration - Sim','Interpreter','latex','FontSize',15)
ylim([-10 100])
grid on
ylabel('%','Interpreter','latex')


legend('H2','O2','H2O','N2','CO','CH4','CO2')

%%



