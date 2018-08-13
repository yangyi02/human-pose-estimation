function box = bestoverlap(boxes, gtobj, overlap)

box = [];
if isempty(boxes) || isempty(gtobj)
  return;
end

if nargin < 3
  overlap = 0.3;
end

x1 = min(gtobj.point(:,1));
y1 = min(gtobj.point(:,2));
x2 = max(gtobj.point(:,1));
y2 = max(gtobj.point(:,2));
area = (x2-x1+1).*(y2-y1+1);

numpart = floor(size(boxes,2)/5);
idx = 5*((1:numpart) - 1);
bx1 = min(boxes(:,idx+1), [], 2);
by1 = min(boxes(:,idx+2), [], 2);
bx2 = max(boxes(:,idx+3), [], 2);
by2 = max(boxes(:,idx+4), [], 2);
barea = (bx2 - bx1 + 1) .* (by2 - by1 + 1);

xx1 = max(x1,bx1);
yy1 = max(y1,by1);
xx2 = min(x2,bx2);
yy2 = min(y2,by2);

w = xx2-xx1+1; w(w<0) = 0;
h = yy2-yy1+1; h(h<0) = 0;
inter = w.*h;
o = inter ./ (barea + area - inter);

I = find(o > overlap);
if ~isempty(I)
  [~, ind] = max(boxes(I,end));
  box = boxes(I(ind),:);
end