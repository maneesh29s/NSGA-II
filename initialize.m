function X = initialize(X_min, X_max, np, D)

X = repmat (X_min, np ,1) + rand(np,D).* (repmat (X_max, np ,1) - repmat (X_min, np ,1));

fprintf('population initialization done\n');

end

