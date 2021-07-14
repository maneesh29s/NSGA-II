function [norm_val] = normalisation(values,is_constraints)
  
[pp,m] = size(values);    % number of constraints

cmax = max(values);          % gives max value of constraint in each constraint seperetely    
cmax = repmat(cmax,pp,1);   
cmin = min(values);          % gives min value of constraint in each constraint seperetely    
cmin = repmat(cmin,pp,1);

norm_val= (values - cmin)./ ( cmax - cmin + 0.001);   % 0.001 used to avoid divide by zero condition

if is_constraints
    norm_val= sum(norm_val,2) ./ m;
end

end