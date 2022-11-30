clear

%%
MM = Molar_kg_mol;
MM = struct2array(MM);
load('TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/REFORMER_fcn.mat')
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/params_SOFC.mat')
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/validate_data.mat')

%

%%

set_param('M004_refor_control','StopTime','3')
r = sim('M004_refor_control');
%%
fig = figure('unit','norm','pos',[0 0 0.3 0.5]);
X = r.logsout.getElement('Xmid').Values.Data;
X = X./sum(X,2);
% H2 O2 H2O N2 CO CH4 CO2 Diesel
%  1  2  3  4  5   6   7   8
subplot(2,2,1)

plot(r.tout,X(:,[3 5 7 8]),'LineWidth',2)
ylabel('kg/s')
xlabel('time')
legend('H2O','CO','CO2','Diesel')
grid on 


subplot(2,2,2)
plot(r.tout,X(:,[1 4 2]),'LineWidth',2)
xlabel('time')
ylabel('kg/s')
grid on 
legend('H2','N2','O2')


subplot(2,2,3)
plot(r.tout,X(:,6),'LineWidth',2)
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
%%

file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img/deactivation.eps';
fig.Renderer = 'painters';
print(fig,file,'-depsc')