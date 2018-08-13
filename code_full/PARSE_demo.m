clc; close all; clear;
globals;
% --------------------
% Specify model parameters
% Number of mixtures for every part
PARA.K = 6; 
% Spatial resolution of HOG cell, interms of pixel width and hieght
% The PARSE dataset contains low-res people, so we use low-res parts
PARA.sbin = 4;
% Tree structure for 26 parts: parent(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (PARSE_data.m) and evaluation (PARSE_transback)
PARA.parent = [0 1 2 3 4 5 6 3 8 9 10 11 12 13 2 15 16 17 18 15 20 21 22 23 24 25];
% --------------------
% Prepare training and testing images and part bounding boxes
% You will need to write custom *_data() functions for your own dataset
[pos, test] = PARSE_data('PARSE');
neg = INRIA_data('INRIA');
pos = point2box(pos,PARA.parent);
% --------------------
% Uncomment below lines to visualize training and testing data
% visualizedata(pos, 'positive training'); fprintf('press any key to continue\n'); pause;
% visualizedata(neg, 'negative training'); fprintf('press any key to continue\n'); pause;
% visualizedata(test, 'positive testing'); fprintf('press any key to continue\n'); pause;
% --------------------
% Training
name = ['PARSE_K' num2str(PARA.K)];
[location, idx] = initmixtures(name, pos, PARA); % Initialize mixtures
[model, traintime] = trainmodel(name, pos, location, idx, neg, PARA); % Train model
% --------------------
% Testing
model.thresh = min(model.thresh,-1);
[det, pose] = testmodel(name,model,test);
% --------------------
% Evaluation 1: average precision of keypoints (APK)
apk = eval_apk(PARSE_transback(det), test, 0.1);
% Average left with right and neck with top head
apk = (apk + apk([6 5 4 3 2 1 12 11 10 9 8 7 14 13]))/2;
% Change the order to: Head & Shoulder & Elbow & Wrist & Hip & Knee & Ankle
apk = apk([14 9 8 7 3 2 1]);
meanapk = mean(apk);
fprintf('mean APK = %.1f\n',meanapk*100);
fprintf('Keypoints & Head & Shou & Elbo & Wris & Hip  & Knee & Ankle\n');
fprintf('APK       '); fprintf('& %.1f ',apk*100); fprintf('\n');
% --------------------
% Evaluation 2: percentage of correct keypoints (PCK)
pck = eval_pck(PARSE_transback(pose), test, 0.1);
% Average left with right and neck with top head
pck = (pck + pck([6 5 4 3 2 1 12 11 10 9 8 7 14 13]))/2;
% Change the order to: Head & Shoulder & Elbow & Wrist & Hip & Knee & Ankle
pck = pck([14 9 8 7 3 2 1]);
meanpck = mean(pck);
fprintf('mean PCK = %.1f\n',meanpck*100); 
fprintf('Keypoints & Head & Shou & Elbo & Wris & Hip  & Knee & Ankle\n');
fprintf('PCK       '); fprintf('& %.1f ',pck*100); fprintf('\n');
% --------------------
% Visualization
figure(1);
visualizemodel(model);
figure(2);
demoimid = 10;
im = imread(test(demoimid).im);
colorset = {'g','g','y','r','r','r','r','y','y','y','m','m','m','m','y','b','b','b','b','y','y','y','c','c','c','c'};
% Show all detections
subplot(2,2,1); showboxes(im, det(demoimid).obj, colorset);
subplot(2,2,2); showskeletons(im, det(demoimid).obj, model.parent, colorset);
% Show best pose overlap with ground truths
subplot(2,2,3); showboxes(im, pose(demoimid).obj, colorset);
subplot(2,2,4); showskeletons(im, pose(demoimid).obj, model.parent, colorset);
