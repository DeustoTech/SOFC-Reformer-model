function Y = MODEL02_REFORMER_denorm(X,~,~)
%
%
% Inputs u \in \mathbb{R}^3 = {'Steam_Fuel_Ratio'  'Air_Fuel_Ratio'  'Temperature'}
% Outputs  y \in \mathbb{R}^2 = {'CO_mole_out','H2_mole_out'};

%% Example
% MODEL02_REFORMER_denorm(  [1.0096         ;   2.7735         ; 868.0640])
% %                          Steam_Fuel_Ratio ; Air_Fuel_Ratio ; Temperature
% ans =
% 
%     0.3129  <- CO_mole_out
%     0.5784  <- H2_mole_out
%%    
% nv = 
% 
%   struct with fields:
% 
%       MEAN_state: [0.1102 0.3437]
%        STD_state: [0.1102 0.3437]
%     MEAN_control: [1.7358 3.0249 699.5949]
%      STD_control: [1.0087 1.7324 116.8246]
     
MEAN_state  = [0.1102 ;0.3437];
STD_state   = [0.1102 ;0.3437];
MEAN_control= [1.7358 ;3.0249 ;699.5949];
STD_control = [1.0087 ;1.7324 ;116.8246];

X = (X - MEAN_control)./STD_control;

[Y,~,~] = MODEL01_REFORMER(X);

Y = Y.*STD_state + MEAN_state;

end