for i = 1:100
    E(i,:) = Xarchive(i,:) * B * Xarchive(i,:)' ;
end
E = E + Pd - sum(Xarchive,2);
