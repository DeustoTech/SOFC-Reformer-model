classdef exp_SOFC
    %Experimento de la PILA
    
    properties
        table
    end
    
    methods
        function obj = exp_SOFC(table)
            %EXP_SOFC Construct an instance of this class
            
            obj.table = table;
        end
        
        function plot(obj)
            i = 0;
           for ivar = obj.table.Properties.VariableNames(2:end)
               i = i + 1;
               subplot(5,6,i)
               plot(obj.table.Time,obj.table.(ivar{:}),'LineStyle','-','Marker','.')
               title(ivar{:},'Interpreter','latex')

           end
        end
        function ids = IN_OUT(obj)
            
            input  = obj.table(:,[2 3 22 23]);
            
            output = [ obj.table(:,[4:19 24:28]) obj.table(:,20:21)];
            
            time = obj.table(:,1);
            ids = ds(time,input,output);
        end
        
    end
end

