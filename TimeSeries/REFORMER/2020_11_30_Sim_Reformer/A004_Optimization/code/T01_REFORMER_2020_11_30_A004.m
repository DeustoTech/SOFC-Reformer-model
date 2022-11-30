% MODEL02_REFORMER_denorm
% Inputs u \in \mathbb{R}^3 = {'u_{steam fuel}'  'u_{air fuel}'  'u_T'}
% Outputs  y \in \mathbb{R}^2 = {'CO_mole_out','H2_mole_out'};


clear
u0 = ones(2,1);

%
u_down = [0 0 ];
u_up = [3.5 6];

NT = 5;
Tspan = linspace(500,900,NT);

%%
Ns = 50;
u_sf_line = linspace(0,3.5,Ns);
u_af_line = linspace(0,6,Ns);

[u_sf_ms,u_af_ms] = meshgrid(u_sf_line,u_af_line);
%%
fmt = {'Interpreter','latex','FontSize',20};
%%
figure(1)
set(figure(1),'renderer','Painters')
colors = jet(NT);
setplot(colors,fmt)
title('$x_{CO}$',fmt{:})
%%
figure(2)
set(figure(2),'renderer','Painters')

setplot(colors,fmt)
title('$x_{H2}$',fmt{:})
%%
figure(3)
set(figure(3),'renderer','Painters')

setplot(colors,fmt)
title('$x_{H2}+x_{CO}$',fmt{:})
%%
%%
figure(4)
set(figure(4),'renderer','Painters')

setplot(colors,fmt)
title('$x_{H2}+x_{CO}$',fmt{:})
%%
uopt = zeros(2,NT);

iter = 0;
for iT = Tspan
    iter = iter + 1;
    up = [u_sf_ms(:) u_af_ms(:)];
    u = [up repmat(iT,length(u_af_ms(:)),1)];
    x = MODEL02_REFORMER_denorm(u')';
    Z1 = reshape(x(:,1),Ns,Ns);
    Z2 = reshape(x(:,2),Ns,Ns);

    %
    figure(1)
    surf(u_sf_ms,u_af_ms,Z1,0*Z1 + iT)
    %
    uopt(:,iter) = fmincon(@(u) -sum(MODEL02_REFORMER_denorm([u; iT])),u0, [],[],[],[],u_down,u_up);
    u0 = uopt(:,iter);
    x = MODEL02_REFORMER_denorm([uopt(:,iter);iT]);

    plot3(uopt(1,iter),uopt(2,iter),x(1),'MarkerSize',12,'Marker','o','MarkerFaceColor',colors(iter,:),'MarkerEdgeColor','k')
    
    figure(2)
    surf(u_sf_ms,u_af_ms,Z2,0*Z2 + iT)
    %
    plot3(uopt(1,iter),uopt(2,iter),x(2),'MarkerSize',12,'Marker','o','MarkerFaceColor',colors(iter,:),'MarkerEdgeColor','k')
    %
    figure(3)
    surf(u_sf_ms,u_af_ms,Z2+Z1,0*Z2 + iT)
    %
    plot3(uopt(1,iter),uopt(2,iter),x(2)+x(1),'MarkerSize',12,'Marker','o','MarkerFaceColor',colors(iter,:),'MarkerEdgeColor','k')
    %    
end
%%
plot(uopt(1,:),uopt(2,:),'.')


path = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T01-ReformingDiesel/docs/report/img";
print(figure(1),fullfile(path,'OptPoint_CO.eps'),'-depsc')
print(figure(2),fullfile(path,'OptPoint_H2.eps'),'-depsc')
print(figure(3),fullfile(path,'OptPoint_H2CO.eps'),'-depsc')

%%
figure(4)
set(figure(4),'renderer','Painters')
setplot(colors,fmt)
hold on
%
isurf =  surf(u_sf_ms,u_af_ms,0*Z1,0*Z1 + iT);
%
uopt = zeros(2,NT);
iter = 0;
for iT = Tspan
    iter = iter + 1;
    up = [u_sf_ms(:) u_af_ms(:)];
    u = [up repmat(iT,length(u_af_ms(:)),1)];
    x = MODEL02_REFORMER_denorm(u')';
    Z1 = reshape(x(:,1),Ns,Ns);
    Z2 = reshape(x(:,2),Ns,Ns);

    %
    uopt(:,iter) = fmincon(@(u) -sum(MODEL02_REFORMER_denorm([u; iT])),u0, [],[],[],[],u_down,u_up);
    u0 = uopt(:,iter);
    x = MODEL02_REFORMER_denorm([uopt(:,iter);iT]);

    isurf.ZData = double((Z1+Z2) > (sum(x)-0.2));
    %,0*Z1 + iT)
    
    %plot3(uopt(1,iter),uopt(2,iter),x(1)+x(2),'MarkerSize',12,'Marker','o','MarkerFaceColor',colors(iter,:),'MarkerEdgeColor','k')
    pause(1)
end
%%
function setplot(colors,fmt)
clf
hold on
view(3)
grid on
colormap(colors)
ic = colorbar;
ic.Label.String = 'Temperature(^\circ C)';
ic.Label.FontSize = 15;
box
xlabel('$u_{sf}$',fmt{:})
ylabel('$u_{af}$',fmt{:})
end


