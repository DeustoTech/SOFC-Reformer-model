close all
%%
clear
load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/dataset01.mat')
%%
clf 
for i = 1:6
subplot(3,2,i)
hold on
end

subplot(3,2,1)
ylim([-10 40])

subplot(3,2,2)
ylim([-10 2000])

colors = jet(length(ds));
iter = 0;

nspan  = linspace(1e-6,0.1,100);
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
    j = 0;
    for in = nspan
        j = j + 1;
        ER_cell{j} = [1+I*0 -I -log(I) -exp(in*I)]\V;
        E0 = ER_cell{j}(1);
        R  = ER_cell{j}(2);
        A  = ER_cell{j}(3);
        m = ER_cell{j}(4);
        if m<0
            ER_cell{j} = [1+I*0 -I -log(I)]\V;
            E0 = ER_cell{j}(1);
            R  = ER_cell{j}(2);
            A  = ER_cell{j}(3);
            m  = 0;
            ER_cell{j}(4) = m;
        end

        errors(j) = mean((E0 - I.*R - A*log(I) - m*exp(in*I) - V).^2);
        if R <0
            errors(j) = nan;
        end
    end

    errors(errors > 1) = nan;
    [~,ind] = min(errors);
    
    E0 = ER_cell{ind}(1);
    R  = ER_cell{ind}(2);
    A  = ER_cell{ind}(3);
    m  = ER_cell{ind}(4);
    if m == 0
        n = 0;
    else
        n = nspan(ind);
    end
       newI = linspace(I(end),1.5*I(1),100);

   subplot(3,2,1)
   hold on
   plot(I(1:6:end),V(1:6:end),'.','color',colors(iter,:)) 
   plot(newI,E0 - newI.*R - A*log(newI) - m*exp(n*newI),'-','color',colors(iter,:)) 
   subplot(3,2,2)
   hold on
   plot(I(1:6:end),I(1:6:end).*V(1:6:end),'.','color',colors(iter,:)) 
   plot(newI,newI.*(E0 - newI.*R - A*log(newI)  - m*exp(n*newI) ),'-','color',colors(iter,:)) 
   %%
   subplot(3,2,3)
   hold on
   plot3(E0,R,A,'.','color',colors(iter,:),'MarkerSize',20)
   view(45,45)
   %%
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

    subplot(3,2,5)
    plot(nspan,errors)
end

%%
data = [];
data.A = As;
data.m = ms;
data.E0 = E0s;
data.Rs = Rs;
%%
in_data = [fin_anode Ts];
out_data = [As; ms; E0s; Rs]';
%%
norm_in_data = (in_data);
norm_out_data = (out_data);

%%
%inet = feedforwardnet([7]);
%%
%inet = train(inet,norm_in_data',norm_out_data');
%%
%out = inet(norm_in_data');

% %%
% clf 
% for i = 1:4
%    subplot(2,2,i)
%    histogram(out(i,:))
% end