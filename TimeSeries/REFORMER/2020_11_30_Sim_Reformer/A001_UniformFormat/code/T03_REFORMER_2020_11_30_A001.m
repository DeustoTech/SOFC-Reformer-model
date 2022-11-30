clear 
load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset02.mat')
%%
[norm_control_ds , mean_control , std_control] = NormalizedTable(control_dataset);
[norm_state_ds   , mean_state   , std_state  ] = NormalizedTable(state_dataset);
%
save("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')
%%
