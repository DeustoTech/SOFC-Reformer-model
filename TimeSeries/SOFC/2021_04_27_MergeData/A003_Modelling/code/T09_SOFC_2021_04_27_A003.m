%%
%  MATLAB
%%
clear all
%
no = 0;
ni = 1;
nd = 1;
%
%
file =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output';
file = fullfile(file,"feed_inet_nn_n"+no);
%    


load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics02.mat')

%%
iTs_full = Concat(ics.TableSeries)
clf
hold on
plot(iTs_full.DataSet{:,ics.OutputVars(2:end)},'LineWidth',3)

plot(sum(iTs_full.DataSet{:,ics.OutputVars(2:end)},2),'Color','k','LineWidth',3)
grid on
yline(100,'LineWidth',4,'Color',[0.1 0.1 0.1])
ylabel('Dry Volume Concetration (%)')
legend([ics.OutputVars(2:end),'Sum','100%'],'Interpreter','none')
xlabel('Samples')
title('Original Data')
%%

    train_logical = false;


if ~train_logical
    % modifico la senal de entrada
    % 40 mA 
     for i = 1:length(ics.TableSeries)
         ics.TableSeries(i).DataSet.i_act2 = ics.TableSeries(i).DataSet.i_act2*0 + 40 + 0.1*rand(size(ics.TableSeries(i).DataSet.i_act2));
     end
    load(file)
    train_logical = false;

else
   [mu_vars,std_vars] = NormalizeData(ics);
    mu_vars.out = mu_vars.out.*0;
end
%
ics = SetNormalization(ics,mu_vars,std_vars);

%% Data Set
[Inputs,Outputs,numFeatures,numResponses,ndata] = cs2narxformat(ics,no,ni,nd);
%%
    

if train_logical
%% Train
    hd = floor(linspace(numFeatures,numResponses,3));
    net = feedforwardnet(hd);
%     
    net.performParam.regularization = 1e-5;
    net.trainParam.mu_dec = 1/20; 
    net.trainParam.mu_inc = 20;

    net = train(net,Inputs',Outputs');
    save(file)

else
    load(file)
end
%% Open Loop Prediction

Outputs_pred = net(Inputs')';

%
clf
subplot(2,1,1)
plot(Outputs_pred)
% 
title('Prediction')
subplot(2,1,2)

plot(Outputs)
title('Real')

%% Close Loop Prediction

%load("inet_nn0")
fig = figure(1);
%fig.Name = 'nn0';
clf

n0 =1500;
Ntt =3500;
%Ntt =5600;

%Ntt =1060;

nin = (ni*ics.Nin +  nd*ics.Ndis);
%
Input0 = Inputs(n0,1:nin);
Output0 = Outputs(n0-no:n0-1,:);
Output0 = flipud(Output0);

ini_out = ni*ics.Nin + nd*ics.Ndis + 1;
end_out  = ini_out + (no-1)*ics.Nout;

Output_pred = net(Inputs(n0:(n0+Ntt-1),:)')';


%

%
ax = {};



ui1 = uipanel('Parent',fig,'unit','norm','pos',[0 0 0.5 1]);
for i = 1:6
    ax{1}{i} = subplot(6,1,i,'Parent',ui1);
    hold(ax{1}{i},'on')
end

sty = {'LineStyle','-','LineWidth',2,'Marker','.'};

dt = ics.TableSeries(1).tspan(2) - ics.TableSeries(1).tspan(1);

t1s = dt*(0:(Ntt-1));
t1s.Format = 'd';
t2s = dt*(0:(Ntt));
t2s.Format = 'd';

for i = 1:6
    
    dnorm = Output_pred(:,i).*ics.Normalization.std.out(i) + ics.Normalization.mean.out(i);
    
    if i == 1
         voltage = dnorm(:,1);
    end
    plot(t1s,dnorm,'Parent', ax{1}{i},sty{:})

    dnorm = Outputs(n0:(n0+Ntt),i).*ics.Normalization.std.out(i) + ics.Normalization.mean.out(i);
    plot(t2s,dnorm,'Parent', ax{1}{i},sty{:})
    legend(ax{1}{i},'pred','real')
    %ylim(ax{1}{i},[-20 20])
    if i == 1

        ylim(ax{1}{i},[0 1.5])
    elseif i ==2
        ylim(ax{1}{i},[0 100])
    else
        ylim(ax{1}{i},[0 30])
    end
    title(ax{1}{i},ics.OutputVars{i},'Interpreter','none')
end

ui2 = uipanel('Parent',fig,'unit','norm','pos',[0.5 0 0.5 1]);

ax = subplot(4,1,1,'Parent',ui2);
iii = Inputs(n0:(n0+Ntt),1:ics.Nin);
iii = iii.*ics.Normalization.std.in + ics.Normalization.mean.in;

plot(t2s,iii(:,1),'Parent',ax,sty{:});
legend(ics.InputVars,'Interpreter','none')
legend('Temp')
%
ax = subplot(4,1,2,'Parent',ui2);
plot(t2s,iii(:,2:end),'Parent',ax,sty{:});
legend(ics.InputVars(2:end),'Interpreter','none')
%
ax = subplot(4,1,3,'Parent',ui2);
iii = Inputs(n0:(n0+Ntt),(1+ni*ics.Nin):(ni*ics.Nin+ics.Ndis));
iii = iii*ics.Normalization.std.dist +ics.Normalization.mean.dist;
plot(t2s,iii,'Parent',ax,sty{:});
legend(ics.DisturbanceVars,'Interpreter','none');
%
ax = subplot(4,1,4,'Parent',ui2);

plot(t1s,voltage.*iii(1:end-1),'Parent',ax,sty{:});
legend('Electrical Power')

%%

%%
file =    '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output';
file = fullfile(file,'SOFC_nn');

%genFunction(net,file)