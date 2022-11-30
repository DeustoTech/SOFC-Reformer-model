clear

load('TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/REFORMER_fcn.mat')
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/params_SOFC.mat')
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/validate_data.mat')

%
%mf = uniquetol(newds{1}{:,input_vars(1:6)},'ByRows',1);
%mf(1) = 1e-3;
%mf(2) = 1e-3;
        % H2O      CO      CO2      H2        CH4       N2        
mf_min = [0        0       0        1.53e-5   0         0        ];
%
mf_max = [2.31e-4  7.32e-5 18.28e-5 2.96e-5   15.54e-6  5.91e-4  ];
%
mf = mf_min + (mf_max - mf_min).*rand(size(mf_min));
mf = uniquetol(newds{1}{:,input_vars(1:6)},'ByRows',1);

%
mf_air_min = 1.28e-3;
mf_air_max = 1.70e-3;

Air = mf_air_min + (mf_air_min - mf_air_max).*rand(size(mf_air_min));
Air = mean(newds{1}.AirMass);

%%

set_param('M003_refor_meca','StopTime','100')
r = sim('M003_refor_meca');
%%
fig = figure('unit','norm','pos',[0 0 0.3 0.5]);
X = r.logsout.getElement('Xmid').Values.Data;

% H2 O2 H2O N2 CO CH4 CO2 Diesel

subplot(2,2,1)

plot(r.tout,X(:,[1 2 3 7]),'LineWidth',2)
ylabel('kg/s')
xlabel('time')
legend('H2O','CO','CO2','Diesel')
grid on 


subplot(2,2,2)
plot(r.tout,X(:,[4 6 8]),'LineWidth',2)
xlabel('time')
ylabel('kg/s')
grid on 

legend('H2','N2','O2')
subplot(2,2,3)
plot(r.tout,X(:,5),'LineWidth',2)
xlabel('time')
ylabel('kg/s')
grid on 

legend('CH4')

subplot(2,2,4)
a = r.logsout.getElement('a').Values.Data;
plot(r.tout,a,'LineWidth',2)
xlabel('time')
ylabel('a(t)')
legend('a(t)')
grid on 


file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img/deactivation.eps';
fig.Renderer = 'painters';
print(fig,file,'-depsc')