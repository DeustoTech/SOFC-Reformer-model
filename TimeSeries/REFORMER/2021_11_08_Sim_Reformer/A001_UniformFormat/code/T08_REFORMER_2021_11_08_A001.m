clear

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/REFORMER/2021_11_08_Sim_Reformer/A001_UniformFormat/output/dataset01.mat')
%%
vars = {'Temperatur','airfuelRatio','steamfuelRatio', ...
        'inlet_H2O','inlet_CO2','inlet_C','inlet_O2', ...
        'outlet_H2O','outlet_CO','outlet_H2','outlet_CO2','outlet_CH4','outlet_N2'};

close all
fig= figure('unit','norm','pos',[0 0 0.45 0.25]);
fig.Renderer = 'painters';

uip = uipanel('Parent',fig,'BackgroundColor','w');
ax = axes('unit','norm','pos',[0.175 0.45 0.7 0.45],'Parent',uip);
%%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img/mini-histo';
for ivar = vars
   cla(ax)
   histogram(reformer{:,ivar{:}},'Normalization','probability','NumBins',20,'Parent',ax)
   grid on
   fig.Children.Children.XAxis.TickLabelInterpreter = 'latex';
   fig.Children.Children.YAxis.TickLabelInterpreter = 'latex';
   fig.Children.Children.XAxis.TickLabelFormat = '%.2f';
   Xmin = min(reformer{:,ivar{:}});
   Xmax = max(reformer{:,ivar{:}});

   xticks([Xmin Xmax])
   yticks([0.12])

   fig.Children.Children.FontSize = 45;
   ylim([0 0.15])
   print(fig,fullfile(file,[ivar{:},'.eps']),'-depsc')
   
end