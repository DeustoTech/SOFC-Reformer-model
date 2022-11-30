clear 

load('TimeSeries/SOFC-REFORMER/2021-03-04-SOFC-REFORMER-Martin/A001_UniformFormat/output/ds.mat')

%
ds = ReformerPlusStackData;
%
ds((ds.OperatingTemperature < 800),:) = [];
ds((ds.OperatingTemperature > 850),:) = [];

ds((ds.currentPerStack > 10),:) = [];

%%
scatter3(ds.ReformerexitMassCO,ds.ReformerexitMassH2,ds.Powerelectrical./ds.currentPerStack,ds.AirFuelRatiomass,ds.StackAirFlow)
colorbar