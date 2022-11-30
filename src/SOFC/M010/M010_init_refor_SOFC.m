clear
load('TimeSeries/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
load('TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/nearst_nn_params.mat')
load('meta_SOFC_ds.mat')


%OP1 = rd('20220810_1130_1333_OP1');
%OP = rd('20220810_1342_1545_OP2');
%OP = rd('20220811_1240_1400_OP2_afterSteamError');
OP = rd('20220811_1410_1550_OP3_afterSteamError');
%OP = rd('20220811_1615_1700_OP4_afterSteamError');

%OP4 11.63771518
%Diesel = 11.63771518; % ml/min;

%OP3 7.829560535
%Diesel = 7.829560535; % ml/min;

%OP2 6.509169953
Diesel = 6.509169953; % ml/min;

%OP1 4.412173515
%Diesel = 4.412173515; % ml/min;



DT = days(OP.Datetime - OP.Datetime(1));
Tf = DT(end);
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
Tr = OP.TIR213C;


tspan = days(OP.Datetime- OP.Datetime(1));

rho_diesel = 0.85 ; % kg/l
Diesel = Diesel*1e-3/60; % l/s;
Diesel = Diesel*rho_diesel; % kg/s

Air = OP.FIRC_2_1mlmin; % ml/min;
rho_Air = 1.29*1e-3;%kg/l
Air = Air*1e-3/60*rho_Air;

Air_st.signals.values = Air;
Air_st.signals.dimensions = 1;
Air_st.time = tspan;
%
Steam = OP.waterFlowratemlmin;
%rho_Steam = 0.535;%kg/m^3;
rho_Steam = 0.535*1e-3;%kg/l;

Steam = Steam*1e-3/60*rho_Steam;

Steam_st.signals.values = Steam;
Steam_st.signals.dimensions = 1;
Steam_st.time = tspan;
%

Temp_st.signals.values = 0.5*OP.TIRC215C + 0.5*OP.TIR213C;
Temp_st.signals.dimensions = 1;
Temp_st.time = tspan;
%Target = Target./MM_vec';
%%

r = sim('M010_refor_control_SOFC');

%%

r_st = parseIndoorClimate(r.yout{1},r.tout);
r_st.t = OP.Datetime(1) + days(r.tout);
r_st.CxHy_ppm = r.yout{2}.Values.Data;
figure(1)
clf
plot_gr_compare(OP,r_st)