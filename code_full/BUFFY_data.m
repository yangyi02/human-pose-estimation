function [pos, test] = BUFFY_data(name)
% This function is very dataset specific, you need to modify the code if
% you want to apply the pose algorithm on some other dataset

% It converts the various data format of different dataset into unique
% format for pose detection which contains below data structure
%   pos:
%     pos(i).im: filename for the image containing i-th trainng person
%     pos(i).point: pose keypoints for the i-th training person
%   test:
%     test(i).im: filename for i-th testing image
%			test(i).obj(n): annotation for n-th person in the i-th image
%     test(i).obj(n).point: keypoints for the n-th person in the i-th image
% This function also prepares flipped images for training.

globals;

fprintf('Collet positive training and testing data from %s.\n', name);

cls = [name '_data'];
try
	load([cachedir cls]);
catch
	posanno   = 'data/BUFFY/data/buffy_s5e%d_sticks.txt';
	posims    = 'data/BUFFY/images/buffy_s5e%d_original/%.6d.jpg';
	labelfile = 'data/BUFFY/labels/buffy_s5e%d_labels.mat';
  
  trainepi = [3 4];   % training episodes
  testepi  = [2 5 6]; % testing  episodes

  % -------------------
  % Grab positive annotation and image information
  pos = [];
  numpos = 0;
  for e = trainepi
    lf = ReadStickmenAnnotationTxt(sprintf(posanno,e));
    load(sprintf(labelfile,e));
    for n = 1:length(lf)
      numpos = numpos + 1;
      pos(numpos).im = sprintf(posims,e,lf(n).frame);
      pos(numpos).point = labels(:,:,n);
    end
  end

  % -------------------
  % Flip positive training images
  posims_flip = [cachedir 'imflip/BUFFY%.6d.jpg'];
  for n = 1:length(pos)
    if exist(sprintf(posims_flip,n),'file'), continue, end
    im = imread(pos(n).im);
    imwrite(im(:,end:-1:1,:),sprintf(posims_flip,n));
  end

  % -------------------
  % Flip labels for the flipped positive training images
  % Please check the mirror property of keypoints for your dataset
	mirror = [1 2 5 6 3 4 8 7 10 9]; % for flipping original data
  for n = 1:length(pos)
    im = imread(pos(n).im);
    width = size(im,2);
    numpos = numpos + 1;
    pos(numpos).im = sprintf(posims_flip,n);
    pos(numpos).point(mirror,1) = width - pos(n).point(:,1) + 1;
    pos(numpos).point(mirror,2) = pos(n).point(:,2);
  end
	
	% -------------------
  % Grab testing image information
  test = [];
  numtest = 0;
  for e = testepi
    lf = ReadStickmenAnnotationTxt(sprintf(posanno,e));
    load(sprintf(labelfile,e));
    for n = 1:length(lf)
      numtest = numtest + 1;
      test(numtest).epi = e;
      test(numtest).frame = lf(n).frame;
      test(numtest).im = sprintf(posims,e,lf(n).frame);
      test(numtest).obj.point = labels(:,:,n);
    end
  end

	save([cachedir cls],'pos','test');
end
  
% -------------------
% Create ground truth keypoints for model training
% We augment the original 10 joint positions with midpoints of joints, 
% defining a total of 18 keypoints
I = [1  2  3  4   4   5  6   6   7  8   8   9   9   10 ...
					 11 12  12  13 14  14  15 16  16  17  17  18];
J = [1  2  3  3   4   4  4   7   7  3   9   3   9   9 ...
					 5  5   6   6  6   8   8  5   10  5   10  10];
A = [1  1  1  1/2 1/2 1  1/2 1/2 1  2/3 1/3 1/3 2/3 1 ...
					 1  1/2 1/2 1  1/2 1/2 1  2/3 1/3 1/3 2/3 1];
Trans = full(sparse(I,J,A,18,10));

for n = 1:length(pos)
	pos(n).point = Trans * pos(n).point; % liear combination
end
