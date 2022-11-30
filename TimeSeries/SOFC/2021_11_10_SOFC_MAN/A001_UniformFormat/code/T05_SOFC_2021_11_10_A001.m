clear

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/model01.mat');

%%
newds = vertcat(newds{:});
%

%%
vars = {'I153','U153', ...
        'pump_set','CH4_tar','CO2_tar','H2_tar','CO_tar','N2_tar', ...
        'AirMass', ...
        'T_int_fuel','T_out_fuel','T_int_air','T_out_air'};

YLims = {0.15,0.15, ...
         0.5,0.5,0.5, ...
         0.5,0.5,0.5,0.5 ...
         0.17,0.17,0.17,0.17};
close all
fig= figure('unit','norm','pos',[0 0 0.45 0.25]);
fig.Renderer = 'painters';

uip = uipanel('Parent',fig,'BackgroundColor','w');
ax = axes('unit','norm','pos',[0.175 0.45 0.7 0.45],'Parent',uip);
%%
file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img/mini-histo-SOFC';

iter = 0;
for ivar = vars
   iter = iter + 1;
   cla(ax)
   ih = histogram(newds{:,ivar{:}},'Normalization','probability','NumBins',20,'Parent',ax);
   grid on
   fig.Children.Children.XAxis.TickLabelInterpreter = 'latex';
   fig.Children.Children.YAxis.TickLabelInterpreter = 'latex';
   fig.Children.Children.XAxis.TickLabelFormat = '%.2f';
   fig.Children.Children.YAxis.TickLabelFormat = '%.2f';
 
   Xmin = min(newds{:,ivar{:}});
   Xmax = max(newds{:,ivar{:}});

   Ymax = max(max(ih.Values)+0.1,0.2);
   xticks([Xmin Xmax])
   yticks(YLims{iter})

   fig.Children.Children.FontSize = 45;
   
   ylim([0 YLims{iter} + 0.05])
   print(fig,fullfile(file,[ivar{:},'.eps']),'-depsc')
   
end

