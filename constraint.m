function error_normalized = constraint(X,D)

[ pp , ~ ] = size(X);

assert(size(X,1) == pp);
assert(size(X,2) == D);

%% Binh and Korn Function
% % err = [];
% % num_constraints = 2;
% % 
% % c1 = (X(:,1)-5).^2 + X(:,2).^2 - 25;
% % err(:,1) = ( c1 > 0 ).* c1;
% % 
% % c2 = (X(:,1)-8).^2 + (X(:,2)+3).^2 - 7.7;
% % err(:,2) = ( c2 < 0 ).* c2;
% %
%% Osyczka and Kundu Fucntion 
% num_constraints = 6;
% c1 = X(:,1) + X(:,2) - 2 ;
% err(:,1) = ( c1 < 0 ) .* c1;
% 
% c2 = 6 - X(:,1) - X(:,2) ;
% err(:,2) = ( c2 < 0 ) .* c2;
% 
% c3 = 2 + X(:,1) - X(:,2) ;
% err(:,3) = ( c3 < 0 ) .* c3;
% 
% c4 = 2 - X(:,1) + 3.* X(:,2) ;
% err(:,4) = ( c4 < 0 ) .* c4;
% 
% c5 = 4 - ( X(:,3) - 3).^2 - X(:,4);
% err(:,5) = ( c5 < 0 ) .* c5;
% 
% c6 = ( X(:,5) - 3 ).^2 + X(:,6) - 4 ;
% err(:,6) = ( c6 < 0 ) .* c6;

%% Postprocessing for constaints only
% err = abs(err);
% 
% assert(size(err,1) == pp);
% assert(size(err,2) == num_constraints);
%  
% error_normalized = normalisation(err,true);
% 
% assert(size(error_normalized,1) == pp);
% assert(size(error_normalized,2) == 1);

%% if no constraints, 
error_normalized = zeros(pp,1);

end