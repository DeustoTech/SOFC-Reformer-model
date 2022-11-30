clear

load("" + MainPath + 'TimeSeries/AGRO_SOFC/REFORMER/2020_11_30_Sim_Reformer/A001_UniformFormat/output/dataset03.mat')
%%

fmt = {'Interpreter','latex','FontSize',25};
fig = figure('unit','norm','pos',[0 0 0.45 0.8]);

% 9:16
inlet1 = state_dataset(:,[9:16 ]);
nstate = length(inlet1.Properties.VariableNames);
color = jet(nstate);
grid on

varnames = {'\chi_{Ar}', ...
            '\chi_{CH_4}', ...
            '\chi_{CO}', ...
            '\chi_{CO_2}', ...
            '\chi_{H_2}', ...
            '\chi_{H_2O}', ...
            '\chi_{N_2}', ...
            '\chi_{C_{soot}}'};

for is = 1:nstate
    subplot(4,2,is)
    box

    histogram(inlet1{:,is},'FaceAlpha',0.5,'FaceColor',color(is,:),'Normalization','probability');
    grid on
    title("$\mathcal{P}(" + varnames(is)+")$",fmt{:})
    
    ylim([0 0.15])
end



file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/ReformerModelling-Paper/img';
fig.Renderer = 'painters';
fig.PaperOrientation = 'landscape';
print(fig,fullfile(file,'distri_outlet.eps'),'-painters','-depsc');
