function path_out = savepath()
    t = dbstack;
    path_code = replace(which(t(2).file),t(2).file,'');
    path_out = fullfile(path_code,'..','output');
    if ~exist(path_out,'dir')
       mkdir(path_out) 
    end
end

