function obj = box2obj(boxes)
% Decode matrix format of bounding boxes to structure array format
    
N = size(boxes,1);
obj = struct('box', cell(1,N), 'point', cell(1,N), ...
  'mixture', cell(1,N), 'score', cell(1,N));
for n = 1:N
  box = boxes(n,:);
  numparts = floor(size(box,2)/5);
  obj(n).score = box(end);
  box = reshape(box(1:end-2), 5, numparts);
  obj(n).box = box(1:4,:)';
  obj(n).point = [(obj(n).box(:,1) + obj(n).box(:,3))/2 ...
    (obj(n).box(:,2) + obj(n).box(:,4))/2];
  obj(n).mixture = box(5,:);
end