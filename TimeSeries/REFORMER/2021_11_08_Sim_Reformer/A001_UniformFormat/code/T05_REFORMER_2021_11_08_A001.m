clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/dataset02_massfractions.mat')

%%
Input = reformer_mass(:,{'steamfuelRatio','airfuelRatio','Temperatur'});
Output = reformer_mass(:,{'outlet_H2O','outlet_CO','outlet_CO2',  'outlet_H2',  'outlet_CH4' ,'outlet_N2',            ...
                          'inlet_H2O'             ,'inlet_CO2'                               ,'inlet_N2' , 'inlet_C','inlet_O2'});

%%
ni = size(Input,2);
no = size(Output,2);

hd = linspace(ni,no,3);
hd = floor(hd);
net = feedforwardnet(hd);

net.trainParam.mu_inc = 2;
net.trainParam.mu_dec = 1/2;
%%
mu_in  = mean(Input{:,:}',2);
std_in = std(Input{:,:}',[],2);
%
mu_out  = mean(Output{:,:}',2);
std_out = std(Output{:,:}',[],2);
%% Normalize
Input_norm  = (Input{:,:}'  - mu_in )./std_in;
Output_norm = (Output{:,:}' - mu_out)./std_out;
%%
rng(5000)
net = train(net,Input_norm,Output_norm);
%%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/';
file = fullfile(file,'REFORMER_mf.m');

genFunction(net,file,'MatrixOnly','yes')

%%
%RFOR_MF_DENORM = @(x) REFORMER_mf((x - mu_in)./std_in).*std_out + mu_out;

file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/';
file = fullfile(file,'REFORMER_fcn.mat');

params.mu_in = mu_in;
params.std_in = std_in;
params.mu_out = mu_out;
params.std_out = std_out;

save(file,'params')
