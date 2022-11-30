clear 

% 
% Entrenamiento de una red neuronal sin dependencia temporal

%
%load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/cs01.mat')

fileout = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/cs01.mat";
fileout = "TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/cs01.mat";

load(fileout)

%%
[mu_vars,std_vars] = NormalizeData(ics);
ics = SetNormalization(ics,mu_vars,std_vars);
%% Entrenammiento de rede neuronal sin dependencia en estados anteriores
% Es decir x_{t+1} = f(u_t,d_t)
% Donde x_{t+1} es el valor del estado en el instante t+1
%       u_t     es el valor de control en el instante t
%       d_t     es el valor del vector de perturbacion en el instante t

Inputs = [ics.Inputs{:}]';
Dist   = [ics.Disturbances{:}]';
Inputs = [Inputs Dist];
XData  = Inputs;

%%
YData = [ics.Outputs{:}]';
%%
N = ics.Nin + ics.Ndis;

layers = [      ...
    %
    imageInputLayer([1 1 N],'Name','In')
    %   
    reluLayer('Name','relu01')   
    fullyConnectedLayer(10,'Name','fc01')
    %
    reluLayer('Name','relu02')   
    fullyConnectedLayer(10,'Name','fc02')
    %
    reluLayer('Name','relu03')    
    fullyConnectedLayer(ics.Nout,'Name','Output')
    %
    regressionLayer('Name','Regre') 
    %
    ];
%           
lgraph = layerGraph(layers);

%
%%
miniBatchSize  = 256;
options = trainingOptions('rmsprop', ...
    'MiniBatchSize'       , miniBatchSize, ...
    'MaxEpochs'           , 30,     ...
    'InitialLearnRate'    , 0.001,  ...
    'LearnRateDropFactor' , 0.1,    ...
    'LearnRateDropPeriod' , 10,     ...
    'Plots'               , 'training-progress',     ...
    'Shuffle'             , 'every-epoch', ...
    'Verbose'             , true);
%
net = trainNetwork(reshape(XData',1,1,N,34299),YData,lgraph,options);
%%
ind = 40;
XTest = [ics.Inputs{ind}' ics.Disturbances{ind}'];
ndat = size(XTest,1);
YTest = predict(net,reshape(XTest',1,1,N,ndat));
%
clf
plot(YTest,'r')
hold on 
plot(ics.Outputs{ind}','b')
