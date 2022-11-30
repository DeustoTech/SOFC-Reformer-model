close all
%%
clear
load('TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
old = ds;
ds = [repmat(old(1),1,3) repmat(old(17),1,3)  old];

%%
clf 
for i = 1:6
subplot(3,2,i)
hold on
end

subplot(3,2,1)
ylim([-0.5 40])

subplot(3,2,2)
ylim([-0.5 2000])

colors = jet(length(ds));
iter = 0;

nspan  = linspace(1e-6,0.1,150);

%
m = 0.5355;
n = 0.0313;

newI = linspace(0,120,500);
%
for ids = ds(1:end)
    iter = iter + 1;
    V = ids{:}.U153;
    V = smoothdata(V,'SmoothingFactor',0.1);
    Vs{iter} = V';
    I = ids{:}.I153;
    I = smoothdata(I,'SmoothingFactor',0.1);
    Is{iter} = I';
    VRs{iter} = gradient(V,I)';
    ER_cell = {};

    Vno_exp = V +  m*exp(n*I);
    ER_cell{1} = [1+I*0 -I -log(I)]\Vno_exp;
    E0 = ER_cell{1}(1);
    R  = ER_cell{1}(2);
    A  = ER_cell{1}(3);

      % newI = linspace(I(end),2.5*I(1),100);

   subplot(3,2,1)
   hold on
   plot(I(1:6:end),V(1:6:end),'.','color',colors(iter,:)) 
   plot(newI,E0 - newI.*R - A*log(newI) - m*exp(n*newI),'-','color',colors(iter,:)) 
   subplot(3,2,2)
   hold on
   plot(I(1:6:end),I(1:6:end).*V(1:6:end),'.','color',colors(iter,:)) 
   plot(newI,newI.*(E0 - newI.*R - A*log(newI)  - m*exp(n*newI) ),'-','color',colors(iter,:)) 
   %
   subplot(3,2,3)
   hold on
   plot3(E0,R,A,'.','color',colors(iter,:),'MarkerSize',20)
   view(45,45)
   %
   E0s(iter) = E0;
   Rs(iter)  = R;
   As(iter) = A;
   ms(iter) = m;
   ns(iter) = n;
   subplot(3,2,4)
   plot(I,gradient(V,I),'.','color',colors(iter,:)) 
   
   fin_anode_p = [ids{:}.H2_tar ids{:}.CO2_tar ids{:}.CO_tar ids{:}.CH4_tar  ids{:}.N2_tar  ids{:}.pump_set/60];
   Ts(iter,:) = mean(mean(ids{:}{:,4:13}));
   fin_anode_p = mean(fin_anode_p);
   Total(iter,:) = sum(fin_anode_p,2);
   fin_anode(iter,:) = fin_anode_p./Total(iter,:);
   %
   %Air(iter,:) = mean(ds{1}.Air_01_tar + ds{1}.Air_02_tar);
   %
   
   total  = sum(mean([ids{:}.H2_tar ids{:}.CO2_tar ids{:}.CO_tar ids{:}.CH4_tar  ids{:}.N2_tar  ids{:}.pump_set/60]));
   air = mean((ids{:}.Air_02_tar + ids{:}.Air_01_tar));
   %
   r_anode_cathode(iter,:) = air/total;

    subplot(3,2,5)
end

%%
data = [];
data.A = As';
data.m = ms';
data.n = ns';

data.E0 = E0s';
data.Rs = Rs';
data.H2 = fin_anode(:,1);
data.CO2 = fin_anode(:,2);
data.CO = fin_anode(:,3);
data.CH4 = fin_anode(:,4);
data.N2 = fin_anode(:,5);
data.H2O = fin_anode(:,6);

data.Ts = Ts;

%
data = struct2table(data);

file_out =     '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/code/SOFC-Reformer-model/TimeSeries/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output';

save(fullfile(file_out,'meta_SOFC_ds.mat'),'data')
%%
in_data = [fin_anode Ts r_anode_cathode];
out_data = [As; E0s; Rs]';
%%

mu_in_data = mean(in_data);
std_in_data = std(in_data);
n_in_data = (in_data - mu_in_data)./std_in_data;
%
mu_out_data = mean(out_data);
std_out_data = std(out_data);
%
n_out_data = (out_data - mu_out_data)./std_out_data;

%%
rng(200)
inet = feedforwardnet([3 3 3 ]);
inet.trainParam.mu_dec = 0.5;
inet.performParam.regularization = 1e-4;
inet = train(inet,n_out_data',n_in_data');

%%
pre = inet(n_out_data');
clf
for i=1:3
    subplot(3,1,i)
    hold on
    plot(n_out_data(:,i),'.-')
    plot(pre(i,:),'.-')
    legend('real','pred')
end

%%

%%
clf 
for i = 1:4
subplot(2,2,i)
hold on
end

subplot(2,2,1)
ylim([0 40])
subplot(2,2,3)
ylim([0 40])
subplot(2,2,2)
ylim([0 2000])
subplot(2,2,4)
ylim([0 2000])

iter= 0;
newI = linspace(0,120,500);

for ids = ds(1:end)
    iter = iter + 1;
    V =  Vs{iter}';
    I = Is{iter}';
    
   E0 = E0s(iter) ;
   R = Rs(iter);
   A = As(iter);


   subplot(2,2,1)
   hold on
   plot(I(1:6:end),V(1:6:end),'.','color',colors(iter,:)) 
   plot(newI,E0 - newI.*R - A*log(newI) - m*exp(n*newI),'-','color',colors(iter,:)) 
   subplot(2,2,2)
   hold on
   plot(I(1:6:end),I(1:6:end).*V(1:6:end),'.','color',colors(iter,:)) 
   plot(newI,newI.*(E0 - newI.*R - A*log(newI)  - m*exp(n*newI) ),'-','color',colors(iter,:)) 
   %
   % 
   in = [fin_anode(iter,:) Ts(iter) r_anode_cathode(iter)];
   in = (in - mu_in_data)./std_in_data;
   out_params = inet(in')';
   
   out_params = out_params.*std_out_data + mu_out_data;
   %
   A_esti =  out_params(1);
   E0_esti =  out_params(2);
   R_esti =  out_params(3);
   
   %
   subplot(2,2,3)
   hold on
   plot(I(1:6:end),V(1:6:end),'.','color',colors(iter,:)) 
   %plot(newI,E0 - newI.*R - A*log(newI) - m*exp(n*newI),'--','color',colors(iter,:)) 
   
   plot(newI,E0_esti - newI.*R_esti - A_esti*log(newI) - m*exp(n*newI),'-','color',colors(iter,:)) 

   
   subplot(2,2,4)
   hold on
   plot(I(1:6:end),I(1:6:end).*V(1:6:end),'.','color',colors(iter,:)) 
   %plot(newI,newI.*(E0 - newI.*R - A*log(newI)  - m*exp(n*newI) ),'--','color',colors(iter,:)) 
   %


   plot(newI,newI.*(E0_esti - newI.*R_esti - A_esti*log(newI)  - m*exp(n*newI) ),'-','color',colors(iter,:)) 
   %iter
    %pause
end

nearst_p.std_out = std_out_data;
nearst_p.mu_out = mu_out_data;
nearst_p.std_in = std_in_data;
nearst_p.mu_in = mu_in_data;


% folder =  '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/personal/phd/GreenHouseFolder/GreenHouseModel/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output';
% 
% genFunction(inet,fullfile(folder,'nearst_nn.m'),'MatrixOnly','yes')
% save(fullfile(folder,'nearst_nn_params.mat'),'nearst_p')
% 

%%
clf
scatter3(fin_anode(:,1),fin_anode(:,2),Rs,[],Ts)
grid on
