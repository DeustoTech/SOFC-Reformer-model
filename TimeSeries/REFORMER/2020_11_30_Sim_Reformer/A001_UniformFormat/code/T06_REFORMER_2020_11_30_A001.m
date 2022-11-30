%%
clear
load('TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
ds = dataset01;
ds(ds.Temperature < 700,:) = [];
%%
clf
scatter3(ds.H2_mole_out,ds.CO_mole_out,ds.CH4_mole_out,[],ds.Temperature)
ylabel('CO')
xlabel('H2')
zlabel('CH4')
colorbar
grid on