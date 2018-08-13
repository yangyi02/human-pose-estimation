function location = data_location(pos, model)
% Get absolute image positions of parts under the cononical scale and 
% w.r.t. to HOG cell.

% Put joint positions under the HOG cell coordinates.
width  = zeros(numel(pos), 1);
height = zeros(numel(pos), 1);
points = zeros(size(pos(1).point,1), size(pos(1).point,2), numel(pos));
for n = 1:numel(pos)
  width(n)  = pos(n).x2(1) - pos(n).x1(1) + 1;
  height(n) = pos(n).y2(1) - pos(n).y1(1) + 1;
  points(:,:,n) = pos(n).point;
end
scale = sqrt(width .* height) / sqrt(model.maxsize(1) * model.maxsize(2));

% Put joint positions under the cononical human scale.
% This will make the geometric features comparable.
location = zeros(numel(pos), 2, size(points, 1));
for p = 1:size(points, 1)
  location(:,1,p) = squeeze(points(p, 1, :)) ./ scale;
  location(:,2,p) = squeeze(points(p, 2, :)) ./ scale;
end
