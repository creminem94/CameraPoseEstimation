%env setup
clear all
close all
addpath 'functions';
run('functions/sift/toolbox/vl_setup');

%params
method = MethodName.Posit;
modelFile = 'models/refDescriptorsDante1013';
checkImageFile = 'dante/test.jpg';
% checkImageFile = 'Zephyr_Dante_Statue_Dataset/_SAM1097.JPG';
testK = getInternals(checkImageFile); % estimated internal params of test image

[R1, T1, p2D_ref, p3D_ref, K_ref, T_ref, R_ref] = pose_estimator(modelFile, checkImageFile, method, testK);

figure()
scatter3(p3D_ref(:,1),p3D_ref(:,2),p3D_ref(:,3),5,'r');
hold on
plotCameraOnImage(R_ref, T_ref, 'ref');
plotCameraOnImage(R1, T1, '1');

axis equal