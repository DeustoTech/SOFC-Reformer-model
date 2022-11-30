clear 

load('/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/DataSOFC.mat')


DT_All = [];

i = 0;

figure('unit','norm','pos',[0 0 1 1])
isplot = false;
pathfolder = [pwd,'/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/AGRO-SOFC/T03-SOFC/code/examples/modeling/2020-12-15-RealSOFC/data/SPS_Data/'];

for iDT = DataSOFCtable
    i = i + 1;
    
    namepic = pathfolder+"/smooth"+i+".png";
    
    %DT_All{i} = smoothDATASOFC(iDT{:},namepic);
    DT_All{i} = smoothDATASOFC(iDT{:});

end
%%

save(fullfile(pathfolder,'DataSOFC_reduce'),'DT_All')
