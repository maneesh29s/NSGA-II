function [Y11, Y22] = crossover(P1, P2,D, etac, X_min , X_max)


%% Reference 
% Deb & samir agrawal,"A Niched-Penalty Approach for Constraint Handling in Genetic Algorithms". 
%% SBX cross over operation 
beta = zeros(1,D);

for j = 1: D 
    if P1(j)<P2(j)
       beta(j)= 1 + (2/(P2(j)-P1(j)))*(min((P1(j)-X_min(j)),(X_max(j)-P2(j))));
    else
       beta(j)= 1 + (2/(P1(j)-P2(j)))*(min((P2(j)-X_min(j)),(X_max(j)-P1(j))));
    end   
end
u = rand(1,D);
alpha = 2 - beta.^(-(etac+1));
betaq = (u<=(1./alpha)).*(u.*alpha).^(1/(etac+1))+(u>(1./alpha)).*(1./(2 - u.*alpha)).^(1/(etac+1));
Y11 = 0.5*(((1 + betaq).*P1) + (1 - betaq).*P2);
Y22 = 0.5*(((1 - betaq).*P1) + (1 + betaq).*P2);


a=find (Y11<X_min);
Y11(a) = X_min(a);
b=find (Y11>X_max);
Y11(b) = X_max(b);
c=find (Y22<X_min);
Y11(c) = X_min(c);
d=find (Y22>X_max);
Y11(d) = X_max(d);
    
end