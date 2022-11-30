clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/TimeSeries/AGRO_SOFC/SOFC/2021_04_27_MergeData/A003_Modelling/output/model02_linear.mat')

%%
import casadi.*

x0sym = SX.sym('x0',ics.Nout);
usym = SX.sym('u',ics.Nin);
dsym = SX.sym('d',ics.Ndis);

%%
nexp =1;
%%

ut = ics.Inputs{nexp}';
xt = ics.Outputs{nexp}';
dt = ics.Disturbances{nexp}';
%%
N = length(dt) - 1;
model_step = casadi.Function('model',{x0sym,usym,dsym},{pred([usym(:);x0sym(:);dsym(:)],opt_params)});
model = model_step.map(N);

%%
x0 = xt(1,:)';
xt_pred = model(x0,ut(2:end,:)',dt(2:end,:)')';
xt_pred = [x0' ;xt_pred];
%%
subN = 334;
figure(1)
subplot(3,1,1)
plot(ics.tspan{nexp}(1:subN),full(xt_pred(1:subN,:)),'.-')
ylim([-2 3])
title('Pred')
legend(ics.OutputVars,'Interpreter','none','Location','bestoutside')


subplot(3,1,2)
plot(ics.tspan{nexp}(1:subN),full(xt(1:subN,:)),'.-')
ylim([-2 3])
title('Real')
legend(ics.OutputVars,'Interpreter','none','Location','bestoutside')

subplot(3,1,3)
err = abs(full(xt_pred(1:subN,:)) - full(xt(1:subN,:)));
plot(ics.tspan{nexp}(1:subN),err,'.-' )
ylim([-2 3])
title('Error')
legend(ics.OutputVars,'Interpreter','none','Location','bestoutside')

