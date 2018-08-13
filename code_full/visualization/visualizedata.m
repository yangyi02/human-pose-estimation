function visualizedata(data, suffix)

fprintf('Visualizing some of the %s data.\n', suffix);

idx = randperm(numel(data));
figure(1); clf;
for n = 1:9
  i = idx(n);
  im = imread(data(i).im);
  if isfield(data, 'x1') && isfield(data, 'y1') && isfield(data, 'x2') && isfield(data, 'y2')
    obj.box = [data(i).x1 data(i).y1 data(i).x2 data(i).y2]; 
    subplot(3,3,n); showboxes(im, obj);
  elseif isfield(data, 'obj')
    obj = cat(2,data(i).obj);
    subplot(3,3,n); showpoints(im, obj);
  else
    subplot(3,3,n); imagesc(im); axis image; axis off;
  end
end