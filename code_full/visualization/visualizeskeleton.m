function visualizeskeleton(model, mix)

% Assuming only one component
c = model.components{1};
numparts = length(c);

bs = 4;

% part filter    
point(1,:) = [bs*5/2+1,bs*5/2+1];
startpoint = zeros(numparts,2);
startpoint(1,:) = [0 0];

for k = 2:numparts
  part = c(k);
  pa = c(k).parent;

  % paste into root
  def = model.defs(part.defid(mix(pa),mix(k)));

  x1 = (def.anchor(1)-1)*bs+1 + startpoint(pa,1);
  y1 = (def.anchor(2)-1)*bs+1 + startpoint(pa,2);
  x2 = x1 + bs*5+1 -1;
  y2 = y1 + bs*5+1 -1;

  startpoint(k,1) = x1 - 1;
  startpoint(k,2) = y1 - 1;

  point(k,:) = [(x1+x2)/2,(y1+y2)/2];

  radius(k,:) = [sqrt(1/2/def.w(1)) sqrt(1/2/def.w(3))];
end

x1 = min(point(:,1));
y1 = min(point(:,2));
x2 = max(point(:,1));
y2 = max(point(:,2));

% Plot anchor points
plot(point(:,1),-point(:,2), 'b.', 'markersize', 30);
hold on;
% Draw skeletons
for k = 2:numparts
  pa = c(k).parent;
  line([point(pa,1) point(k,1)], -[point(pa,2) point(k,2)], 'linewidth', 4);
end
% Draw variance of deformations
for k = 2:numparts
  ellipse(radius(k,1), radius(k,2), 0, point(k,1), -point(k,2), 'r');
end
axis off; axis equal;
xlim([x1-10 x2+10]); ylim([-y2-10 -y1+10]);