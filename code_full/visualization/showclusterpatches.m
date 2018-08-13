function showclusterpatches(name, pos, idx, model, suffix)
% Plot the clustering images. You can have a sense of how well the
% clusters are by looking at the images in each cluster sub directory.
    
globals;

fprintf('Preparing for visualization of clustering results.\n');
fprintf('Number of image patches shown may not equal to Number of training images\n');

% Plot the clustering montage results
% try
%   load([visualdir 'imagepatches']);
% catch
%   if length(pos) > 500
%     fprintf('Your training data size is larger than 500.\n');
%     fprintf('Sample a subset from your training data to show the patches.\n');
%     % Sample a subset from the data
%     Randi = randperm(length(pos));
%     pos = pos(Randi(1:500));
%     idx = idx(Randi(1:500),:);
%   end
  patchsize = [model.maxsize(1) * model.sbin, model.maxsize(1) * model.sbin];
  patchall = zeros(patchsize(1), patchsize(2), 3, length(pos), size(idx,2));
  for n = 1:length(pos)
    if mod(n,100) == 0, fprintf('Reading image %d/%d\n', n, length(pos)); end;
    im = imread(pos(n).im);
    if size(im, 3) == 1
      im = repmat(im,[1 1 3]);
    end
    for p = 1:size(idx,2)
      x1 = round(pos(n).x1(p));
      y1 = round(pos(n).y1(p));
      x2 = round(pos(n).x2(p));
      y2 = round(pos(n).y2(p));
      patch = subarray(im, y1, y2, x1, x2, 0);
      patch = imresize(patch, [patchsize(1) patchsize(2)]);
      patchall(:,:,:,n,p) = patch;
    end
  end
%   save([visualdir 'imagepatches'], 'patchall','idx');
% end

% clusterdir = [visualdir name '_clusters_' suffix '/'];
% if ~exist(clusterdir,'dir')
%   mkdir(clusterdir);
% end

% partclusterdir = [clusterdir 'part%d/'];
% for p = 1:size(idx,2)
%   if exist(sprintf(partclusterdir,p),'dir')
%     rmdir(sprintf(partclusterdir,p),'s');
%   end
%   mkdir(sprintf(partclusterdir,p));
% end

for p = 1:size(idx,2)
  for m = 1:max(idx(:,p))
    fprintf('Visualizing clustering results for part %d mixture %d.\n', p, m);
    figure(1); clf; montage(uint8(patchall(:,:,:,idx(:,p) == m, p))); drawnow;
    fprintf('Press any key to continue.\n');
    pause;
%     saveas(gcf,sprintf([partclusterdir 'mixture%d.jpg'], p, m));
  end
end