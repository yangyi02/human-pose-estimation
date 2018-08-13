function parent = tree2parent(tree)

numparts = size(tree, 1);
parent = zeros(1, numparts);
parent(1) = 0;
for p = 2:numparts
  parent(p) = find(tree(p,:) == 1, 1, 'first');
end