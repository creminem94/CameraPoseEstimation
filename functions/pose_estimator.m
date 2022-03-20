function [R, T] = pose_estimator(model,checkImageFile, method, testK)
checkImg =  imread(checkImageFile);

% sift match descriptors
[fc, dc] = vl_sift(single(rgb2gray(checkImg)));
[matches, scores] = vl_ubcmatch(model.d, dc);

[drop, perm] = sort(scores, 'ascend');

toPlot = size(perm,2);
matches = matches(:, perm(1:toPlot));
% scores = scores(perm(1:toPlot));

% x_ref = model.f(1,matches(1,:));
% x_check = fc(1,matches(2,:))+size(model.image,2);
% y_ref = model.f(2,matches(1,:));
% y_check = fc(2,matches(2,:));
% p2D_refMatch = [x_ref', y_ref'];
p2D_check = fc(1:2,matches(2,:))';
p3D_check = model.p3D(matches(1,:),:);

% find best model for matched points
inlier_threshold = floor(length(p2D_check)*0.5);
[inliers] = ransacPose(p2D_check, p3D_check,testK,5000,8,inlier_threshold);
if length(inliers) < 10
    error('Too few matching points to estimate the camera pose')
end

if length(inliers) < inlier_threshold
    disp('Inliers matching points less than imposed threshold: MODEL COULD BE INACCURED!')
end

modelPoints = 1:length(inliers);
p2D_best = p2D_check(inliers,:);
p3D_best = p3D_check(inliers,:);

G = compute_exterior(testK,[eye(3) zeros(3,1)], p2D_best(modelPoints,:)',p3D_best(modelPoints,:)', method);
plotOnImage(checkImg,p2D_best(modelPoints,:), p3D_best(modelPoints,:), testK, G);
title(strcat('Projection of best model points on test image with ',string(method)));

R = G(1:3,1:3);
T = G(1:3, 4);
end

