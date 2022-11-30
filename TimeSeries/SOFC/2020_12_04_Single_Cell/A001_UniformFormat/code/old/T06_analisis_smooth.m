clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/DataSOFC_reduce.mat')

%% Normalize data

%%
sm = summary(cat(1,DT_All{:}))

for i = 1:16
    ids(i) = IN_OUT(exp_SOFC(DT_All{i}));
end
neurons = [10];
net = feedforwardnet(neurons);

net.performParam.normalization = 'standard';
net.performParam.regularization = 1e-4;

no = 3;


[inputs_narx,output_narx] = serveral_narx(ids,no);

%%
% net.trainFcn='trainbfg';
% net.trainParam.epochs = 300;
% net.trainParam.goal = 1e-5;
% net.performParam.regularization = 0.001;

net = train(net,inputs_narx,output_narx);


%% Compare 
fig = figure(1);

curids = IN_OUT(exp_SOFC(DT_All{40}));
%curids = ids(3);
    
ui1 = uipanel('Parent',fig,'unit','norm','pos',[0 0 1/2 1]);
dsplot(curids,sm,ui1)
ui1.Title = 'Real';
ui1.FontSize = 20;
ui1.BorderWidth = 10;

ui2 = uipanel('Parent',fig,'unit','norm','pos',[1/2 0 1/2 1]);
rds = gensim(curids,no,net);
dsplot(rds,sm,ui2)
ui2.Title = 'Prediction';
ui2.FontSize = 20;
ui2.BorderWidth = 10;

%%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/models/modelSOFC.m';

genFunction(net,file)