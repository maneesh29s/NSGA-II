function [X, Z , ranks , crowding_distance] = truncation(Xmerged, Zmerged , ranks_merged , crowding_distance_merged, np)

% rank/front based sorting is all already done in nd_sorting function
% max value of rank is the total number of fronts
max_rank = max(ranks_merged);

prev_idx = 0;

for i = 1 : max_rank 
    current_idx = find(ranks_merged == i , 1 , 'last');	% it gives max number of population including current front
	
    if current_idx > np
        remaining = np - prev_idx;
        distance = crowding_distance_merged(prev_idx + 1 : current_idx, :);
        [~,idx] = sort(distance,'descend');
        for j = 1 : remaining
            X(prev_idx + j , :) = Xmerged(prev_idx + idx(j) , :);
			Z(prev_idx + j , :) = Zmerged(prev_idx + idx(j) , :);
			ranks(prev_idx + j , :) = ranks_merged(prev_idx + idx(j) , :);
			crowding_distance(prev_idx + j, :) = crowding_distance_merged(prev_idx + idx(j) , :);
        end
        return;
		
    elseif current_idx < np
        X(prev_idx + 1 : current_idx, :) = Xmerged(prev_idx + 1 : current_idx, :);
		Z(prev_idx + 1 : current_idx, :) = Zmerged(prev_idx + 1 : current_idx, :);
		ranks(prev_idx + 1 : current_idx, :) = ranks_merged(prev_idx + 1 : current_idx, :);
		crowding_distance(prev_idx + 1 : current_idx, :) = crowding_distance_merged(prev_idx + 1 : current_idx, :);
    
	else % current_idx == np
        X(prev_idx + 1 : current_idx, :) = Xmerged(prev_idx + 1 : current_idx, :);
		Z(prev_idx + 1 : current_idx, :) = Zmerged(prev_idx + 1 : current_idx, :);
		ranks(prev_idx + 1 : current_idx, :) = ranks_merged(prev_idx + 1 : current_idx, :);
		crowding_distance(prev_idx + 1 : current_idx, :) = crowding_distance_merged(prev_idx + 1 : current_idx, :);
        return;
    end
    % Get the index for the last added individual.
    prev_idx = current_idx;
end


end
