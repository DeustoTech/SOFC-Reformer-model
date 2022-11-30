clear;

load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')

%
vars = {'H2_act'     'CO_act'     'CO2_act'     'CH4_act'     'O2_act'     'N2_act'};

for i = 1:30
   ds{i}.Datetime = [];
   ds{i}.U153 = [];
   ds{i}.pump_set = ds{i}.pump_set/60;
   ds{i}.Air_tar = ds{i}.Air_01_tar  + ds{i}.Air_02_tar;
   ds{i}.Air_01_tar = [];
   ds{i}.Air_02_tar = [];
   ds{i}.U_stack_sum_SPS = [];

   ds{i}.Properties.VariableNames{23} = 'H2O_tar';
   ds{i}.Properties.VariableNames{24} = 'I';
   ds{i}.Properties.VariableNames{25} = 'V';
   for ivar = vars
       ib = ds{i}.(ivar{:}) < 100;
       ds{i}.(ivar{:})(ib) = 0;
   end
   ds{i}(:,{'T6','T7','T8','T9','T10'}) = [];
   
   ds{i}.Tair_out = ds{i}.T1 + ds{i}.T2;
  
   ds{i}(:,{'T1','T2'}) = [];

   ds{i}.Properties.VariableNames{2} = 'Tfuel_in';
   ds{i}.Properties.VariableNames{3} = 'Tfuel_out';
   ds{i}.Properties.VariableNames{4} = 'Tair_in';
end
%%
%%
pathfile = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/personal/phd/GreenHouseFolder/GreenHouseModel/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output'

save(fullfile(pathfile,'T15_SOFC_2021_11_10_A001'),'ds');