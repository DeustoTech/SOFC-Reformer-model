function lp = loadpath(name,stage)
    
    r = what(name);
    
    if isempty(r)
       error('Esa carpeta no existe...') 
    end
   
    switch stage
        case 1
            st = 'A001_UniformFormat';
        case 2
            st = 'A002_VisualizationVariables';
        case 3
            st = 'A003_Modelling';
        case 4
            st = 'A004_Validation';
    end
    
    
    lp = fullfile(r.path,st,'output');
    
    if ~exist(lp,'dir')
       error("La carpeta existe, pero no existe output para: "+st) 
    end
end

 