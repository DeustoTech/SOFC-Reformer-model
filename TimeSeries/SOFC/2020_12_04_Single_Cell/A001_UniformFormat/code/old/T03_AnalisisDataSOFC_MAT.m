clear 

%load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/DataSOFC.mat')
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/DataSOFC.mat')

DT = cat(1,DataSOFCtable{:});
%%
DT.Date.Format = 'dd.MM.uuuu HH:mm';
DT.Time.Format = 'dd.MM.uuuu HH:mm';

myDatetime = DT.Date + timeofday(DT.Time);

%%
clf
hold on 
ind_oven = 3:4;
plot_oven = plot(myDatetime,DT{:,ind_oven},'k');
%
ind_anodo = 5:10;
plot_anodo  = plot(myDatetime,DT{:,ind_anodo},'r');
%
ind_catodo = 11:16;
plot_catodo  = plot(myDatetime,DT{:,ind_catodo},'b');


legend([plot_oven ;plot_anodo ;plot_catodo],DT.Properties.VariableNames{[ind_oven ind_anodo ind_catodo]})

%%


TOVEN = DT.T_Oven_01;
TIME  = myDatetime;
%
clf

subplot(2,1,1)
plot(TIME,TOVEN,'color',[0.9 0.9 0.9],'Marker','.','LineStyle','none')
hold on
plot(TIME,TOVEN)
title('real')

subplot(2,1,2)
plot(TIME,TOVEN,'color',[0.9 0.9 0.9],'Marker','.','LineStyle','none')
hold on
plot(TIME,smoothdata(TOVEN,1,'movmean',100))
title('smooth')

