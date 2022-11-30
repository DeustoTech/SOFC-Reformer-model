clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
%%
Input = reformer(:,{'steamfuelRatio','airfuelRatio','Temperatur'});
Output = reformer(:,{'outlet_H2O','outlet_CO','outlet_H2','outlet_CO2','outlet_CH4','outlet_N2'});
%%

%%
rng(200)
ni = size(Input,2);
no = size(Output,2);

hd = floor(linspace(ni,no,4));
net = feedforwardnet([10 10]);

%%
in_norm.mu = mean(Input{:,:});
in_norm.std = std(Input{:,:});
%
out_norm.mu = mean(Output{:,:});
out_norm.std = std(Output{:,:});
%%
Input_norm = (Input{:,:} - in_norm.mu)./in_norm.std;
Output_norm = (Output{:,:} - out_norm.mu)./out_norm.std;

%%
[net,tr_outlet] = train(net,Input_norm',Output_norm');
%%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/';
file = fullfile(file,'REFORMER.m');

genFunction(net,file)

%%
savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/outlet_norm.mat';
save(savepath,'in_norm','out_norm','tr_outlet');

