function [location idx] = initmixtures(name, pos, PARA)

globals;

% Clustering part images into different mixtures before training.
% Each cluster may correspond to a particular in-plane orientation, or 
% out-of-plane orientation, or foreshortening, or clothing etc. 
% You may also give the part cluster id (type id) in ground truth.
model = initmodel(pos, PARA.sbin);  % Initialize model parameters

suffix = 'init';
filename = [name '_clusters_' suffix];
try
  load([cachedir filename]);
catch
  location = data_location(pos, model);  % Get deformation data w.r.t. HOG cells
  idx = clusterparts(location, PARA);  % Clustering parts
  idx = pruneclusters(idx);  % Pruning too small clusters
  save([cachedir filename], 'location', 'idx');
end

% Plot the clustering images. You can have a sense of how well the
% clusters are by looking at the images in each cluster sub directory.
% You can uncomment below lines during yo visualize clustering results.

% showclusterdeformations(name, location, idx, PARA.parent, suffix);
% showclusterpatches(name, pos, idx, model, suffix);