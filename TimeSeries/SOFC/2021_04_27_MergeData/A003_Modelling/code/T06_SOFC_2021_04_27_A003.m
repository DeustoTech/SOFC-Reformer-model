%%
% LSTM MATLAB
%%
clear all
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat')
%%
[mu_vars,std_vars] = NormalizeData(ics);
%%
ics = SetNormalization(ics,mu_vars,std_vars);
%%


numFeatures = ics.Nout + ics.Nin + ics.Ndis;
numResponses =  ics.Nout;

numMemo = 100;
numHidd = 10;

layers = [ ...
    sequenceInputLayer(numFeatures,'Name','input')
    fullyConnectedLayer(numHidd,'Name','F01')

    lstmLayer(numHidd,'Name','LSTM01')
    additionLayer(2,'Name','add')
    
    fullyConnectedLayer(numHidd,'Name','F02')
    reluLayer('Name','relu01')
    fullyConnectedLayer(numResponses,'Name','F03')
    regressionLayer('Name','Loss')];

%%
lgraph = layerGraph(layers);
figure

lgraph = connectLayers(lgraph,'F01','add/in2');

plot(lgraph)


%%
XTrain = arrayfun(@(i) [ics.Inputs{i}(:,1:end-1)  ; ...
                        ics.Outputs{i}(:,1:end-1) ; ...
                        ics.Disturbances{i}(:,1:end-1)],1:32,'UniformOutput',0);

%
YTrain = arrayfun(@(i) ics.Outputs{i}(:,2:end) ,1:32,'UniformOutput',0);
                    
%%

options = trainingOptions('adam', ...
    'MaxEpochs',50, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,lgraph,options);

%%

ind = 1;
Nt_sim = 200;
ds = ics.Outputs{ind};
udata =  ics.Inputs{ind};
ddata =  ics.Disturbances{ind};

xt = zeros(ics.Nout,Nt_sim);
xt(:,1) = ds(:,1); 


net = resetState(net);

Nt_see = 40;
for it = 2:Nt_sim
    if it < Nt_see
        [net,xt(:,it)] = net.predictAndUpdateState([udata(:,it-1)' ds(:,it-1)' ddata(:,it-1)']');
        xt(:,it) = ds(:,it); 
    else
        [net,xt(:,it)] = net.predictAndUpdateState([udata(:,it-1)' xt(:,it-1)' ddata(:,it-1)']');
    end
end
%
%
color = jet(ics.Nout);

clf
hold on
xline(Nt_see)
for i  = 1:ics.Nout
    plot(ds(i,1:Nt_sim),'o','color',0.3*color(i,:)+0.7*[1 1 1])
    plot(xt(i,:),'color',color(i,:))
end
%%