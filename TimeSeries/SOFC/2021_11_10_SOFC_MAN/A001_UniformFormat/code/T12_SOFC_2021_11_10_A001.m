close all
%
clear
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
%
%%
for i = 1:length(ds)
ds{i}.Properties.VariableNames{9} = 'T_inlet_fuel';
ds{i}.Properties.VariableNames{10} = 'T_outlet_fuel';
ds{i}.Properties.VariableNames{11} = 'T_inlet_air';
ds{i}.Properties.VariableNames{12} = 'T_outlet_air_1';
ds{i}.Properties.VariableNames{13} = 'T_outlet_air_2';
ds{i}.T_outlet_air = ds{i}.T_outlet_air_1*0.5 + ds{i}.T_outlet_air_2*0.5;

ds{i}.T_outlet_air_1 = [];
ds{i}.T_outlet_air_2 = [];

ds{i}.Air_tar = ds{i}.Air_01_tar + ds{i}.Air_02_tar;

ds{i}.Air_01_tar = [];
ds{i}.Air_02_tar = [];

ds{i}.T_air_channel = 0.5*ds{i}.T_inlet_fuel + 0.5*ds{i}.T_outlet_fuel;
ds{i}.T_fuel_channel = 0.5*ds{i}.T_outlet_air + 0.5*ds{i}.T_inlet_air;
ds{i}.T_s = 0.5*ds{i}.T_air_channel + 0.5*ds{i}.T_fuel_channel;
ds{i}.T_s = smoothdata(ds{i}.T_s,'SmoothingFactor',0.2);
ds{i}.U153 =ds{i}.U_smooth153;

ds{i}.U_smooth153 =[];
ds{i}.Datetime =[];
ds{i}.T10 =[];
ds{i}.T7 =[];
ds{i}.T9 =[];
ds{i}.T8 =[];
ds{i}.T6 =[];
ds{i}.U_stack_sum_SPS =[];
end

%%
all =vertcat(ds{:});
%%
in_vars = [ all.Properties.VariableNames([11:17 23 20]) ];
out_var = ['U153'];

%%
indata = all{:,in_vars};
%
outdata = all{:,out_var};
%%
inet = feedforwardnet([9 5]);
inet = train(inet,indata',outdata');
%%
clf
for i = 1:length(ds)
    subplot(2,1,1)
    hold on

    plot(ds{i}.I153,inet(ds{i}{:,in_vars}'))
    plot(ds{i}.I153(1:5:end),ds{i}.U153(1:5:end),'.')
    subplot(2,1,2)
    hold on

    plot(ds{i}.DateTime,ds{i}.T_s)
    var(ds{i}.T_s)

    pause
end