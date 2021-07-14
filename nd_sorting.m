function [sorted_population, sorted_Z_front , front_ranks , crowding_distance] = nd_sorting(X,Z,error_normalized,NumO)

global problem_type 

% Reference: Kalyanmoy Deb, Associate Member, IEEE, Amrit Pratap, Sameer Agarwal, and T. Meyarivan "A Fast and Elitist Multiobjective Genetic Algorithm: NSGA-II"

% Here, F represents front. k is number of the front.
% It is again a structure with attribute e = array of indexes of the elements of the current front
% here element is a structure with 2 attributes
% n = number of elements which dominate current element
% d = the array of ( indexes of ) elements dominated by current element       
clear F;
k = 1;                  % kth front or 1st front 
F{k} = [];
totalFronts = 0; 
pp = size(X,1);

%% Segregating feasible and infeasible solutions
if all(error_normalized(:,1)==0)
    problem_type=0;                         % All Feasible population;    
    X_feasible = X;
    Z_feasible = Z;
    pp1 = pp;
    pp2 = 0;
    
elseif all(error_normalized(:,1)~=0)
    problem_type=1;
    X_inf = X;                               % All InFeasible population;       
    Z_inf = Z;
    err_inf = error_normalized;
    pp2 = pp;
    pp1 = 0;
    sorted_population = [];
    sorted_Z_front = [];
    front_ranks = [];
    crowding_distance = [];
    
else
    problem_type=0.5;
    feasible_id=find(error_normalized(:,1)==0);
    X_feasible= X(feasible_id,:); 
    Z_feasible= Z(feasible_id,:);                             % Feasible population;    
    pp1 = size(X_feasible,1); 
    
    inf_id = find(error_normalized(:,1) ~=0);
    X_inf = X(inf_id,:);                                     % infeasible population;    
    Z_inf = Z(inf_id,:);
    err_inf = error_normalized(inf_id,:);
    pp2 = size(X_inf,1);
    
    assert( pp1 + pp2 == pp );
    
end

%% Handling feasible solutions 
if problem_type==0 || problem_type==0.5
    rank = zeros(pp1,1);
    element.n = 0;
    element.d = [];
    element = repmat(element,pp1,1);
    %% Non-Dominated Sorting in Feasible Solutions: Sorting by Fronts
    for i = 1 : pp1
        element(i).n = 0;
        element(i).d = [];
        for j = 1 : pp1
            less_dominated = 0;         % j < i
            equal_dominated = 0;        % j = i
            more_dominated = 0;         % j > i
            for r = 1 : NumO
                if (Z_feasible(i,r) < Z_feasible(j,r))
                    less_dominated = less_dominated + 1;    
                elseif (Z_feasible(i,r) == Z_feasible(j,r))
                    equal_dominated = equal_dominated + 1;
                else
                    more_dominated = more_dominated + 1;
                end
            end
            if less_dominated == 0 && equal_dominated ~= NumO    % NumO = number of obejective function
                % j dominates i
                element(i).n = element(i).n + 1;                 
            elseif more_dominated == 0 && equal_dominated ~= NumO     % NumO = number of obejective function
                % i dominates j
                element(i).d = [element(i).d j];
            end
        end 
        if element(i).n == 0
            rank(i) = 1;
            F{k} = [F{k} i];           % k = 1 initially. So first front is being updated.
        end
    end


    while ~isempty(F{k})            % last front must be empty. There will be 1 extra null front which must be removed.
       Q = [];
       for i = F{k}
           p=element(i);
            for j=p.d
                q=element(j);
                q.n = q.n-1;
                if q.n==0
                    Q=[Q j];
                    rank(j)=k+1;
                end
                element(j)=q;
            end
       end
       k =  k + 1;
       F{k} = Q;
    end

    assert( isempty(Q) ,'Q is not null');
    assert( isempty(F{end}),'The last front is not null');

    F = F(1:end-1);                             % removing the last empty front
    totalFronts = k - 1;                        % total number of front reduced by 1

    assert(totalFronts == numel(F));
    assert(totalFronts == max(rank));

    [front_ranks,idx] = sort(rank);
    sorted_Z_front = Z_feasible(idx,:);
    sorted_population = X_feasible(idx,:);


    %% Crowding Distance Calculation
    current_idx = 0;
    crowding_distance = zeros(pp1,1);

    for k = 1 : totalFronts
        n = numel(F{k});
        dist = zeros(n,NumO);
        z = zeros(n,NumO);
        prev_idx = current_idx + 1;
        for i = 1 : n
            z(i,:) = sorted_Z_front(current_idx + i,:);
        end
        current_idx = current_idx + i;

        for i = 1 : NumO				% NumO = number of obejective function
            [sorted_Z_objective , indexes] = sort(z(:,i));
            f_max = sorted_Z_objective(length(indexes),1);		% the largest objective value
            f_min = sorted_Z_objective(1,1);					% the smallest obejective value

            dist(indexes(length(indexes)),i) = Inf;		% element at one end of PF 
            dist(indexes(1),i) = Inf;					% element at other end of PF
            for j = 2 : length(indexes) - 1
               next_obj  = sorted_Z_objective(min(j+2,length(indexes)-1),1);
               previous_obj  = sorted_Z_objective(max(j-2,2),1);
               if (f_max - f_min == 0)
                   dist(indexes(j),i) = Inf;
               else
                   dist(indexes(j),i) = (next_obj - previous_obj)/(f_max - f_min);
               end
            end
        end

        dist = sum(dist,2);
        crowding_distance(prev_idx:current_idx,:) = dist;
    end

end

%% Handling infeasible solutions
if problem_type==1 || problem_type==0.5
    [ ~ , id ]= sort(err_inf);
    X_inf = X_inf(id,:);                                     % infeasible population;    
    Z_inf = Z_inf(id,:);
    
    ranks_inf = (totalFronts+1:totalFronts+pp2)';
    distance_inf = Inf*(ones(pp2,1));
    
    for kk = totalFronts+1:totalFronts+pp2
        F{kk}= pp1+1;
    end
    
    sorted_population = [ sorted_population ; X_inf ];
    sorted_Z_front = [ sorted_Z_front ; Z_inf];
    front_ranks = [ front_ranks ; ranks_inf ];
    crowding_distance = [ crowding_distance ; distance_inf ];
end


end

