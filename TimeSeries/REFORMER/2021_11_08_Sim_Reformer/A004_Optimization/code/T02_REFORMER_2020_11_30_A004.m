% MODEL02_REFORMER_denorm
% Inputs u \in \mathbb{R}^3 = {'u_{steam fuel}'  'u_{air fuel}'  'u_T'}
% Outputs  y \in \mathbb{R}^2 = {'CO_mole_out','H2_mole_out'};


clear
u0 = ones(2,1);

%
u_down = [0 0 ];
u_up = [3.5 6];

NT = 100;
Tspan = linspace(500,900,NT);

%%
Ns = 100;
u_sf_line = linspace(0,3.5,Ns);
u_af_line = linspace(0,6,Ns);

[u_sf_ms,u_af_ms] = meshgrid(u_sf_line,u_af_line);
%%
fmt = {'Interpreter','latex','FontSize',20};
%%
figure(4)
set(figure(4),'renderer','Painters')
colors = jet(NT);
setplot(colors,fmt)
view(0,90)
%
Z1 = u_af_ms;
isurf =  surf(u_sf_ms,u_af_ms,0*Z1);
iplot =  plot3(0,0,3,'MarkerSize',12,'Marker','o','MarkerFaceColor',colors(1,:),'MarkerEdgeColor','k');
%
shading interp
%
caxis([0 1])
uopt = zeros(2,NT);

theta = @(x) 0.5 + 0.5*tanh(100*x);

factors = [1e-3; 1];
factors = factors./norm(factors); 
%%
iter = 0;

for iT = Tspan
    iter = iter + 1;
    up = [u_sf_ms(:) u_af_ms(:)];
    u = [up repmat(iT,length(u_af_ms(:)),1)];
    x = MODEL02_REFORMER_denorm(u')';
    Z1 = reshape(x(:,1),Ns,Ns);
    Z2 = reshape(x(:,2),Ns,Ns);
    %
    uopt(:,iter) = fmincon(@(u) -sum(factors.*MODEL02_REFORMER_denorm([u; iT])),u0, [],[],[],[],u_down,u_up);
end
%%
percent = 0.1;
iter = 0;
for iT = Tspan
    iter = iter + 1;
    up = [u_sf_ms(:) u_af_ms(:)];
    u = [up repmat(iT,length(u_af_ms(:)),1)];
    x = MODEL02_REFORMER_denorm(u')';
    Z1 = reshape(x(:,1),Ns,Ns);
    Z2 = reshape(x(:,2),Ns,Ns);
    %
    u0 = uopt(:,iter);
    x = MODEL02_REFORMER_denorm([uopt(:,iter);iT]);

    isurf.ZData = theta( factors(1)*Z1 + factors(2)*Z2 - ( sum(factors.*x) - percent*sum(factors.*x)) );
    iplot.XData = uopt(1,iter);
    iplot.YData = uopt(2,iter);
    title("T = "+num2str(iT,'%.0f')+"^\circC"       + ...
                                    " | J(u^*) = x_{CO} + x_{H2} = "  + ...
                                    num2str(sum(factors.*x),'%.3f') + ...
                                    "\pm "+num2str(percent*sum(factors.*x),'%.3f'))
    pause(0.03)
end
%%
function setplot(colors,fmt)
clf
hold on
view(3)
grid on
colormap(colors)
ic = colorbar;
ic.Label.FontSize = 15;
box
xlabel('$u_{sf}$',fmt{:})
ylabel('$u_{af}$',fmt{:})
end


