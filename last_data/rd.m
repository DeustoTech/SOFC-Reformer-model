function OP1 = rd(file)

opts = delimitedTextImportOptions("NumVariables", 24);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["VarName1", "Datetime", "waterFlowratemlmin", "TIR213C", "TIR2141C", "TIR2143C", "TIR2145C", "TIR2147C", "TIR2149C", "TIR21410C", "TIR21412C", "TIR21414C", "TIR21416C", "TIR21418C", "TIRC215C", "FIRC_2_1mlmin", "FIRC_2_2mlmin", "FIRC_2_3mlmin", "GA_H2_act", "GA_CO_act", "GA_CO2_act", "GA_CH4_act", "GA_O2_act", "SumHCppm"];
opts.VariableTypes = ["double", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Datetime", "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, "SumHCppm", "TrimNonNumeric", true);
opts = setvaropts(opts, "SumHCppm", "ThousandsSeparator", ",");

% Import the data
OP1 = readtable("/Users/djoroya/Dropbox/My Mac (Deyviss’s MacBook Pro)/Documents/GitHub/projects/AGRO-SOFC/code/SOFC-Reformer-model/last_data/20220810_20220811_OP_1-4 2/"+file+".csv", opts);

OP1 = OP1(~isnan(OP1.FIRC_2_1mlmin),:);

end

