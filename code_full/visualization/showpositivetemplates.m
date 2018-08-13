function showpositivetemplates(name, model, suffix)

globals;

clusterdir = [visualdir name '_clusters_' suffix '/'];
if ~exist(clusterdir,'dir')
  mkdir(clusterdir);
end

for p = 1:length(model.parent)
  figure(1); clf;
  nm = length(model.components{1}(p).filterid);
  for m = 1:nm
    subplot(ceil(nm/ceil(sqrt(nm))), ceil(sqrt(nm)), m); 
    visualizePHOG(model.filters(model.components{1}(p).filterid(m)).w);
  end
  saveas(gcf, [clusterdir 'part' num2str(p) '.jpg']);
end