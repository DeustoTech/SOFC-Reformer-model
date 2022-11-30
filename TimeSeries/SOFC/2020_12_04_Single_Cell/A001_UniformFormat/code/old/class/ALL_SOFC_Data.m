classdef ALL_SOFC_Data
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
    end
    
    methods
        function obj = ALL_SOFC_Data(data)
            obj.data = data;
        end
        
        function VariablesNames = VariablesNames(obj,type)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
                   switch type
                       case 'T_Anodo'
                            VariablesNames = obj.data.Properties.VariableNames([12+4 (3+(1:6)) 13+4]);
                       case 'T_Catodo'
                            VariablesNames = obj.data.Properties.VariableNames([ 18 10:15 17]);
                       case 'Power'
                            VariablesNames = obj.data.Properties.VariableNames(20:21);
                       case 'In_Gases'
                            VariablesNames = obj.data.Properties.VariableNames(22:23);
                       case 'Out_Gases'
                            VariablesNames = obj.data.Properties.VariableNames(24:end);
                       case 'T'
                            VariablesNames = obj.data.Properties.VariableNames([12+4 (3+(1:6)) 13+4 18 10:15 19]);
                       case 'T_in'
                            VariablesNames = obj.data.Properties.VariableNames([16 18]);
                       case 'T_out'
                            VariablesNames = obj.data.Properties.VariableNames([17 19]);
                   end 
        end
    end
end

