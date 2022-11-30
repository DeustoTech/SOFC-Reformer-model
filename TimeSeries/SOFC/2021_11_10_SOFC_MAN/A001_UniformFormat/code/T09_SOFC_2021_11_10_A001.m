clear

load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/model01.mat')
clearvars -except newds

newds = [repmat(newds(1),1,10) newds];
%%
p = Molar_kg_mol;
%%
figure(1)
clf
subplot(2,1,1)
hold on 
subplot(2,1,2)
hold on 
for ids = newds(1)
   subplot(2,2,1)
   plot(ids{:}.I153,ids{:}.U153,'.')
   xlabel('I[A]')
   ylabel('V[V]')
   grid on
   subplot(2,2,2)
   plot(ids{:}.I153,ids{:}.U153.*ids{:}.I153,'.')
   xlabel('I[A]')
   ylabel('W_e[W]')
   grid on

   subplot(2,2,3)
   tspan = ids{:}.DateTime - ids{:}.DateTime(1);
   plot(tspan,ids{:}{:,2:5},'.')
   ylabel('Temperature')
   legend(ids{:}.Properties.VariableNames(2:5),'Interpreter','none','Location','bestoutside')

   subplot(2,2,4)
   
end
%%

%%
figure(2)
clf
for i = 1:4
subplot(2,2,i)
%hold on
end
%
iter = 0;
Bdata = [];
InletMassFraction = [];
Base = @(I) [1+0*I  -I ];
Ipred = linspace(0.001,80,500)';
TData = [];

Vfcn = @(I,E,A,m,n,R) E - I*R - A*log(I) - m*exp(n*I);

Vfcn = @(I,E,A,R) E - I*R -A*log(I);

Vfcn_vec = @(I,p)  Vfcn(I,p(1),p(2),p(3));

p0 = [  1.031 ... % E,
        0.002 ... % A,
        1e-4  ... % m,
        8e-3  ... % n,
        2.45e-4 ]; % R
    
p0 = [  1.031 ... % E,
        0.002 ... % A,
        2.45e-4 ]; % R
p0 = p0 + 1e-3*p0*(rand-0.5);

mu = 0;
sigma = 20;
IGauss = @(I) (1/(sigma*sqrt(2*pi))) * exp(-(I-mu).^2/(2*sigma^2));

for ids = newds
    iter = iter + 1;

    %
    fm  = ids{:}.FuelMass;
    H2O = uniquetol(ids{:}.pump_set)/p.H2O;
    CO  = uniquetol(ids{:}.CO_tar)/p.CO;
    CO2 = uniquetol(ids{:}.CO2_tar)/p.CO2;
    H2  = uniquetol(ids{:}.H2_tar)/p.H2;
    CH4 = uniquetol(ids{:}.CH4_tar)/p.CH4;
    N2 =  uniquetol(ids{:}.N2_tar)/p.N2;
    
    InletMassFraction(iter,:) = [H2O CO CO2 H2 CH4 N2]/sum([H2O CO CO2 H2 CH4 N2]); 
    %InletMassFraction(iter,:) = [H2O H2]; 

    Air_Fuel(iter) =  uniquetol(ids{:}.AirMass./p.Air)/sum([H2O CO CO2 H2 CH4 N2]);
    TData(iter) = mean(ids{:}{:,2:5},'all');
    
    I = ids{:}.I153;
    V = ids{:}.U153;
    
    %
    %B = Base(I)\V;
    lb = [0 0 0 0 0]';
    %lb = [];
    if iter > 2
        p0 = p_opt;
    end 
    p_opt = fmincon(@(p) sum((Vfcn_vec(I,p) - V).^2),p0, ...
                                                     [],[], ...
                                                     [],[], ...
                                                     lb,[]);
    
    %
    VPred = Vfcn_vec(Ipred,p_opt);
    clf
    subplot(3,1,1)
    hold on
    plot(I,V,'.')
    plot(Ipred,VPred,'-')
    xline(0)
    yline(0)
    title(num2str(InletMassFraction(iter,:)))
ylim([-1 Inf])
    subplot(3,1,2)
    hold on
    plot(I,V.*I,'.')
ylim([-1 Inf])

    
    plot(Ipred,VPred.*Ipred,'-')
    xline(0)
    yline(0)
%     

    VPred2 = Vfcn_vec(I,p_opt);

 
    Bdata(iter,:) = p_opt;
    
    subplot(3,1,3)
    plot(ids{:}{:,2:5})

   pause(0.1)
end

IMF_uni = uniquetol(InletMassFraction,1e-2,'ByRows',1);

%%
Labels = arrayfun(@(i) find(sum((InletMassFraction(i,:) - IMF_uni).^2,2) < 1e-6),1:size(InletMassFraction,1),'UniformOutput',1);
%%

InData = [ TData' InletMassFraction Air_Fuel']';

mu_in = mean(InData,2);
std_in = std(InData,[],2);

InData_norm = (InData - mu_in)./std_in;
%

OutData = Bdata';

mu_out = mean(OutData,2);
std_out = std(OutData,[],2);
%std_out = 1./[5 1 5 5 5]';
%max_out = max(OutData,[],2) - std_out;
OutData_norm = (OutData - mu_out)./std_out;

%OutData_norm = OutData;

%OutData_norm = (OutData-mu_out)./std_out ;
%%
%Am = InData_norm'\OutData_norm';
%
rng(10)
inet = feedforwardnet([7 7]);
%inet.layers{end}.transferFcn = 'poslin';
inet = train(inet,InData_norm,OutData_norm);
%%

Ipred = linspace(1,60,500)';
figure(1)
clf
iter = 0;
for ids = newds
    
    iter = iter + 1;

    %
    InData_step = [ TData(iter) InletMassFraction(iter,:) Air_Fuel(iter) ]';
    %
    %InData_step_norm = InData_step;
    InData_step_norm = (InData_step - mu_in)./std_in;
    %
    
    
    %OutData_step_norm = Am'*InData_step_norm;
    OutData_step_norm = inet(InData_step_norm);
    %
    OutData_step = OutData_step_norm.*std_out + mu_out;
    %OutData_step(OutData_step < 0) = 0;

    %OutData_step = OutData_step_norm.*max_out;
    %OutData_step = OutData_step_norm;
    I = ids{:}.I153;
    V = ids{:}.U153;
    
    %
    VPred = Vfcn_vec(Ipred,OutData_step);
    VPred_real = Vfcn_vec(Ipred,Bdata(iter,:));

    clf
    subplot(2,1,1)
    hold on
    plot(I,V,'.')
    plot(Ipred,VPred,'-')
    plot(Ipred,VPred_real,'-')
    legend('data','pred','real_pre')
    xline(0)
        ylim([0 Inf])

    %yline(0)
    title(num2str(InletMassFraction(iter,:)))
    subplot(2,1,2)
    hold on
    plot(I,V.*I,'.')
    plot(Ipred,Ipred.*VPred,'-')
    plot(Ipred,Ipred.*VPred_real,'-')
        legend('data','pred','real_pre')

    ylim([0 Inf])
   pause(0.1)
end
%%