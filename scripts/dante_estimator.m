%env setup
clear all
close all
addpath 'functions';
run('functions/sift/toolbox/vl_setup');

%params
method = MethodName.Posit;
modelFile = 'models/refDescriptorsDante1013';
load(modelFile); %variable referenceModel
checkImageFile = 'dante/test.jpg';
% checkImageFile = 'Zephyr_Dante_Statue_Dataset/_SAM1097.JPG';
testK = getInternals(checkImageFile); % estimated internal params of test image

[R1, T1] = pose_estimator(referenceModel, checkImageFile, method, testK);

figure()
scatter3(referenceModel.p3D(:,1),referenceModel.p3D(:,2),referenceModel.p3D(:,3),5,'r');
hold on
plotCameraOnImage(referenceModel.R, referenceModel.T, 'ref');
plotCameraOnImage(R1, T1, '1');

axis equal