clear

load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')
%%

fmt = {'Interpreter','latex','FontSize',25};
fig = figure('unit','norm','pos',[0 0 0.45 0.8]);


inlet1 = state_dataset(:,[1 2 3 4 5 6 7]);
nstate = length(inlet1.Properties.VariableNames);
color = jet(nstate);
grid on
varnames = {'\chi_{N_2}', ...
            '\chi_{O_2}', ...
            '\chi_{CO_2}', ...
            '\chi_{H_2O}', ...
            '\chi_{Ar}', ...
            '\chi_{C}', ...
            '\chi_{H_2}'};

for is = 1:nstate-1
    subplot(4,2,is)
    histogram(inlet1{:,is},'FaceColor',color(is,:),'Normalization','probability');
    title("$\mathcal{P}(" + varnames(is)+")$",fmt{:})
    ylim([0 0.1])
    grid on
end
subplot(4,2,[7 8])
histogram(inlet1{:,is+1},'FaceColor',color(is+1,:),'Normalization','probability');
title("$\mathcal{P}(" + varnames(is+1)+")$",fmt{:},'FontSize',20)
ylim([0 0.1])
grid on
%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/ReformerModelling-Paper/img';

fig.Renderer = 'painters';
print(fig,fullfile(file,'distri.eps'),'-painters','-depsc');
