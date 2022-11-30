
clear
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
%% constant
p.R = 8.31446261815324; % [J/(K.mol)] 
p.F = 96485.3329;       % C/mol
p.atm = 101325; % atm to Pa

p.slpm2mol = p.atm/(6e4*p.R*(273.15));
%%
ids = ds{10};

Tmu = mean(ids{:,4:13},2);

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

MM = Molar_kg_mol;

H2  = inlet_vf_anode.H2_tar;
H2O = inlet_vf_anode.H2O_tar;
N2  = inlet_vf_anode.N2_tar;
CO  = inlet_vf_anode.CO_tar;
CH4 = inlet_vf_anode.CH4_tar;
CO2 = inlet_vf_anode.CO2_tar;
%
O2  = H2*0;
%
anode_mol_inlet_flow.signals.values = [H2 O2 H2O N2 CO CH4 CO2]; 
anode_mol_inlet_flow.signals.dimensions = 7;
anode_mol_inlet_flow.time = tspan;

air_mol_inlet_flow.signals.values = inlet_vf_cathode.Air_tar;
air_mol_inlet_flow.signals.dimensions = 1;
air_mol_inlet_flow.time = tspan;

%% Current
I_signal.time = tspan;
I_signal.signals.values = I;
I_signal.signals.dimensions = 1;

%% [H2 O2 H2O N2 CO CH4 CO2]

p.MM = MM;
p.Temperature = mean(Tmu);
%
p.Gibbs.H2 = Gibbs(mean(Tmu),'H2');
p.Gibbs.CO = Gibbs(mean(Tmu),'CO');
p.Gibbs.CH4 = Gibbs(mean(Tmu),'CH4');
p.Gibbs.O2 = Gibbs(mean(Tmu),'O2');
p.Gibbs.H2O = Gibbs(mean(Tmu),'H2O');
p.Gibbs.CO2 = Gibbs(mean(Tmu),'CO2');
%%
p.Enthalpy.H2 = Enthalpy(mean(Tmu),'H2');
p.Enthalpy.CO = Enthalpy(mean(Tmu),'CO');
p.Enthalpy.CH4 = Enthalpy(mean(Tmu),'CH4');
p.Enthalpy.O2 = Enthalpy(mean(Tmu),'O2');
p.Enthalpy.H2O = Enthalpy(mean(Tmu),'H2O');
p.Enthalpy.CO2 = Enthalpy(mean(Tmu),'CO2');

Gibbs_simulink = Simulink.Bus.createObject(p.Gibbs);

%%
%
p.atm = 101325; % atm to Pa
p.Vanode = 0.5; % m^3
p.Vcatho = 0.5; % m^3
p.N0 = 30; % Cells number
p.pressure = p.atm;
%p.Kr = p.N0/(4*p.F); 

p.K_an = 0.0377; % kmol/(atm . s)  % paper
p.K_cath = 0.0377; % kmol/(atm . s) % paper

p.K_an = 0.005; % kmol/(atm . s)
p.K_cath = 0.005; % kmol/(atm . s)

p.K_an_SI = 1e3*p.K_an/p.atm; % mol/(Pa . s)

p.K_cath_SI = 1e3*p.K_cath/p.atm; % mol/(Pa . s)
%
MMs = [p.MM.H2 p.MM.O2 p.MM.H2O p.MM.N2 p.MM.CO  p.MM.CH4 p.MM.CO2 ];
%
p.ValveConstants_an   = p.K_an_SI./sqrt(MMs);% Valve molar Constants [mol/(s.Pa)]
p.ValveConstants_cath = p.K_cath_SI./sqrt(MMs);% Valve molar Constants [mol/(s.Pa)]
%
p.r =    0.15; % Ohm 
%
set_param('SOFC_meca','StopTime',num2str(Tend))
r = sim('SOFC_meca');
rl = r.logsout;

%%
pa = rl.getElement('pa').Values.Data;
vf_a = 100*pa./sum(pa,2);
pc = rl.getElement('pc').Values.Data;
vf_c = 100*pc./sum(pc,2);
qin = rl.getElement('qin_anode').Values.Data;
qin = 100*qin./sum(qin,2);
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

Gases = {'H2','O2','H2O','N2','CO','CH4','CO2'};
figure(1)
clf 
sty = {'LineWidth',2};
%
subplot(3,2,1)
plot(r.tout,zeros(length(r.tout),7)'+qin',sty{:})
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
plot(r.tout,zeros(length(r.tout),7)'+qin_cath',sty{:})
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
figure(2)
clf
I = rl.getElement('I').Values.Data;
V = rl.getElement('V').Values.Data;

subplot(3,2,1)
plot(r.tout,I)
xlabel('time')
ylabel('I[A]')

subplot(3,2,3)
hold on

plot(r.tout,V)
plot(tspan,Vreal)

xlabel('time')
ylabel('V[A]')
legend('Vsim','Vreal')
subplot(3,2,5)
hold on
plot(r.tout,V.*I)
plot(tspan,ids.U153.*ids.I153)

xlabel('time')
ylabel('W_e')
legend('Vsim','Vreal')


subplot(2,2,2)
cla
hold on
ET = rl.getElement('ET').Values.Data;
plot(I,V,'.-')
plot(ids.I153,ids.U153,'.-')
plot(I,ET,'.-')

legend('pred','real','ET')
grid on
xlabel('I[A]')
ylabel('V[V]')

%
subplot(2,2,4)
plot3(I,V.*I,r.tout,'.-')
grid on
zlabel('time')
xlabel('I[A]')
ylabel('W_e[V]')
view(0,90)

%%
figure(3)
clf
subplot(2,1,1)
hold on 

% [H2 O2 H2O N2 CO CH4 CO2]
plot(tspan,outlet_xi_anode.H2_act,sty{:})
plot(tspan,outlet_xi_anode.O2_act,sty{:})
plot(tspan,0*outlet_xi_anode.O2_act,sty{:})
plot(tspan,outlet_xi_anode.N2_act,sty{:})
plot(tspan,outlet_xi_anode.CO_act,sty{:})
plot(tspan,outlet_xi_anode.CH4_act,sty{:})
plot(tspan,outlet_xi_anode.CO2_act,sty{:})
legend('H2','O2','H2O','N2','CO','CH4','CO2')
title('Outlet Anode Dry Concentration - Real')

ylim([-10 100])

subplot(2,1,2)
dry_pa_out = rl.getElement('pa_out').Values.Data;
dry_pa_out(:,3) = 0;
dry_pa_out = 100*dry_pa_out./sum(dry_pa_out,2);
plot(r.tout,dry_pa_out,sty{:})
title('Outlet Anode Dry Concentration - Sim')
ylim([-10 100])

legend('H2','O2','H2O','N2','CO','CH4','CO2')

%%



