clear 
%%
OP1 = rd('20220810_1130_1333_OP1');
OP2 = rd('20220810_1342_1545_OP2');
OP2_aSE = rd('20220811_1240_1400_OP2_afterSteamError');
OP3_aSE = rd('20220811_1410_1550_OP3_afterSteamError');
OP4_aSE = rd('20220811_1615_1700_OP4_afterSteamError');

%%
close all
clf
%%
figure(1)
plot_gr(OP1)
%%
figure(2)
plot_gr(OP2)

figure(3)
plot_gr(OP2_aSE)

figure(4)
plot_gr(OP3_aSE)

figure(5)
plot_gr(OP4_aSE)
