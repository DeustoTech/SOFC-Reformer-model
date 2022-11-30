clear
load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')

%%
state_vars = {'CO_mole_out','H2_mole_out'};
%%
ind = 400;
%
cds_train = norm_control_ds{1:ind,:};
sds_train = norm_state_ds{1:ind,state_vars};
%
cds_test = norm_control_ds{1+ind:end,:};
sds_test = norm_state_ds{1+ind:end,state_vars};
%%
net = feedforwardnet([10 10]);
[net,tr] = train(net,cds_train',sds_train');
%%
sds_test_pred = net(cds_test')';
%%
nv.MEAN_state = mean_state(6:7);
nv.STD_state  = mean_state(6:7); 
%
nv.MEAN_control = mean_control;
nv.STD_control  = std_control;
%


%%
ms = 200;
fig = figure('unit','norm','pos',[0 0 0.4 0.9]);
set(fig,'renderer','Painters')
plotds(cds_train,sds_train,fig,nv,ms)
%
path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T01-ReformingDiesel/docs/report/img";
print(fig,fullfile(path,'Test01.eps'),'-depsc')
%%
ms = 50;
fig = figure('unit','norm','pos',[0 0 0.4 0.9]);
set(fig,'renderer','Painters')
plotds(cds_test,sds_test,fig,nv,ms)
%
path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T01-ReformingDiesel/docs/report/img";
print(fig,fullfile(path,'Test02.eps'),'-depsc')
%%
fig = figure('unit','norm','pos',[0 0 0.4 0.9]);
set(fig,'renderer','Painters')
plotds(cds_test,sds_test_pred,fig,nv,ms)
%
path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T01-ReformingDiesel/docs/report/img";
print(fig,fullfile(path,'Test03.eps'),'-depsc')

%%
save("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A003_Modelling/output/MODEL02_norm_data.mat')
%%
file = "" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A003_Modelling/output/MODEL01_REFORMER.mat';
genFunction(net,file)

%% isosurface 
for i = 1:3
    u_lims{i} = [min(cds_train(:,i)) max(cds_train(:,i))];
    u_span{i} = linspace(u_lims{i}(1),u_lims{i}(2),20);
end
[u_ms{1},u_ms{2},u_ms{3}] = ndgrid(u_span{:});

%%
%%

function plotds(cds,sds,Parent,nv,ms)

cds = (cds.*nv.STD_control) + nv.MEAN_control;
sds = (sds.*nv.STD_state) + nv.MEAN_state;
%
subplot(2,1,1,'Parent',Parent)
is = scatter3(cds(:,1),cds(:,2),sds(:,1),[],cds(:,3));
is.Marker = '.';
is.SizeData = ms;
fmt = {'Interpreter','latex','FontSize',35};
title('$x_{CO}$',fmt{:})
xlabel('$u_{sf}$',fmt{:})
ylabel('$u_{af}$',fmt{:})
zlim([-0.2 0.5])
colorbar
colormap('jet')
%
subplot(2,1,2,'Parent',Parent)
is = scatter3(cds(:,1),cds(:,2),sds(:,2),[],cds(:,3));
is.Marker = '.';
is.SizeData = ms;
title('$x_{H2}$',fmt{:})
xlabel('$u_{sf}$',fmt{:})
ylabel('$u_{af}$',fmt{:})
zlim([-0.2 1.5])
colorbar
colormap('jet')

end