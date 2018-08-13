function showclusterdeformations(name, location, idx, parent, suffix)

globals;

% clusterdir = [visualdir name '_clusters_' suffix '/'];
% if ~exist(clusterdir,'dir')
%   mkdir(clusterdir);
% end

% Plot the clustering result w.r.t. 2D geometric feature.
tree = parent2tree(parent);
numparts = length(parent);
for p = 1:numparts
  figure(1); clf; cnt = 0;
  for q = 1:numparts
    if tree(p,q) == 0, continue, end;
    cnt = cnt + 1;
    subplot(1, sum(tree(p,:)), cnt);
    VOCmap = VOClabelcolormap(max(idx(:,p))+1);
    colormap(VOCmap); set(gca,'clim',[0 max(idx(:,p))+1]); set(gca,'color','black');
    axis equal; hold on;
    plot(0, 0, '+', 'markerfacecolor', 'w', 'markeredgecolor', 'w', 'markersize', 10);
    for m = 1:max(idx(:,p))
      X = location(idx(:,p)==m, :, q) - location(idx(:,p)==m, :, p);
      plot(X(:,1), -X(:,2), '.', 'color', VOCmap(m+1,:));
      plot(mean(X(:,1)), -mean(X(:,2)), 'o', 'markerfacecolor', VOCmap(m+1,:), 'markeredgecolor', 'w', 'markersize', 10);
    end
  end
  drawnow;
  fprintf('Press any key to continue.\n');
  pause;
%   saveas(gcf, sprintf([clusterdir 'clusters_part%d.jpg'],p));
end