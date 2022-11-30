function output = SOFC_nn_norm(input,disturbance)
    
std_in =  [234.9790 959.3115 544.6961 47.5853 757.8232 67.5746 220.9908]';
std_out = [0.3385 35.4184 7.0359 4.0677 0.9452 6.5580]';
std_dist =  18.4127;

%

mu_in = [749.6740 1.9932e+03 407.2792 8.8465 939.7907 13.1680 111.0588]';
mu_out= [0 0 0 0 0 0]';
mu_dist= 19.7833;
%

input       = (input- mu_in)./std_in;
disturbance = (disturbance - mu_dist)./std_dist;
%
output = SOFC_nn([input;disturbance]);

output       = output.*std_out + mu_out;

%
