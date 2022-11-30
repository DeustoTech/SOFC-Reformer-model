clear 
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/DataSOFC_reduce.mat')
%%
%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/DataSOFC.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/DataSOFC.mat')
%
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/DataSOFC_reduce.mat')


DTcat = cat(1,DT_All{:});

%% Duracion
duration = arrayfun( @(i) hours(DT_All{i}{end,1}),1:581);

dif = [];
for i = 1:581
    dif = [dif seconds(diff(DataSOFCtable{1}.Time))];
end
%% Plot
figure('Unit','norm','pos',[0 0 0.3 0.45])
subplot(2,1,1)
histogram(duration,8)
xticks(0:5)
ylabel('# Experiments')
xlabel('Time (h)')
title('Distribution of Experiments')
print('../docs/slides/img/historgram_experiments.png','-dpng')
%
subplot(2,1,2)
histogram(dif,8)
xticks(0:5)
ylabel('# Experiments')
xlabel('Time (h)')
title('Distribution of Experiments')
print('../docs/slides/img/historgram_experiments.png','-dpng')

%% Out Gases
close all
i = 0;
fig = genfig('doc',2); % doc - size 2

for ivar = DTcat.Properties.VariableNames(24:end)
   i = i + 1;
   ax = subplot(5,1,i,'Parent',fig);
   ih = histogram(DTcat.(ivar{:}),20,'Normalization','probability','Parent',ax);
   grid on
   %xlim([-1 100])
   ylim([0 1])
   ylabel(ivar{:}(3:end-4),'Interpreter','latex')
   if i == 1
      title('OffGas Concentration ') 
   end
   %xticks(0:20:100)
   xticklabels((ih.Parent.XAxis.TickValues)'+"%")
end

print('../docs/2020-12-15-SOFC-Data/img/output-gases-distri.png','-dpng')

%print('../docs/slides/img/concetration.png','-dpng')

%% Temperatures
i = 0;
%figure('Unit','norm','pos',[0 0 0.3 0.45]) % slides 
fig = figure('Unit','norm','pos',[0 0 0.6 0.8],'color','none') % doc 
u1 = uipanel('Parent',fig,'pos',[0 0.5 1 0.5],'Title','Anode','BackgroundColor','w')
for ivar = DTcat.Properties.VariableNames([12+4 (3+(1:6)) 13+4])
   i = i + 1;
   subplot(2,4,i,'Parent',u1)
   histogram(DTcat.(ivar{:}),20,'Normalization','probability')
   grid on 
   xlabel('Temperature (ºC)')
   ylim([0 1])
   title(ivar{:},'Interpreter','latex')

end
u2 = uipanel('Parent',fig,'pos',[0 0.0 1 0.5],'Title','Cathode','BackgroundColor','w');
i = 0;

for ivar = DTcat.Properties.VariableNames([ 18 10:15 17])
   i = i + 1;
   subplot(2,4,i,'Parent',u2)
   histogram(DTcat.(ivar{:}),20,'Normalization','probability')
   grid on 
   xlabel('Temperature (ºC)')
   ylim([0 1])
   title(ivar{:},'Interpreter','latex')

end

%print('../docs/2020-12-15-SOFC-Data/img/temp_distri.png','-dpng')
%% Input Composition

%fig = figure('Unit','norm','pos',[0 0 0.6 0.8],'color','w') % doc - size 1
fig = figure('Unit','norm','pos',[0 0 0.3 0.4],'color','w') % doc - size 2

i = 0;

for ivar = DTcat.Properties.VariableNames(22:23)
   i = i + 1;
   subplot(2,1,i)
   histogram(DTcat.(ivar{:}),20,'Normalization','probability')
   grid on 
   xlabel('Flow')
   ylim([0 1])
   title(ivar{:},'Interpreter','latex')

end
print('../docs/2020-12-15-SOFC-Data/img/input_gases_distri.png','-dpng')

%% Electrical Power
fig = genfig('doc',2);


i = 0;
labels = {'Intensity','Voltage'}
for ivar = DTcat.Properties.VariableNames(20:21)
   i = i + 1;
   subplot(2,1,i)
   histogram(DTcat.(ivar{:}),20,'Normalization','probability')
   grid on 
   xlabel(labels{i})
   ylim([0 1])
   title(ivar{:},'Interpreter','latex')

end

print('../docs/2020-12-15-SOFC-Data/img/power_distri.png','-dpng')
