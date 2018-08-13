function visualizetemplate(model, mix)

% Assuming only one component
c = model.components{1};
numparts = length(c);

pad = 2;
bs = 20;
  
w = model.filters(c(1).filterid(mix(1))).w;
w = foldHOG(w);
scale = max(abs(w(:)));
p = HOGpicture(w, bs);
p = padarray(p, [pad pad], 0);
p = uint8(p*(255/scale));
% border
p(:,1:2*pad) = 128;
p(:,end-2*pad+1:end) = 128;
p(1:2*pad,:) = 128;
p(end-2*pad+1:end,:) = 128;
im = p;
startpoint = zeros(numparts,2);
startpoint(1,:) = [0 0];

for k = 2:numparts
  part = c(k);
  pa = c(k).parent;

  % part filter
  w = model.filters(part.filterid(mix(k))).w;
  w = foldHOG(w);
  scale = max(abs(w(:)));
  p = HOGpicture(w, bs);
  p = padarray(p, [pad pad], 0);
  p = uint8(p*(255/scale));    
  % border 
  p(:,1:2*pad) = 128;
  p(:,end-2*pad+1:end) = 128;
  p(1:2*pad,:) = 128;
  p(end-2*pad+1:end,:) = 128;

  % paste into root
  def = model.defs(part.defid(mix(pa),mix(k)));

  x1 = (def.anchor(1)-1)*bs+1 + startpoint(pa,1);
  y1 = (def.anchor(2)-1)*bs+1 + startpoint(pa,2);

  [H W] = size(im);
  imnew = zeros(H + max(0,1-y1), W + max(0,1-x1));
  imnew(1+max(0,1-y1):H+max(0,1-y1),1+max(0,1-x1):W+max(0,1-x1)) = im;
  im = imnew;

  startpoint = startpoint + repmat([max(0,1-x1) max(0,1-y1)],[numparts,1]);

  x1 = max(1,x1);
  y1 = max(1,y1);
  x2 = x1 + size(p,2) - 1;
  y2 = y1 + size(p,1) - 1;

  startpoint(k,1) = x1 - 1;
  startpoint(k,2) = y1 - 1;

  im(y1:y2, x1:x2) = p;
end

% plot parts   
imagesc(im); colormap gray; axis equal; axis off; drawnow;
