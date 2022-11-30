clear 
%
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/DataSOFC.mat')
%
DataSet =DataSOFCtable{2};
%
DataSet.Date.Format = 'dd.MM.uuuu HH:mm';
DataSet.Time.Format = 'dd.MM.uuuu HH:mm';

myDatetime = DataSet.Date + timeofday(DataSet.Time);

% fijamos a cero  el instante de ti
myDatetime = myDatetime - myDatetime(1) ;

% removemos mismos intantes

%% STEP 1
% Buscamos el mínimo de \Delta t
moo
mindt = min(diff(myDatetime));

if mindt == 0
    bo_ind = diff(myDatetime) == mindt;
    % removemos medidas repetidas en el mismo segundo
    % esto es para tener una sola medida en cada tiempo 
    % dado que nuestro error de medida de tiempo es del segundo
    myDatetime(bo_ind) = [];
    DataSet(bo_ind,:) = [];

    mindt = min(diff(myDatetime));

end

%% STEP 2 
% re span con el mínimo tiempo

new_myDateTime = myDatetime(1):mindt:myDatetime(end);

%% STEP 3 
% interpolamos la tabla  
new_DataSet = [];
new_T_Oven = interp1(myDatetime,DataSet.T_Oven_01,new_myDateTime,'linear');

new_DataSet.Time = new_myDateTime';
for ivar = DataSet.Properties.VariableNames(3:end)
   new_DataSet.(ivar{:}) = interp1(myDatetime,DataSet.(ivar{:}),new_myDateTime,'linear')';
end

new_DataSet = struct2table(new_DataSet);

%% STEP 4
% Calcular la ventana de media 
DT = seconds(5*60); % 
windowAverage = floor(DT/mindt);

%% STEP 5
% Smoothdata
for ivar = new_DataSet.Properties.VariableNames(2:end)
   new_DataSet.(ivar{:}) = smoothdata(new_DataSet.(ivar{:}),1,'movmean',windowAverage);
end

%% STEP 6 
% reducimos el sampling 
new_DataSet_2 = [];
for ivar = new_DataSet.Properties.VariableNames
   new_DataSet_2.(ivar{:}) = new_DataSet.(ivar{:})(1:floor(2*windowAverage):length(new_myDateTime));
end
new_DataSet_2 = struct2table(new_DataSet_2);


%%
clf
hold on
i = 0;
for ivar = new_DataSet_2.Properties.VariableNames(2:end)
    i = i + 1;
    subplot(5,6,i)
    hold on
    plot(myDatetime,DataSet.(ivar{:}),'b.','MarkerSize',1)
    plot(new_DataSet_2.Time,new_DataSet_2.(ivar{:}),'r.-','LineWidth',2,'MarkerSize',10)
    title(ivar{:},'Interpreter','latex')
end