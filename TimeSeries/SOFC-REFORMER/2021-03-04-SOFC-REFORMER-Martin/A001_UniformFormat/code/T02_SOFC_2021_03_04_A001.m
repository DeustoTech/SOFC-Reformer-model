clear 

load('TimeSeries/SOFC-REFORMER/2021-03-04-SOFC-REFORMER-Martin/A001_UniformFormat/output/ds.mat')

%%
ds = ReformerPlusStackData;
ds(:,1:3) = [];
% REmove Mass Flows
vars = ds.Properties.VariableNames;
bl = arrayfun(@(i) contains(vars{i},'Mass'),1:length(vars),'UniformOutput',1);
ds(:,bl) = [];
%%
% vars = ds.Properties.VariableNames;
% file_path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/Reformer-AGRO-SOFC-paper/img/histograms';
% fig = figure('unit','norm','pos',[0 0 0.4 0.4]);
% i = 0;
% for ivar = vars
%    i = i + 1;
%    histogram(ds.(ivar{:}),'Normalization','probability','NumBins',40)
%    title(ivar{:},'Interpreter','latex','FontSize',15)
%    ylim([0 0.15])
%    grid on
%    %img_path = fullfile(file_path,"HISTO"+i+".eps")
%    %print(fig,img_path,'-depsc');
%    pause(0.1)
% end
% %%
% fig = figure('unit','norm','pos',[0 0 0.4 0.4]);
% format = {'FontSize',20,'Interpreter','latex'};
% 
% set(fig,'defaultAxesFontSize',15)
% 
% set(fig,'defaultHistogramNormalization','Probability')
% %set(fig,'defaultNumericRulerTickLabelInterpreter','latex')
% 
% hold on
% histogram(ds.FuelFlow,'BinWidth',0.15,'FaceColor','none','LineWidth',3.5,'EdgeColor','r')
% histogram(ds.SteamFlow,'BinWidth',0.15,'FaceColor','none','LineWidth',2,'EdgeColor','g')
% histogram(ds.ReformerAirFlow,'BinWidth',0.15,'FaceColor','none','LineWidth',0.5,'EdgeColor','b')
% 
% 
% 
% title('Mass Flow (kg/h)',format{:})
% ylim([0 0.17])
% legend('Fuel','Steam','Air')
% grid on
% box 
% 
% fig.Renderer = 'Painters';
% 
% img_path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/Reformer-AGRO-SOFC-paper/img/histograms/inputs.eps';
% print(fig,img_path,'-depsc')
% 
% %%
% 
% fig = figure('unit','norm','pos',[0 0 0.4 0.4]);
% fig.Renderer = 'Painter';
% format = {'FontSize',20,'Interpreter','latex'};
% indrand = randsample(size(ds,1),2000);
% 
% plot3(ds.ReformerAirFlow(indrand) , ...
%       ds.SteamFlow(indrand)       , ...
%       ds.FuelFlow(indrand)        , ...
%       'Marker','.','LineStyle','none','MarkerSize',12)
%   
% xlabel('Air Flow (kg/h)',format{:})
% ylabel('Steam Flow (kg/h)',format{:})
% zlabel('Fuel Flow (kg/h)',format{:})
% box
% grid on 
% 
% img_path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/Reformer-AGRO-SOFC-paper/img/histograms/inputs_3d.eps';
% print(fig,img_path,'-depsc')
% %%
% fig = figure('unit','norm','pos',[0 0 0.4 0.4]);
% set(fig,'defaultAxesFontSize',15)
% 
% indrand = randsample(size(ds,1),1000);
% 
% plot(ds.ReformerOutletTemperature(indrand),ds.OperatingTemperature(indrand),'.','MarkerSize',12)
% xlabel('Reformer Temperature ($^\circ C$)',format{:})
% ylabel('Fuel Cell Temperature ($^\circ C$)',format{:})
% 
% fig.Renderer = 'Painters';
% img_path = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/papers/Reformer-AGRO-SOFC-paper/img/histograms/Temperatures.eps';
% print(fig,img_path,'-depsc')
% 
% 
% %%
% indrand = randsample(size(ds,1),5000);
%  
% TotalMass = ds.ReformerAirFlow + ...
%             ds.SteamFlow       + ...
%             ds.FuelFlow;
%  
% Xsteam = ds.SteamFlow./ds.FuelFlow;
% Xair   = ds.ReformerAirFlow./ds.FuelFlow;
%     %% 
% 
% fig = figure('unit','norm','pos',[0 0 0.4 0.4]);
% set(fig,'defaultAxesFontSize',15)
% 
% set(fig,'defaultHistogramNormalization','Probability')
% 
% subplot(2,1,1)
% hold on
% histogram(Xsteam,'Normalization','probability')
% histogram(Xair,'Normalization','probability')
% legend('$\chi_{steam}$','$\chi_{air}$','Interpreter','latex')
% title('Mass Concentration (Fuel Normalization)',format{:})
% 
% subplot(2,1,2)
% 
% histogram(TotalMass)
% title('Inlet Mass (kg/h)',format{:})


%%
clear h
ind = randsample(size(ds,1),30000);
ds2 = ds(ind,:);

ds2(ds2.FuelCellHeat < 0,:) = [];
h.ds2 =ds2;
%
%ip = scatter(ds2.Powerelectrical,ds2.FuelCellHeat,[],ds2.currentPerStack)
%ip = scatter3(ds2.Powerelectrical,ds2.FuelCellHeat,ds2.OperatingTemperature,[],ds2.ReformerOutletTemperature);
%
%ip = scatter3(ds2.Powerelectrical,ds2.FuelCellHeat,ds2.OperatingTemperature,[],ds2.ReformerOutletTemperature);
figure(1)
clf

subplot(2,2,1)

ip222 = scatter3(ds2.OperatingTemperature,ds2.ReformerOutletTemperature,ds2.FuelCellHeat,[],ds2.Powerelectrical);

ic = colorbar
xlabel('Fuel Cell Temperature')
ylabel('Reformer Temperature')
zlabel('Thermal Power')
ic.Label.String = 'Electrical Power';

caxis([0 4.5])
view(-18,18)
set(ip222.Parent,'FontSize',20)

subplot(2,2,3)
h.ip = scatter3(ds2.OperatingTemperature,ds2.ReformerOutletTemperature,ds2.FuelCellHeat,[],ds2.Powerelectrical);
view(-18,18)

xlim([700 850])
xticks(linspace(700,850,6))

ylim([500 900])
yticks(linspace(500,900,6))

zlim([0 6])
zticks(linspace(0,6,6))

caxis([0 4.5])

ic = colorbar;
grid on
xlabel('Fuel Cell Temperature')
ylabel('Reformer Temperature')
zlabel('Thermal Power')
ic.Label.String = 'Electrical Power';
colormap('jet')
%
box 
set(h.ip.Parent,'FontSize',20)

%

subplot(4,2,[2 4 6])
hold on
h.AF = ds2.ReformerAirFlow./ds2.FuelFlow;
h.AS = ds2.SteamFlow./ds2.FuelFlow;


h.jp= plot(h.AF,h.AS,'.');
xlabel('Mass Ratio Air/Fuel')
ylabel('Mass Ratio Steam/Fuel')

set(h.jp.Parent,'FontSize',20)

h.point = plot(0.5,0.3,'Marker','s','MarkerSize',180);
h.points = plot(0,0,'Marker','.','color','r','LineStyle','none','MarkerSize',15);

    h.AF_slider = uicontrol('style','slider','unit','norm','pos',[0.6 0.1 0.3 0.1],'String','Air Fuel');
h.AS_slider = uicontrol('style','slider','unit','norm','pos',[0.6 0.05 0.3 0.1],'String','Steam Fuel');

h.AF_slider.Callback = {@callback_AF,h};
h.AS_slider.Callback = {@callback_AS,h};

%

function callback_AF(obj,event,h)
    Value = (obj.Value)*(6-2*0.7) + 0.7;
    h.point.XData = Value;
    
    ind = update_red_points(h);
     update_power(h,ind)
end

function callback_AS(obj,event,h)
    Value = (obj.Value)*(3.5-2*0.4) + 0.4;
    h.point.YData = Value;
    
    ind = update_red_points(h);
     update_power(h,ind)
end



function ind = update_red_points(h)
    ValueAir = h.AF_slider.Value*(6-2*0.7) + 0.7;
    ValueSteam = h.AS_slider.Value*(3.5-2*0.4) + 0.4;

    ind1 = logical((h.AF > ValueAir - 0.7).*(h.AF < ValueAir + 0.7));
    ind2 = logical((h.AS > ValueSteam - 0.4).*(h.AS < ValueSteam + 0.4));

    ind = logical(ind1.*ind2);
    h.points.XData = h.AF(ind);
    h.points.YData = h.AS(ind);
    
end

function update_power(h,ind)

        
    h.ip.XData = h.ds2.OperatingTemperature(ind);
    h.ip.YData = h.ds2.ReformerOutletTemperature(ind);
    h.ip.ZData = h.ds2.FuelCellHeat(ind);
    h.ip.CData = h.ds2.Powerelectrical(ind);


    end


