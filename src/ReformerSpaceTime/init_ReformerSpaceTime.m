clear
p = [];

Nx = 25;
Ns = 2;
xspan = linspace(0,1,Nx+1);
xspan = xspan(2:end);
p.dx = xspan(2) -xspan(1);

c0 = zeros(Nx,1);

e = ones(Nx,1);

Dc = spdiags([-e e 0*e],-1:1,Nx,Nx); 
p.Dc = full(Dc);

p.bc = zeros(Nx,2);
p.bc(1,:) = -1;
%
Simulink.Bus.createObject(p)
params = slBus1;
clear slBus1
%

%%
r = sim('transport');


%%
c  = r.logsout.getElement('c');
c1 = permute(c.Values.Data(:,1,:),[3 1 2]);
c2 = permute(c.Values.Data(:,2,:),[3 1 2]);
%
ft = r.logsout.getElement('ft');
ft = permute(ft.Values.Data,[3 2 1]);
%
c1 = [ft(:,1) c1];
c2 = [ft(:,2) c2];

%
%
a = r.logsout.getElement('a').Values.Data;
a = permute(a,[3 1 2]);
%%
new_tspan = linspace(r.tout(1),r.tout(end),500);
new_c1     = interp1(r.tout,c1,new_tspan);
new_c2     = interp1(r.tout,c2,new_tspan);
new_a     = interp1(r.tout,a,new_tspan);

%%
figure(1)
clf
subplot(2,1,1)
hold on
ip1 = plot([0 xspan],new_c1(1,:),'.-');
ip2 = plot([0 xspan],new_c2(1,:),'.-');
ylim([0 30])
xlim([0 xspan(end)])

subplot(2,1,2)
hold on
ylim([0 1.1])
xlim([0 xspan(end)])
ipa = plot(xspan,new_a(1,:));
 

itit = title("t = "+new_tspan(1));
for it = 1:length(new_tspan)
    ip1.YData = new_c1(it,:);
    ip2.YData = new_c2(it,:);
    ipa.YData = new_a(it,:);
    
    itit.String =  char("t = "+new_tspan(it));
    
    
    pause(0.05)
end