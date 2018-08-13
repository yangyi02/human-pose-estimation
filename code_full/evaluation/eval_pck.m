function pck = eval_pck(det, gt, thresh)

if nargin < 3
  thresh = 0.1;
end

assert(numel(det) == numel(gt));

% Compute the scale of the ground truths
for n = 1:numel(gt)
  for i = 1:numel(gt(n).obj)
    box = [min(gt(n).obj(i).point, [], 1) max(gt(n).obj(i).point, [], 1)];
    gt(n).obj(i).scale = max(box(3) - box(1) + 1, box(4) - box(2) + 1);
  end
end

% Count total number of ground truths
numgt = 0;
for n = 1:numel(gt)
  numgt = numgt + numel(gt(n).obj);
end

% Count the number of parts
numpart = size(gt(1).obj(1).point, 1);

tp = zeros(numpart, numgt);
cnt = 0;
for n = 1:numel(gt)
  for i = 1:numel(gt(n).obj)
    cnt = cnt + 1;
    if isempty(det(n).obj(i).point), continue, end;
    dist = sqrt(sum((det(n).obj(i).point - gt(n).obj(i).point).^2, 2));
    tp(:,cnt) = dist <= thresh * gt(n).obj(i).scale;
  end
end

pck = mean(tp,2)';