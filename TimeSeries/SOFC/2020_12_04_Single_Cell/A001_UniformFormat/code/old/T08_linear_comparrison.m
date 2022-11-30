clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/DataSOFC_reduce.mat')
DTcat = cat(1,DT_All{:});

ids =  ALL_SOFC_Data(DTcat);
%% Linera representation
fig = figure(1)
clf
i = 0;
j = 0;
for ivar = ids.VariablesNames('T_out')
    i = i + 1;
    j = 0;
    for jvar = ids.VariablesNames('T_out')
        j = j +1;
        if j<=i
            continue
        end
        subplot(16,16,(i-1)*16 + j)
        
        plot(ids.data.(ivar{:}),ids.data.(jvar{:}))
        %
        result = fitlm(ids.data.(ivar{:}),ids.data.(jvar{:}));
        
        
        %title(result.Rsquared.Ordinary)
        title([ivar{:},'vs' ,jvar{:}],'FontSize',7,'Interpreter','latex')
        %
    end
end