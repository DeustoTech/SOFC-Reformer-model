function main_path = MainPath()


name_file = 'InitTimeSeries.m';
main_path = which(name_file);
main_path = replace(main_path,name_file,'');


end

