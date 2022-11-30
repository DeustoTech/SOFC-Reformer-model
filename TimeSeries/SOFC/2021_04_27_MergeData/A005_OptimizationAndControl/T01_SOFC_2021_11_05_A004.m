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
file = fullfile(file,"inet_nn_n"+no);
%    

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics02.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output/inet_nn_n0.mat')

%%

iTs_full = Concat(ics.TableSeries);

rsum = summary(iTs_full.DataSet);

%
rsum_new = [];
for i = 2:ics.Nin
    rsum_new.(ics.InputVars{i}) = rsum.(ics.InputVars{i});
end
rsum = rsum_new;
rsum = struct2array(rsum);
%
Mins = [rsum.Min]';
Maxs = [rsum.Max]';

ndata = 5000;


max_dis = max(iTs_full.DataSet.i_act2);
min_dis = min(iTs_full.DataSet.i_act2);

tspan = linspace(0,100,ndata)*minutes(2);

Iline = linspace(2,60,10);
j = 0;

dist_population = rand(1,ndata).*(max_dis-min_dis) + min_dis;

for iI = Iline 
    j = j +1;
new_dist_population = rand(1,ndata).*(max_dis-min_dis) + min_dis;
dist_population = 0.8*dist_population + 0.2*new_dist_population;
dist_population = iI + 0*dist_population';

inputs_population0 = rand(6,ndata).*(Maxs-Mins) + Mins;

for iter = 1:25
   inputs_population = [850*ones(size(inputs_population0,2),1) inputs_population0'];


%%
new_cs = Data2cs(ics,tspan,inputs_population',zeros(6,ndata),dist_population');

%% Normalization
new_cs_norm = SetNormalization(new_cs,mu_vars,std_vars);

%%
[Inputs,Outputs,numFeatures,numResponses,ndata_pre] = cs2narxformat(new_cs_norm,no,ni,nd);

%% Fixed new values
Outputs_pred = predict(net,reshape(Inputs',numFeatures,1,1,ndata_pre));
tspan2 = tspan(2:end);
%
new_cs_de_norm = Data2cs(new_cs_norm,tspan2,new_cs_norm.Inputs{:}(:,2:end),Outputs_pred',new_cs_norm.Disturbances{:}(:,2:end),'denorm',1);

%%
if std(new_cs_de_norm.TableSeries.DataSet.V_act) < 1e-4
   break 
end
%%
V_act = new_cs_de_norm.TableSeries.DataSet.V_act;
v_H2 = new_cs_de_norm.TableSeries.DataSet.v_H2_act;

%V_tot = sum(new_cs_de_norm.TableSeries.DataSet{:,ics.OutputVars(2:end)},2);

Cost  = V_act - 10*(V_act > 1.21) - 10*(v_H2>100);
[~, ind] = sort(Cost,'descend');


pre_DateTime = new_cs_de_norm.TableSeries.DateTime;
new_cs_de_norm.TableSeries = subselect(new_cs_de_norm.TableSeries,ind);
new_cs_de_norm.TableSeries.DateTime = pre_DateTime;


%% select best 
best = new_cs_de_norm.Inputs{:}(2:end,1:floor(ndata_pre*0.5))';

sum1  = randsample(1:(floor(ndata_pre/2)),floor(ndata_pre/2)+1,true);
sum2  = randsample(1:(floor(ndata_pre/2)),floor(ndata_pre/2)+1,true);

newbest = best(sum1,:)*0.5 +  best(sum2,:)*0.5 + 0.05*rand(size(best(sum2,:)));

inputs_population0 = [best;newbest;newbest(1,:)]';

%%
%%
if mod(iter,5) == 0
    clf
    plot(new_cs_de_norm,'OutGroup',{1,[2:6]},'InGroup',{1,[2:7]},'Outylims',{[0 1.5],[0 150]},'Disylims',{[0 60]})
    ax = gca;
    text(ax.Parent.Parent.Children(2).Children(2),100,20,"I = " +iI+"(mA)",'FontSize',15)
    pause(0.05)
end

end


BestInputFlows{j} = mean(inputs_population0(:,1:floor(ndata/4)),2);
fprintf("j = "+j+"\n")

end
%%
clf
plot(Iline,[BestInputFlows{:}],'.-');legend(ics.InputVars(2:end))
xlabel('I(mA)')
ylabel('Optimal Inlet Flows(slpm)')