function idx = clusterparts(location, PARA)
% This function implements the simple K-means clustering method based on 
% the 2D relative geometric features for every part.

% As K-means may fall into a local optimal solution, we try multiple times 
% to get (hopefully) the global optimal.
R = 100;  % Number of replications of K-means.

tree = parent2tree(PARA.parent);

numdata = size(location, 1);  % Number of data
numparts = size(location, 3);  % Number of parts

idx = zeros(numdata, numparts); % Clustering labels for all parts.
for p = 1:numparts
  fprintf('Clustering part %d.\n', p);
  % Create clustering features
  X = [];
  for q = 1:numparts
    if tree(p,q) == 0, continue, end;
    X = [X location(:,:,q) - location(:,:,p)];
  end
  
  % Try multiple times K-means
  curdist = inf;
  for trial = 1:R
    [gInd, ~, sumdist] = k_means(X, PARA.K);
		if sumdist < curdist
			curdist = sumdist;
			idx(:,p) = gInd;
		end
  end
end