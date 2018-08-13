function top = nms(boxes,overlap)
% Non-maximum suppression.
% Greedily select high-scoring detections and skip detections
% that are significantly covered by a previously selected detection.

if nargin < 2
  overlap = 0.3;
end

top = [];
if isempty(boxes)
  return;
end

% Throw away boxes if the number of candidates are too many
if size(boxes,1) > 10000
  [~, I] = sort(boxes(:,end), 'descend');
  boxes = boxes(I(1:10000),:);
end

% Collect bounding boxes and scores 
numpart = floor(size(boxes,2)/5);
idx = 5*((1:numpart) - 1);
x1 = boxes(:,idx+1);
y1 = boxes(:,idx+2);
x2 = boxes(:,idx+3);
y2 = boxes(:,idx+4);
area = (x2 - x1 + 1) .* (y2 - y1 + 1);

[~, I] = sort(boxes(:,end), 'descend');
pick = [];
while ~isempty(I)
  i = I(1);
  pick = [pick; i];

  xx1 = bsxfun(@max,x1(i,:), x1(I,:));
  yy1 = bsxfun(@max,y1(i,:), y1(I,:));
  xx2 = bsxfun(@min,x2(i,:), x2(I,:));
  yy2 = bsxfun(@min,y2(i,:), y2(I,:));

  w = xx2-xx1+1; w(w<0) = 0;
  h = yy2-yy1+1; h(h<0) = 0;    
  inter  = w.*h;

  o = inter ./ area(I,:);
  o = max(o,[],2);
  I(o > overlap) = [];
end

top = boxes(pick,:);