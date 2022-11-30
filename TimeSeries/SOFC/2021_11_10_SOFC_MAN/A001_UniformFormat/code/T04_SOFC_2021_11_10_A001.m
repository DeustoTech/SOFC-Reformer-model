clear

load('TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/model01.mat');

%%
newds = vertcat(newds{:});
%%
vars = newds.Properties.VariableNames;

iter = 0;
clf
for ivar = vars(2:end)
    iter = iter + 1;
    subplot(5,4,iter)
    histogram(newds{:,ivar{:}})
    title(ivar{:},'Interpreter','none')
end

%%
sm = summary(newds);
