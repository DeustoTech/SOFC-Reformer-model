function [Inputs,Outputs,numFeatures,numResponses,ndata,mu,st] = cs2narxformat(ics,no,ni,nd)



nstart = max([no,ni,nd]) + 1;
%%

for inexp = 1:length(ics.TableSeries)
    Ins = {};
    for j = 1:ni
        Ins{j} = ics.Inputs{inexp}(:,nstart-j+1:end-j+1)';
    end
    %
    Ins = [Ins{:}];
    %%
    Dis = {};
    for j = 1:nd
        Dis{j} = ics.Disturbances{inexp}(:,nstart-j+1:end-j+1)';
    end
    %
    Dis = [Dis{:}];
    %%
    Outs = {};

    for j = 1:no
        Outs{j} = ics.Outputs{inexp}(:,nstart-j:end-j)';
    end
    %
    Outs    = [Outs{:}];
    %%
    Inputs{inexp} = [Ins Dis Outs]';
    Outputs{inexp} = ics.Outputs{inexp}(:,nstart:end) -  ics.Outputs{inexp}(:,(nstart-1):(end-1));
end

Inputs  = [Inputs{:}]';
Outputs = [Outputs{:}]';
ndata = size(Inputs,1);



mu = mean(Outputs,1);
st = std(Outputs,[],1);
%

Outputs  = (Outputs-mu)./st;

numFeatures = no*ics.Nout + ni*ics.Nin + nd*ics.Ndis;
numResponses =  ics.Nout;

end

