%env setup
clear all
close all
addpath 'functions';
run('functions/sift/toolbox/vl_setup');

%params
modelFile = 'models/refDescriptorsDante1013';
checkImageFile = 'dante/test.jpg';
method = MethodName.Fiore;
testK = getInternals(checkImageFile); % estimated internal params of test image

%load data and images
load(modelFile);
checkImg =  imread(checkImageFile);


% sift match descriptors

[fc, dc] = vl_sift(single(rgb2gray(checkImg)));
[matches, scores] = vl_ubcmatch(d_ref, dc);

[drop, perm] = sort(scores, 'ascend');

toPlot = size(perm,2);
matches = matches(:, perm(1:toPlot));
scores = scores(perm(1:toPlot));

x_ref = f_ref(1,matches(1,:));
x_check = fc(1,matches(2,:))+size(refImg,2);
y_ref = f_ref(2,matches(1,:));
y_check = fc(2,matches(2,:));
p2D_refMatch = [x_ref', y_ref'];
p2D_check = fc(1:2,matches(2,:))';
p3D_check = p3D_ref(matches(1,:),:);

% find best model for matched points
[inliers, outliers] = ransacPose(p2D_check, p3D_check,testK,3000,8,floor(length(p2D_check)*0.5));

modelPoints = 1:length(inliers);
p2D_best = p2D_check(inliers,:);
p3D_best = p3D_check(inliers,:);

G = compute_exterior(testK,[eye(3) zeros(3,1)], p2D_best(modelPoints,:)',p3D_best(modelPoints,:)', method)
plotOnImage(checkImg,p2D_best(modelPoints,:), p3D_best(modelPoints,:), testK, G);
title(strcat('Projection of best model points on test image with ',string(method)));
plotOnImage(checkImg,p2D_check, p3D_ref, testK, G);
title(strcat('Projection of all 3D points on test image with ',string(method)));

R = G(1:3,1:3);
T = G(1:3, 4);

figure()
scatter3(p3D_ref(:,1),p3D_ref(:,2),p3D_ref(:,3),5,'r');
% hold on;
% plotCameraOnImage(R, T)
hold on
plotCameraOnImage(R_ref, T_ref)
xlim([-100 100])
ylim([-100 100])
zlim([-100 100])