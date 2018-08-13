function showboxes(im, obj, partcolor)

if nargin < 3
	partcolor = VOClabelcolormap(256);
end

imagesc(im); axis image; axis off; hold on;
if ~isempty(obj)
  for i = 1:numel(obj)
    if isempty(obj(i).box), continue, end;
    x1 = obj(i).box(:,1);
    y1 = obj(i).box(:,2);
    x2 = obj(i).box(:,3);
    y2 = obj(i).box(:,4);
    for p = 1:size(obj(i).box,1)
      if iscell(partcolor)
        line([x1(p) x1(p) x2(p) x2(p) x1(p)],[y1(p) y2(p) y2(p) y1(p) y1(p)], ...
          'color', partcolor{p}, 'linewidth', 2);
      else
        line([x1(p) x1(p) x2(p) x2(p) x1(p)],[y1(p) y2(p) y2(p) y1(p) y1(p)], ...
          'color', partcolor(p,:), 'linewidth', 2);
      end
    end
  end
end
drawnow;