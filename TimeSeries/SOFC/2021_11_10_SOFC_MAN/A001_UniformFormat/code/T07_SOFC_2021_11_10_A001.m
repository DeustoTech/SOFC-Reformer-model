
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/model01.mat')
clearvars -except newds

%% Removemos todas las medidas con mas de I[A] > 0.5 A

iter = 0;

newds03 = zeros(length(newds),18);
for is = newds
   iter = iter + 1;
   newds02{iter} = is{:}(is{:}.I153 < 0.5,:);
   newds03(iter,:) = mean(newds02{iter}{:,2:end});
end

newds03 = array2table(newds03,'VariableNames',newds02{1}.Properties.VariableNames(2:end));


%%
newds04 = newds03(:,{'T_int_air','T_out_air','T_out_fuel','T_out_air','AirMass','H2_tar','CO2_tar','CO_tar','CH4_tar','N2_tar','U153'});


Tmu = mean(newds04{:,1:4},2);
newds04.Tmu = Tmu;

newds05 = newds04(:,{'Tmu','AirMass','H2_tar','CO2_tar','CO_tar','CH4_tar','N2_tar','U153'});

YData = newds05.U153;
XData = newds05{:,1:end-1};


w1XData = [ones(size(XData,1),1) XData];


B = w1XData\YData; 
%%

Vpred = XData*B(2:end) + B(1);
%
XData_rand = XData + 1e-6*rand(size(XData));
Vpred_rand = XData_rand*B(2:end) + B(1);

%
figure(1)
clf 
subplot(1,2,1)
hold on
plot(Vpred,YData,'o')
plot([26 33],[26 33])
legend('pred')
daspect([1 1 1])
subplot(1,2,2)
hold on
plot(YData,'-')
plot(Vpred,'-')
plot(Vpred_rand,'-')
legend('real','pred','noise')