function [pos, test] = PARSE_data(name)
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
% This function also prepares flipped images and slightly rotated images
% for training.

globals;
  
fprintf('Collet positive training and testing data from %s.\n', name);

cls = [name '_data'];
try
	load([cachedir cls]);
catch
  load data/PARSE/labels.mat;
  
  trainfrs = 1:100; % training frames for positive
  testfrs = 101:305; % testing frames for positive

  % -------------------
  % Grab positive annotation and image information
  posims = 'data/PARSE/im%.4d.jpg';
  pos = [];
  numpos = 0;
  for fr = trainfrs
    numpos = numpos + 1;
    pos(numpos).im = sprintf(posims,fr);
    pos(numpos).point = ptsAll(:,:,fr);
  end

  % -------------------
  % Rotate positive images by a small amount of degree
  degree = [-15 -7.5 7.5 15];
  posims_rotate = [cachedir 'imrotate/im%.4d_%d.jpg'];
  for n = 1:length(pos)
    im = imread(pos(n).im);
    for i = 1:length(degree)
      if exist(sprintf(posims_rotate,trainfrs(n),i),'file'), continue, end
      imwrite(imrotate(im,degree(i)),sprintf(posims_rotate,trainfrs(n),i));
    end
  end

  for n = 1:length(pos)
    im = imread(pos(n).im);
    for i = 1:length(degree)
      numpos = numpos + 1;
      pos(numpos).im = sprintf(posims_rotate,trainfrs(n),i);
      pos(numpos).point = map_rotate_points(pos(n).point,im,degree(i),'ori2new');
    end
  end

  % -------------------
  % Flip positive training images
  posims_flip = [cachedir 'imflip/im%.4d.jpg'];
  for n = 1:length(pos)
    if exist(sprintf(posims_flip,n),'file'), continue, end
    im = imread(pos(n).im);
    imwrite(im(:,end:-1:1,:),sprintf(posims_flip,n));
  end

  % -------------------
  % Flip labels for the flipped positive training images
  % Please check the mirror property of keypoints for your dataset
  mirror = [6 5 4 3 2 1 12 11 10 9 8 7 13 14];
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
  testims = 'data/PARSE/im%.4d.jpg';
  test = [];
  numtest = 0;
  for fr = testfrs
    numtest = numtest + 1;
    test(numtest).im = sprintf(testims,fr);
    test(numtest).obj.point = ptsAll(:,:,fr);
  end
  
  save([cachedir cls],'pos','test');
end

% -------------------
% Create ground truth keypoints for model training
% We augment the original 14 joint positions with midpoints of joints, 
% defining a total of 26 keypoints
I = [1  2  3  4   4   5  6   6   7  8   8   9   9   10 11  11  12 13  13  14 ...
           15 16  16  17 18  18  19 20  20  21  21  22 23  23  24 25  25  26];
J = [14 13 9  9   8   8  8   7   7  9   3   9   3   3  3   2   2  2   1   1 ...
           10 10  11  11 11  12  12 10  4   10  4   4  4   5   5  5   6   6];
A = [1  1  1  1/2 1/2 1  1/2 1/2 1  2/3 1/3 1/3 2/3 1  1/2 1/2 1  1/2 1/2 1 ...
           1  1/2 1/2 1  1/2 1/2 1  2/3 1/3 1/3 2/3 1  1/2 1/2 1  1/2 1/2 1];
Trans = full(sparse(I,J,A,26,14));

for n = 1:length(pos)
  pos(n).point = Trans * pos(n).point; % linear combination
end
