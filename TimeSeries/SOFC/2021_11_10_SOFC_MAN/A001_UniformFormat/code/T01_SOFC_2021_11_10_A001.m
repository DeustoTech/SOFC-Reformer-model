clear

path_folder = '/Volumes/GoogleDrive/My Drive/data/AGROSOFC DataSources/IV_SOFCMAN_202103_share/SPS_IV';

r = dir(path_folder);

% select .csv files 

b = arrayfun(@(i) contains(r(i).name,'.csv'),1:33);

r = r(b);
csv_path = arrayfun(@(i) fullfile(path_folder,r(i).name),1:30,'UniformOutput',false);
%%
ds = [];
for j = 1:length(csv_path)
    ds{j} = fcn_2021_11_10(csv_path{j});
end
%%
folder_save = '/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2021_11_10_SOFC_MAN/A001_UniformFormat/output/'

save(fullfile(folder_save,'dataset01'),'ds')

%%
iTs = arrayfun(@(i) TableSeries(ds{i}),1:length(ds))
%%
figure(1)
clf
ShowData(iTs(1))