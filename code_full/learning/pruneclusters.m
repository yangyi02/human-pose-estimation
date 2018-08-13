function idx = pruneclusters(idx)

% Prune tiny clusters (which only have 1 or 2 data)
fprintf('Pruning tiny clusters which only have 1 or 2 data\n');

for p = 1:size(idx, 2)
  num_mixture = max(idx(:, p));
  fprintf('Pruning part %d from %d mixtures to ', p, num_mixture);
  cnt = 0;
  for m = 1:num_mixture
    num_idx = sum(idx(:, p) == m);
    if num_idx < 3
      idx(idx(:,p) == m, p) = 0;
    else
      cnt = cnt + 1;
      idx(idx(:,p) == m, p) = cnt;
    end
  end
  fprintf(' %d mixtures\n', cnt);
end