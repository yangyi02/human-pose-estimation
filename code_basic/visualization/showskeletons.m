function showskeletons(im, obj, parent, partcolor)

if nargin < 4
	partcolor = VOClabelcolormap(256);
end

imagesc(im); axis image; axis off; hold on;
if ~isempty(obj)
  for i = 1:numel(obj)
    if isempty(obj(i).point), continue, end;
    for p = 2:size(obj(i).point,1)
      x1 = obj(i).point(parent(p),1);
      y1 = obj(i).point(parent(p),2);
      x2 = obj(i).point(p,1);
      y2 = obj(i).point(p,2);
      if iscell(partcolor)
        line([x1 x2],[y1 y2],'color',partcolor{p},'linewidth',4);
      else
        line([x1 x2],[y1 y2],'color',partcolor(p,:),'linewidth',4);
      end
    end
  end
end
drawnow;