function [Z] = PS_cost(X,NumO)
global elddata
global emidata

[ pp , d ] = size(X);

%% Power System Bus Cost Function
% Reference: EED Matlab exchange
FC = zeros(pp,1);
for i = 1:pp
    for j = 1 : d
       FC(i,1) = FC(i,1) + elddata(d,1)*(X(i,j).^2) + elddata(d,2)*X(i,j) + elddata(d,3);
    end
end

EC = zeros(pp,1);
for i = 1:pp
    for j = 1 : d
       EC(i,1) = EC(i,1) + emidata(d,1)*(X(i,j).^2) + emidata(d,2)*X(i,j) + emidata(d,3);
    end
end


%% Post processing
Z = [ FC EC ];

if size(Z,1) ~= pp || size(Z,2) ~= NumO 
    error('Theres an error in cost function');
end