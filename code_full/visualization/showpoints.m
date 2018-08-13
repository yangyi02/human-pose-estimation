function showpoints(im, obj, partcolor)

if nargin < 3
  partcolor = VOClabelcolormap(256);
end

imagesc(im); axis image; axis off; hold on;
if ~isempty(obj)
  for i = 1:numel(obj)
    if isempty(obj(i).point), continue, end;
    for p = 1:size(obj(i).point,1)
      if iscell(partcolor)
        plot(obj(i).point(p,1), obj(i).point(p,2), 'o', ...
          'color', partcolor{p}, 'markersize', 10);
      else
        plot(obj(i).point(p,1), obj(i).point(p,2), 'o', ...
          'color', partcolor(p,:), 'markersize', 10);
      end
    end
  end
end
drawnow;