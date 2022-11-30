function r = pathdata(name_project,stage,filename)
    r = (fullfile(loadpath(name_project,stage),filename));
end