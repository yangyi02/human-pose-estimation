function [parent tree] = minspantree(pos)

numparts = size(pos(1).point, 1);

dist = zeros(numparts, numparts, numel(pos));
for n = 1:numel(pos)
  dist(:,:,n) = squareform(pdist(pos(n).point) ./ pos(n).scale);
end

W = quantile(dist, 0.95, 3);

[tree, ~] = UndirectedMaximumSpanningTree(-W);
parent = tree2parent(tree);