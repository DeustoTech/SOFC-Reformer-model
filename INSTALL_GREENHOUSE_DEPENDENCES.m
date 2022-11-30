clear 

%% Set main path
name_file = 'INSTALL_GREENHOUSE_DEPENDENCES.m';
main_path = which(name_file);
main_path = replace(main_path,name_file,'');
%% Go to main path
cd(main_path)
%% clean src/dependence folder 

path_data = fullfile(main_path,'data');
path_depen = fullfile(main_path,'src','dependences');

try rmdir(path_data)
catch end
%
try rmdir(path_depen)
catch end

%% Make dir

mkdir(path_data)
mkdir(path_depen)
%% Download libs


% Modelling And Control
unzip('https://github.com/djoroya/ModellingAndControl/archive/refs/heads/master.zip',path_depen)


%%
addpath(genpath(pwd))