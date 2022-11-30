function Y = MODEL02_SOFC(X)
%%
%
% \Delta t = 120 s
%
% Y \in \mathbb{R}^9   => Outputs         Unit (if specified)             
%    T_C_In                                       
%    T_C_Out                                      
%    i_act2                                       
%    V_act                                        
%    v_H2_act                                     
%    v_CO_act                                     
%    v_CO2_act                                    
%    v_CH4_act                                    
%    v_O2_act                                     
%                                                 
% U  \in \mathbb{R}^3   => Inputs          Unit (if specified)             
%    T_Oven_01                                    
%    H2_act                                       
%    Air_act      
%
% 
% Y_K = [U_K Y_{K-1} Y_{K-2}]
%
%% Example
% MODEL02_SOFC(ones(21,1))
% ans =
% 
%     0.7673
%     2.3161
%    -2.0865
%     0.8559
%     1.7375
%     0.6671
%    -0.9245
%    -0.1350
%     0.5530
%%
% U3 = ones(3,1);
% Y1 = ones(9,1);
% Y2 = ones(9,1);
% %
% 
% Y3 = MODEL02_SOFC([U3;Y2;Y1]);
%%
%%
% De normalize
% nv = 
% 
%   struct with fields:
% 
%     MEAN_control: [818.5164 605.0818 1.6422e+03]
%      STD_control: [141.2426 770.2338 682.6227]
%       MEAN_state: [189.2672 176.5484 29.7272 0.7536 65.0681 8.9822 5.7473 0.1940 0.4451]
%        STD_state: [29.3279 29.3180 16.9206 0.2194 23.7297 8.1287 5.3750 0.6569 2.0941]

MEAN_control= [818.5164 605.0818 1.6422e+03];
STD_control = [141.2426 770.2338 682.6227];
MEAN_state  = [189.2672 176.5484 29.7272 0.7536 65.0681 8.9822 5.7473 0.1940 0.4451];
STD_state   = [29.3279 29.3180 16.9206 0.2194 23.7297 8.1287 5.3750 0.6569 2.0941];


MN_IN = [MEAN_control';MEAN_state';MEAN_state'];
STD_IN = [STD_control';STD_state';STD_state'];

MN_OUT = MEAN_state';
STD_OUT = STD_state';
%
X = (X - MN_IN)./STD_IN;

Y = MODEL01_SOFC(X);
Y = Y.*STD_OUT + MN_OUT;