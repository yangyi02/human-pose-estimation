function [det pose] = testmodel(name, model, test, suffix)
% boxes = testmodel(name,model,test,suffix)
% Returns candidate bounding boxes after non-maximum suppression

globals;

if nargin < 4
  suffix = [];
end

try
  load([cachedir name '_detections' suffix]);
catch
  det = struct('obj', cell(1,length(test)));
  pose = struct('obj', cell(1,length(test)));

  for i = 1:length(test)
    fprintf([name ': testing: %d/%d\n'],i,length(test));
    im = imread(test(i).im);
    boxes = detect_fast(im,model,model.thresh);
    
    % Testing phase 1: pose estimation given ground truth box
    N = numel(test(i).obj);
    pose(i).obj = struct('box', cell(1,N), 'point', cell(1,N), ...
      'mixture', cell(1,N), 'score', cell(1,N));
    for n = 1:N
      box = bestoverlap(boxes, test(i).obj(n), 0.3);
      if isempty(box), continue, end;
      pose(i).obj(n) = box2obj(box);
    end
    
    % Testing phase 2: human detection + pose estimation
    boxes = nms(boxes, 0.3);
    det(i).obj = box2obj(boxes);
  end

  save([cachedir name '_detections' suffix], 'det', 'pose', 'model');
end
