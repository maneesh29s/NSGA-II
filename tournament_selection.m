function P = tournament_selection(X,ranks,crowding_distance)

P = [];
while isempty(P)
    [pp,~] = size(X);

	R=randsample(pp,2);

    parent1=R(1);
    parent2=R(2);
    
    assert(parent1 ~= parent2);

    rank1 = ranks(parent1,:);
    rank2 = ranks(parent2,:);

    if rank1 == rank2
        distance1 = crowding_distance(parent1,:);
        distance2 = crowding_distance(parent2,:);
        if distance1 == distance2
            r = randi(2);
            if r == 1
                P = X(parent1,:);			
            elseif r == 2
                P = X(parent2,:);
            end   
        elseif distance1 > distance2
            P = X(parent1,:);
        elseif distance1 < distance2
            P = X(parent2,:);
        end
    elseif rank1 < rank2
        P = X(parent1,:);
    elseif rank1 > rank2
        P = X(parent2,:);
    end
end

end

