clear

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/model01.mat')
clearvars -except newds
%%
T = 10;
tspan = linspace(0,T)';

ds = newds{1};
tspan = seconds(ds.DateTime - ds.DateTime(1));
T = tspan(end);
I = ds.I153;

MM = Molar_kg_mol;

S = ["H2","N2","CO","CH4","CO2"];

for i = S
    eval(i{:}+" = ds."+i{:}+"_tar/MM."+i{:})
end

H2O = H2*0;
O2  = H2*0;

anode_mol_inlet_flow.signals.values = [H2 O2 H2O N2 CO CH4 CO2]; 
anode_mol_inlet_flow.signals.dimensions = 7;
anode_mol_inlet_flow.time = tspan;

air_mass_inlet_flow.signals.values = ds.AirMass;
air_mass_inlet_flow.signals.dimensions = 1;
air_mass_inlet_flow.time = tspan;

%

%
%% Current
I_signal.time = tspan;
%I = 1/2*(1 + 1*sign(sin(4*pi*tspan/T)).*abs(sin(4*pi*tspan/T)).^(0.15));
%I = 1 + 30*tspan/T;
%I(1) = 0;

I_signal.signals.values = I;
I_signal.signals.dimensions = 1;

%%
Vreal = ds.U153;
%% [H2 O2 H2O N2 CO CH4 CO2]



p.MM = MM;
Tmu = mean(ds{:,2:5},'all');
p.Temperature = Tmu;
%
p.Gibbs.H2 = Gibbs(Tmu,'H2');
p.Gibbs.CO = Gibbs(Tmu,'CO');
p.Gibbs.CH4 = Gibbs(Tmu,'CH4');
p.Gibbs.O2 = Gibbs(Tmu,'O2');
p.Gibbs.H2O = Gibbs(Tmu,'H2O');
p.Gibbs.CO2 = Gibbs(Tmu,'CO2');

Gibbs_simulink = Simulink.Bus.createObject(p.Gibbs);

%%
%
p.atm = 101325; % atm to Pa
p.R = 8.31446261815324; % [J/(K.mol)] 
p.F = 96485.3329; % C/mol
%
p.Vanode = 0.25; % m^3
p.Vcatho = 0.25; % m^3
p.N0 = 30; % Cells number


p.Kr = p.N0/(4*p.F); 

p.K_an = 0.0377; % kmol/(atm . s)
p.K_cath = 0.0377; % kmol/(atm . s)

p.K_an_SI = 1e3*p.K_an/p.atm; % mol/(Pa . s)
p.K_cath_SI = 1e3*p.K_cath/p.atm; % mol/(Pa . s)
%
MMs = [p.MM.H2 p.MM.O2 p.MM.H2O p.MM.N2 p.MM.CO  p.MM.CH4 p.MM.CO2 ];
%
p.ValveConstants_an   = p.K_an_SI./sqrt(MMs);% Valve molar Constants [mol/(s.Pa)]
p.ValveConstants_cath = p.K_cath_SI./sqrt(MMs);% Valve molar Constants [mol/(s.Pa)]
%
p.r =    0.05; % Ohm 
%
set_param('SOFC_meca','StopTime',num2str(T))
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

%%
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

subplot(3,2,5)
hold on
plot(r.tout,V.*I)
plot(tspan,ds.U153.*ds.I153)

xlabel('time')
ylabel('W_e')


subplot(2,2,2)
cla
hold on
plot(I,V,'.-')
plot(ds.I153,ds.U153,'.-')
legend('pred','real')
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

