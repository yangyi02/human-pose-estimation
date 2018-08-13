function tree = parent2tree(parent)

numparts = length(parent);
tree = zeros(numparts, numparts);
for p = 2:numparts
  tree(p, parent(p)) = 1;
  tree(parent(p), p) = 1;
end