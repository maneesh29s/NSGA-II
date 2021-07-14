function [Z] = PS_cost_new(X,NumO)
global gen_data emm_data X_min;

[ pp , d ] = size(X);

%% Power System Bus Cost Function
% Reference: EED Matlab exchange
FC = zeros(pp,1);
for i = 1:pp
    for j = 1 : d
%         FC(i,1) = FC(i,1) + gen_data(j,1)*(X(i,j).^2) + gen_data(j,2)*X(i,j) + gen_data(j,3) +...
%                     abs(gen_data(j,4)* sin(gen_data(j,5)*(X_min(j)-X(i,j))));
        FC(i,1) = FC(i,1) + gen_data(j,1)*(X(i,j).^2) + gen_data(j,2)*X(i,j) + gen_data(j,3) +...
                    abs(gen_data(j,4)* sin(gen_data(j,5)*(X_min(j)-X(i,j))));
    end
end

EC = zeros(pp,1);
for i = 1:pp
    for j = 1 : d
%        EC(i,1) = EC(i,1) + 0.01*(emm_data(j,1)*(X(i,j).^2) + emm_data(j,2)*X(i,j) + emm_data(j,3))+...
%                     emm_data(j,4)*(exp(emm_data(j,5)*X(i,j)));
        EC(i,1) = EC(i,1) + (emm_data(j,1)*(X(i,j).^2) + emm_data(j,2)*X(i,j) + emm_data(j,3))+...
                      emm_data(j,4)*(exp(emm_data(j,5)*X(i,j)));
    end
end


%% Post processing
Z = [ FC EC ];

if size(Z,1) ~= pp || size(Z,2) ~= NumO 
    error('Theres an error in cost function');
end