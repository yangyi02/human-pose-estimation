function visualizemodel(model, num)

if nargin < 2
  num = 4;
end

% Assuming only one component
c = model.components{1};
numparts = length(c);

% Sampling part mixtures to show
m = zeros(numparts, num);
for i = 1:num
  m(1,i) = randi(length(c(1).filterid));
  for k = 2:numparts
    pa = c(k).parent;
    I = find(c(k).defid(m(pa,i),:) > 0);
    m(k,i) = I(randi(length(I)));
  end
end


clf;
for i = 1:num
  subplot(2, num, i);
  visualizetemplate(model, m(:,i)); % Showing HOG template
  subplot(2, num, i + num);
  visualizeskeleton(model, m(:,i)); % Showing Skeleton
end