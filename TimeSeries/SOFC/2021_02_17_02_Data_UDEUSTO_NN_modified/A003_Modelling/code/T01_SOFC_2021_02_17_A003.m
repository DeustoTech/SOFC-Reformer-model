clear 
%load("" + MainPath + 'TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/cs01.mat')
load("TimeSeries/AGRO_SOFC/SOFC/2021_02_17_02_Data_UDEUSTO_NN_modified/A001_UniformFormat/output/cs01.mat")
%%
no_ics = ics;
[mu_vars,std_vars] = NormalizeData(ics);
ics = SetNormalization(ics,mu_vars,std_vars);
%%
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
    fullyConnectedLayer(20,'Name','fc01')
    %
    reluLayer('Name','relu02')   
    fullyConnectedLayer(20,'Name','fc02')
    %
    reluLayer('Name','relu03')   
    fullyConnectedLayer(20,'Name','fc03')
    %
    reluLayer('Name','relu_end')    
    fullyConnectedLayer(ics.Nout,'Name','Output')
    %
    regressionLayer('Name','Regre') 
    %
    ];
%           
lgraph = layerGraph(layers);

%
%%
miniBatchSize  = 1024;

Plots = 'training-progress';
%Plots = 'none';

options = trainingOptions('adam', ...
    'MiniBatchSize'       , miniBatchSize, ...
    'MaxEpochs'           , 10,     ...
    'InitialLearnRate'    , 0.1,  ...
    'LearnRateDropFactor' , 0.5,    ...
    'LearnRateDropPeriod' , 50,     ...
    'Plots'               , Plots,     ...
    'Shuffle'             , 'every-epoch', ...
    'Verbose'             , true);
%
options.ExecutionEnvironment ='parallel';
options.LearnRateSchedule = 'piecewise';
%
net = trainNetwork(reshape(XData',1,1,N,size(XData,1)),YData,lgraph,options);
%%
ind = 1:9;
XTest = [[ics.Inputs{ind}]' [ics.Disturbances{ind}]'];
ndat = size(XTest,1);
YTest = predict(net,reshape(XTest',1,1,N,ndat));
%
tspan  = [ics.DateTime{ind}];
In  = [ics.Inputs{ind}];
Dis = [ics.Disturbances{ind}];
Out = YTest;
%%
newcs = Data2cs(ics,tspan,In,Out',Dis,'denorm',1);
%%
OutG = {1,[2:4 6:8],5};
InG  = {1,2:8};
clf
ui1 = uipanel('Parent',gcf,'Unit','norm','pos',[0 0 0.5 1]);
ui1.Title = 'real';

plot(no_ics,'Parent',ui1,'OutGroups',OutG,'ind',ind,'InGroups',InG,'ind',1:9);
%
ui2 = uipanel('Parent',gcf,'Unit','norm','pos',[0.5 0 0.5 1]);
ui2.Title = 'Prediction';
plot(newcs,'Parent',ui2,'OutGroups',OutG,'InGroups',InG);