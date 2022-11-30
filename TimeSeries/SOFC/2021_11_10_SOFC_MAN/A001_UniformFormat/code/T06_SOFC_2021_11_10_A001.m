clear 
load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/validate_data.mat')


figure('unit','norm','pos',[0 0 0.5 1])
clf

list = 5:6;

n = length(list);

ui_out = uipanel('unit','norm','pos',[0.5 0.0 0.5 1]);

iter = 0;
for ind = list
    iter = iter + 1;
    pred_out = fcn_pred(newds{ind}{:,input_vars});
    outputs = newds{ind}{:,output_vars};
    DT = newds{ind}.DateTime;

    for i = 1:3
        ax =subplot(n,3, (iter-1)*3+ i,'Parent',ui_out);
        hold(ax,'on')
        plot(DT,pred_out(i,:),'-')
        plot(DT,outputs(:,i),'.')
        legend(ax,'pred','real')
        title(ax,output_vars{i},'Interpreter','none','FontSize',15)
    end
end
%

ui_in = uipanel('unit','norm','pos',[0.0 0.0 0.5 1]);
in_vars_mid = {'T_int_air','T_int_fuel','I153'};
iter = 0;
for ind = list
    iter = iter + 1;
    inputs = newds{ind}{:,in_vars_mid};
    DT = newds{ind}.DateTime;

    for i = 1:3
        ax =subplot(n,3, (iter-1)*3+ i,'Parent',ui_in);
        hold(ax,'on')
        plot(DT,inputs(:,i),'.')
        legend(ax,'real')
        title(ax,in_vars_mid{i},'Interpreter','none','FontSize',15)
    end
end


%%

for ind = 1:30
figure('unit','norm','pos',[0 0 0.4 1])
clf
pred_out = fcn_pred(newds{ind}{:,input_vars});
outputs = newds{ind}{:,output_vars};
inputs =newds{ind}{:,in_vars_mid};
DT = newds{ind}.DateTime;

sty = {'Interpreter','latex','FontSize',20};
%
select = 1:10:size(outputs,1);

%

subplot(4,2,1)
hold on
plot(DT(select),outputs(select,1),'.')
plot(DT,pred_out(1,:),'LineWidth',1.5)
legend('data','pred')
title('$V$',sty{:})
xlabel('time')
grid on

%
subplot(4,2,2)
hold on
plot(DT(select),outputs(select,2),'.')
plot(DT,pred_out(2,:),'LineWidth',1.5)
legend('data','pred')

title('$\Delta T_{cath}[^\circ C]$',sty{:})
xlabel('time')
grid on
%
subplot(4,2,3)
hold on
plot(DT(select),outputs(select,3),'.')
plot(DT,pred_out(3,:),'LineWidth',1.5)
legend('data','pred')

title('$\Delta T_{an}[^\circ C]$',sty{:})
xlabel('time')
grid on

%
subplot(4,2,6)
hold on
plot(DT(select),inputs(select,1),'-','LineWidth',1.5)
plot(DT(select),inputs(select,2),'-','LineWidth',1.5)
legend('$T_{in}^{air}$','$T_{in}^{fuel}$','FontSize',15,'Interpreter','latex')
title('$T_{in}[^\circ C]$','Interpreter','latex','FontSize',15)
grid on
%
subplot(4,2,5)
hold on
plot(DT(select),inputs(select,3),'-','Linewidth',1.5)
title('$I$','FontSize',15,'Interpreter','latex')
grid on
%
subplot(4,2,[7 8])
cla
hold on
color = jet(7);
air_flow =  uniquetol(newds{ind}{:,input_vars(7)},'ByRows',1);
%
concentration = uniquetol(newds{ind}{:,input_vars(1:6)},'ByRows',1);

m_syngas = sum(concentration);
a_f_ratio = air_flow/m_syngas;

concentration = 100*concentration./sum(concentration);
for i = 1:6
ibar = bar(i,concentration(i),0.2,'FaceColor',color(i,:));
end

xlim([0 7])
xticks(1:7)
ylabel('% mass' )
grid on
xticklabels({'H_2O','CO','CO_2','H_2','CH_4','N_2'})
title("r_{a/f} = (m_{air}/m_{syngas}) = "+num2str(a_f_ratio,'%.0f') + " | " + " m_{syngas} = "+num2str(m_syngas,'%.3e')+" kg/s")

subplot(4,2,4)

Vpred = pred_out(1,:)';

I_in = inputs(:,3);
hold on
plot(inputs(select,3),outputs(select,1),'o')
plot(I_in,Vpred,'LineWidth',1.5)
xlabel('I[A]')
ylabel('V[V]')
title('V/I' )
legend('data','pred')

grid on

file = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/Reformer-AGRO-SOFC-paper/img/validation';

file = fullfile(file,"val"+ind+".eps");

print(file,'-depsc')


end
