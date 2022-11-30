clear 
inds = [1:20 26 28 32 44 50:54 57];


%pathfolder = [pwd,'/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/'];
%pathfolder = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/ModellingAndControl/backend/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A000_RelatedFiles/SPS_Data";
% Direccion de los datos en bruto
pathfolder = "/Users/djoroya/Google Drive/My Drive/data/AGROSOFC DataSources/SingleCell-First-Batch/SPS_Data";

files = dir(pathfolder);

iter = 0;
nfiles = length(files(3:end));
for ifiles = files(3:end)'
    
    if ~contains(ifiles.name,'.txt')
        continue
    end
    iter = iter + 1;
    DT  = DataSOFC(ifiles.name,pathfolder);

    DataSOFCtable{iter} = DT(:,:);
    DataSOFCtable{iter}.Date.Format = 'dd.MM.uuuu HH:mm';
    DataSOFCtable{iter}.Time.Format = 'dd.MM.uuuu HH:mm';
    DataSOFCtable{iter}.DateTime = DataSOFCtable{iter}.Date + timeofday(DataSOFCtable{iter}.Time);
    %     
    DataSOFCtable{iter}.Date = [];
    DataSOFCtable{iter}.Time = [];

    DataSOFCtable{iter} = TableSeries(DataSOFCtable{iter});
    fprintf("Table "+iter+" of "+nfiles)
end

% direccion de salida, en formato "TableSeries", definido en la libreria
% Modelling and control

fileout = "/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/TimeSeries/AGRO_SOFC/SOFC/2020_12_04_Single_Cell/A001_UniformFormat/output/dataset01.mat";

dataset01 = DataSOFCtable;
save(fileout,'dataset01')
