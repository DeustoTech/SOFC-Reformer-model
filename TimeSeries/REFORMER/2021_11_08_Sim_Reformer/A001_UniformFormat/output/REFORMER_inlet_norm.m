function Y = REFORMER_inlet_norm(X)

in_norm_mu   = [1.7358 3.0249]';
in_norm_std  = [1.0087 1.7324]';

out_norm_mu =  [0.2163 6.1434e-05 0.1718 0.0489]';
out_norm_std = [0.1111 3.0611e-05 0.0363 0.0244]';


X = (X - in_norm_mu)./in_norm_std;
Y = REFORMER_inlet(X);
Y = Y.*out_norm_std + out_norm_mu;
    
end

