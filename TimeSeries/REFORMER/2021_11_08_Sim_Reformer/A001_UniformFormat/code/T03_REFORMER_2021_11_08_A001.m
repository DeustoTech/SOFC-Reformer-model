clear 

load('TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
%%
Input = reformer(:,{'steamfuelRatio','airfuelRatio'});
Output = reformer(:,{'inlet_H2O','inlet_CO2','inlet_C','inlet_O2'});

%%
ni = size(Input,2);
no = size(Output,2);

hd = floor(linspace(ni,no,2));
net = feedforwardnet(4);

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

[net,tr_inlet] = train(net,Input_norm',Output_norm');
%%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/';
file = fullfile(file,'REFORMER_inlet.m');

genFunction(net,file)
%%
savepath =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/inlet_norm.mat';
save(savepath,'in_norm','out_norm','tr_inlet');

%%

sf = reformer.steamfuelRatio;
af = reformer.airfuelRatio;
C  = reformer.inlet_C;

subplot(3,1,1)
plot3(sf,af,C,'.')

subplot(3,1,2)
pred = net(Input_norm');
Cp = pred(3,:);
Cp = out_norm.mu(3) + Cp*out_norm.std(3);
plot3(sf,af,Cp,'.')

subplot(3,1,3)

plot3(sf,af,Cp' -C,'.')


