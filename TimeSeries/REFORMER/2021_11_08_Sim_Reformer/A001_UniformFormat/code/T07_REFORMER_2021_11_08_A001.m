clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/inlet_norm.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/outlet_norm.mat')
%%
fig = figure(1)
clf
hold on 
plot(log(tr_inlet.perf),'LineWidth',2,'LineStyle','-')
plot(log(tr_outlet.perf),'LineWidth',2,'LineStyle','-')
ylabel('$log(mse)$','Interpreter','latex','FontSize',20)
xlim([0 250])
xlabel('$epochs$','Interpreter','latex','FontSize',20)
grid on
legend('$\mathcal{G}_1(\cdot)$','$\mathcal{G}_2(\cdot)$','FontSize',20,'Interpreter','Latex')

path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img';
fig.Children(2).FontSize = 20;

fig.Children(2).XAxis.TickLabelInterpreter = 'latex';
fig.Children(2).YAxis.TickLabelInterpreter = 'latex';
print(fig,fullfile(path,'perform_nn.eps'),'-depsc')