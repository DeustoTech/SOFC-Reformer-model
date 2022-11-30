clear

load('TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/model01.mat');

%%

clf
hold on



list = {[1:4],[5:8],[9:12],[13:16],[17:20],[21:24]};
for j = 1:6
    subplot(3,2,j)
    hold on

    n = length(list{j});
    colors = hsv(n);
    %
    ln = [];
    
    iter = 0;
    for i = list{j}
       iter = iter + 1;
       inputs = newds{i}{:,input_vars};
       outputs = fcn_pred(inputs);
       %
       I = newds{i}.I153;
       V = outputs(1,:);
       ln(iter) = plot(I,V,'color',colors(iter,:),'LineStyle','-','LineWidth',2);
       ndata = length(I);
       dd = 6;
       plot(I(1:dd:ndata),newds{i}.U153(1:dd:ndata),'color',colors(iter,:),'LineStyle','none','Marker','o','MarkerSize',7)
    end

    names = [repmat('Exp-',n,1) num2str(list{j}')];
    names = cellstr(names);
    xlabel('I[A]','Interpreter','latex','FontSize',20)
    ylabel('V[V]','Interpreter','latex','FontSize',20)
    grid on
    xlim([-5 80])
    ylim([20 32])
    legend(ln,names)
end


%%


%%
inflow = {'pump_set','H2_tar','CO2_tar','CO_tar','CH4_tar','N2_tar'};

figure(2)
clf
hold on
iter = 0

NN = 5;
colors = jet(NN);

subplot(2,1,1)
xlabel('I(A)')
ylabel('V(V)')


for i = 1:NN
   iter = iter + 1;
   inputs = newds{i}{:,input_vars};
   outputs = fcn_pred(inputs);
   %
   I = newds{i}.I153;
   V = outputs(1,:);
   Xc = mean(newds{i}{:,inflow});
   subplot(2,1,1)
   hold on
   plot(I,V,'LineStyle','-','LineWidth',2,'color',colors(i,:));
   ndata = length(I);
   ax = subplot(2,NN,NN+iter);
   ib = bar(Xc,'FaceColor',colors(i,:));
   ylim([0 5.7e-4])

   ylabel('kg/s')

   yyaxis right 

   AirMean = mean(newds{i}{:,'AirMass'});
   bar(7,AirMean,'FaceColor',[0.5 0.5 0.5])
   

   ylim([0 1.8e-3])
   ylabel('kg(Air)/s')
   
         ib.Parent.XTickLabelRotation = 90;
   ib.Parent.XLabel.Interpreter = 'latex';
   ib.Parent.XAxis.TickLabelInterpreter = 'none';
   xticklabels([inflow,'Air']);
   xticks(1:7)

   grid on
end

%%



