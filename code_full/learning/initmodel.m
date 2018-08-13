function model = initmodel(pos, sbin, tsize)

% Aspect ratio is kept as 1, so no need to pick mode of aspect ratios.
% Every part is a square box, the reason for choosing square box can be
% refered to our PAMI paper.
aspect = 1;
% All the part templates currently have the same size, so no need to
% compute template size for every part.
w = zeros(1, length(pos));
h = zeros(1, length(pos));
for n = 1:length(pos)
  w(n) = pos(n).x2(1) - pos(n).x1(1) + 1;
  h(n) = pos(n).y2(1) - pos(n).y1(1) + 1;
end
% Pick 5 percentile area as the smallest scale the model can search.
areas = sort(h .* w);
area = areas(floor(length(areas) * 0.05));
% Pick dimensions if not specified.
nw = sqrt(area/aspect);
nh = nw*aspect;
nf = length(features(zeros([3 3 3]), 1));

% Size of HOG features w.r.t. image pixels
if nargin < 2
  model.sbin = 8;  % Optimal pixel length for every HOG cell
else
  model.sbin = sbin;
end

% Pick part sizes w.r.t. HOG cells if not specified
if nargin < 3
  tsize = [floor(nh/model.sbin) floor(nw/model.sbin)];
  tsize(tsize > 5) = 5;  % Optimal HOG cells for every part
  tsize = [tsize nf];
end

% Bias
b.w = 0;
b.i = 1;

% Filter
f.w = zeros(tsize);
f.i = 1 + 1;

% Set up components. One component corresponds to a global mixture of the 
% human (Horizontal vs vertical, frontal view vs side view, etc.). 
% However, in our pose model, we have only one component. We let the parts 
% to change types to make up different global mixtures of the human.
c(1).biasid = 1;
c(1).defid = [];
c(1).filterid = 1;
c(1).parent = 0;
model.bias(1) = b;
model.defs = [];
model.filters(1) = f;
model.components{1} = c;

% Initialize the rest of the model structure.
model.interval = 5;
model.maxsize = tsize(1:2);
model.len = 1 + prod(tsize);