clear
load(MainPath+"/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics.mat")

dt_rare = ics.TableSeries(4).DateTime(end) - ics.TableSeries(5).DateTime(1);
dt_rare = dt_rare+hours(4);
for i = 5:11
    ics.TableSeries(i).DateTime = ics.TableSeries(i).DateTime + dt_rare;
end
%%
ics.TableSeries(1) = subselect(ics.TableSeries(1),100:668);
ics.TableSeries(3) = subselect(ics.TableSeries(3),1:3000);
ics.TableSeries(4) = subselect(ics.TableSeries(4),1:100);
ics.TableSeries(5) = subselect(ics.TableSeries(5),1:100);
ics.TableSeries(10) = subselect(ics.TableSeries(10),1:100);
ics.TableSeries(14) = subselect(ics.TableSeries(14),1:100);
ics.TableSeries(16) = subselect(ics.TableSeries(16),1:100);
ics.TableSeries(18) = subselect(ics.TableSeries(18),1:100);
ics.TableSeries(23) = subselect(ics.TableSeries(23),1:150);
ics.TableSeries(25) = subselect(ics.TableSeries(25),120:260);
ics.TableSeries(30) = subselect(ics.TableSeries(30),1600:1700);
ics.TableSeries(31) = subselect(ics.TableSeries(31),1:100);
ics.TableSeries(32) = subselect(ics.TableSeries(32),2400:3706);

ics.TableSeries(8) = subselect(ics.TableSeries(8),120:400);
% %
% ics.TableSeries    = ics.TableSeries([1:3 5:29]);
% ics.TableSeries(3) = subselect(ics.TableSeries(3),500:1200);
% ics.TableSeries(4) = subselect(ics.TableSeries(4),1:200);
% ics.TableSeries(7) = subselect(ics.TableSeries(7),1:200);
% ics.TableSeries(9) = subselect(ics.TableSeries(9),1:200);
% ics.TableSeries(13) = subselect(ics.TableSeries(13),1:200);
% ics.TableSeries(15) = subselect(ics.TableSeries(15),1:200);
% ics.TableSeries(17) = subselect(ics.TableSeries(17),1:300);
% ics.TableSeries(20) = subselect(ics.TableSeries(20),1:180);
% ics.TableSeries(22) = subselect(ics.TableSeries(22),1:350);
% ics.TableSeries(24) = subselect(ics.TableSeries(24),300:ics.TableSeries(24).ndata);

%%
% ics.TableSeries(3) = subselect(ics.TableSeries(3),1:5000);
% ics.TableSeries(4) = subselect(ics.TableSeries(4),1:300);
% 
% ics.TableSeries(7) = subselect(ics.TableSeries(7),1:150);
% 
% ics.TableSeries(9) = subselect(ics.TableSeries(9),100:400);
% ics.TableSeries(10) = subselect(ics.TableSeries(10),1:100);
% 
% ics.TableSeries(11) = subselect(ics.TableSeries(11),50:150);
% 

for i = 1:length(ics.TableSeries)
    ics.TableSeries(i).DataSet.i_act2(ics.TableSeries(i).DataSet.i_act2<0) = 0;
    %ics.TableSeries(i) = UniformTimeStamp(ics.TableSeries(i),'DT',minutes(5));
end




save(MainPath+"/AGRO_SOFC/SOFC/2021_04_27_MergeData/A001_UniformFormat/output/ics02.mat",'ics')
