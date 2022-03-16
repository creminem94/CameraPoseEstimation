%env setup
clear all
close all
addpath 'functions';
run('functions/sift/toolbox/vl_setup');

%params
method = MethodName.Fiore;
modelFile = 'models/refDescriptorsCav';
load(modelFile);
checkImageFile = 'cav/cav_test_1.jpg';
testK = getInternals(checkImageFile); % estimated internal params of test image

[R1 T1, p2D_ref, p3D_ref, K_ref, T_ref, R_ref] = pose_estimator(modelFile, checkImageFile, method, testK);

checkImageFile = 'cav/cav_test_2.jpg';
testK = getInternals(checkImageFile); % estimated internal params of test image
[R2 T2] = pose_estimator(modelFile, checkImageFile, method, testK);

checkImageFile = 'cav/cav_test_3.jpg';
testK = getInternals(checkImageFile); % estimated internal params of test image
[R3 T3] = pose_estimator(modelFile, checkImageFile, method, testK);

checkImageFile = 'cav/cav_test_4.jpg';
testK = getInternals(checkImageFile); % estimated internal params of test image
[R4 T4] = pose_estimator(modelFile, checkImageFile, method, testK);

checkImageFile = 'cav/cav_test_5.jpg';
testK = getInternals(checkImageFile); % estimated internal params of test image
[R5 T5] = pose_estimator(modelFile, checkImageFile, method, testK);

figure()
scatter3(p3D_ref(:,1),p3D_ref(:,2),p3D_ref(:,3),5,'r');
hold on
plotCameraOnImage(R_ref, T_ref, 'ref');
plotCameraOnImage(R1, T1, '1');
plotCameraOnImage(R2, T2, '2');
plotCameraOnImage(R3, T3, '3');
plotCameraOnImage(R4, T4, '4');
plotCameraOnImage(R5, T5, '5');
axis equal