function plot_gr(OP1)

name = inputname(1);

t = OP1.Datetime;
%
clf
subplot(5,1,1)
hold on
plot(t,OP1.waterFlowratemlmin,'.')
plot(t,OP1.FIRC_2_1mlmin,'.')
title(name,'interpreter','none')
legend('Water','Air')
xlim([t(1) t(end)])

subplot(5,1,2)
hold on
plot(t,OP1.GA_CH4_act,'.')
plot(t,OP1.GA_CO2_act,'.')
plot(t,OP1.GA_CO_act,'.')
plot(t,OP1.GA_H2_act,'.')
plot(t,OP1.GA_O2_act,'.')
xlim([t(1) t(end)])
legend('CH4','CO2','CO','H2','O2')

subplot(5,1,3)
plot(t,OP1.SumHCppm,'.')
legend('HidroCarbon ppm')
xlim([t(1) t(end)])

subplot(5,1,4)
hold on
plot(t,OP1.TIRC215C,'.')
plot(t,OP1.TIR213C,'.')
legend('T_r^{inlet}','T_r^{outlet}')
xlim([t(1) t(end)])

subplot(5,1,5)
% hold on
% plot(t,OP1.TIR2141C)
% plot(t,OP1.TIR2143C)
% plot(t,OP1.TIR2145C)
% plot(t,OP1.TIR2147C)
% plot(t,OP1.TIR2149C)
% plot(t,OP1.TIR21410C)
% plot(t,OP1.TIR21412C)
% plot(t,OP1.TIR21414C)
% plot(t,OP1.TIR21416C)
% plot(t,OP1.TIR21418C)
% 
% 
% legend("T"+[1 3 5 7 9 10 12 14 16 18])

Temps = arrayfun(@(i)OP1.("TIR214"+i+"C"),([1:2:9,10:2:18]),'UniformOutput',false);
surf(t,[1 3 5 7 9 10 12 14 16 18],[Temps{:}]')
shading interp
view(0,90)
caxis([700 1000])
xlim([t(1) t(end)])
colorbar
colormap('jet')
end

