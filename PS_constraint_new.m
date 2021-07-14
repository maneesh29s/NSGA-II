function error_normalized = PS_constraint_new(X,D)
global Bij Bio Boo;
global Pd;

[ pp , ~ ] = size(X);
num_constraints = 1;

assert(size(X,1) == pp);
assert(size(X,2) == D);

Ptl = zeros(pp,1);

% for i = 1:pp
%    Ptl(i,1) =  X(i,:) * Bij * X(i,:)' + X(i,:)*Bio + Boo;
% end

constr = Ptl + Pd;

err = sum(X,2) - constr;

err = abs(err);

err = (err > 1e-2).* err;

assert(size(err,1) == pp);
assert(size(err,2) == num_constraints);

error_normalized = normalisation(err,true);

assert(size(error_normalized,1) == pp);
assert(size(error_normalized,2) == 1);

%% if no constraints, 
% error_normalized = zeros(pp,1);

end