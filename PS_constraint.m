function error_normalized = PS_constraint(X,D)
global B;
global Pd;

[ pp , ~ ] = size(X);
num_constraints = 1;

assert(size(X,1) == pp);
assert(size(X,2) == D);

Ptl = zeros(pp,1);

for i = 1:pp
   Ptl(i,1) =  X(i,:) * B * X(i,:)';
end

constr = Ptl + Pd;

err = constr - sum(X,2);

err = (err > 0).* err; 

assert(size(err,1) == pp);
assert(size(err,2) == num_constraints);

error_normalized = normalisation(err);

assert(size(error_normalized,1) == pp);
assert(size(error_normalized,2) == 1);

%% if no constraints, 
% error_normalized = zeros(pp,1);

end