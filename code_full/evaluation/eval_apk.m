function [apk prec rec] = eval_apk(det, gt, thresh)
% Evaluate the average precision of keypoints.
% Input:
%   det: 
%     det(n).point: detected keypoints for the n-th image. It is a 3d matrix
%										with size num_keypoints * 2 * num_detectedpersons.
%     det(n).score: detection confidence scores for the n-th image. It is a 
%										vector with length num_persons.
%   gt:
%     gt(n).point: ground truth keypoints for the n-th image. It is a 3d matrix 
%									 with size num_keypoints * 2 * num_groundtruthpersons.
%     gt(n).scale: scales for persons in the n-th image, which is also the radius
%									 for considering a correct keypoint. It is a vector with length
%									 num_groundtruthpersons.

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

% Count the total number of ground truths 
numgt = 0;
for n = 1:numel(gt)
	numgt = numgt + numel(gt(n).obj);
end

% Count the number of parts
numpart = size(gt(1).obj(1).point, 1);

% Count the total number of detections
numdet = 0;
for n = 1:numel(det)
  numdet = numdet + numel(det(n).obj);
end

% Organize all the detections
for n = 1:numel(det)
	for i = 1:numel(det(n).obj)
    det(n).obj(i).fr = n;
	end
end

ca = [];
for n = 1:numel(det)
  if isempty(det(n).obj), continue, end;
  ca = cat(2, ca, det(n).obj);
%   det = cat(2, det.obj);
end

% Sort detection from high score to low score
[~, I] = sort(cat(1, ca.score), 'descend');
ca = ca(I);

% Compute precision recall and average precision
apk = zeros(1, numpart);
prec = cell(1, numpart);
rec = cell(1, numpart);
for p = 1:numpart
  % Store detection flag for computing true / false positives
  for n = 1:numel(gt)
    for i = 1:numel(gt(n).obj)
      gt(n).obj(i).isdet = 0;
    end
  end
  
  tp = zeros(numdet,1);
  fp = zeros(numdet,1);
  for n = 1:numdet
    fr = ca(n).fr; % Get the image number for n-th detection
    if isempty(gt(fr).obj)  % If no positive instance in the image.
      fp(n) = 1; % This detection is a false positive.
      continue;
    end
    
    % Compute distance between detected keypoint and ground truth keypoints.
    dist = zeros(1, numel(gt(fr).obj));
    for i = 1:numel(gt(fr).obj)
      dist(i) = sqrt(sum((ca(n).point(p,:) - gt(fr).obj(i).point(p,:)).^2));
      dist(i) = dist(i) ./ gt(fr).obj(i).scale;
    end
    
    [distmin imin] = min(dist);
    if gt(fr).obj(imin).isdet
      % If this ground truth is already claimed by a higher score detection
      fp(n) = 1;
    elseif distmin <= thresh
      tp(n) = 1;
      gt(fr).obj(imin).isdet = 1;
    else
      fp(n) = 1;
    end
  end

  fp = cumsum(fp);
  tp = cumsum(tp);
  rec{p} = tp ./ numgt;
  prec{p} = tp ./ (fp + tp);

  apk(p) = VOCap(rec{p}, prec{p});
end
