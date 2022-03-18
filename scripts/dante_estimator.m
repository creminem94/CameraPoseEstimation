%env setup
clear all
close all
addpath 'functions' 'classes';
run('functions/sift/toolbox/vl_setup');

%params
method = MethodName.Fiore;
modelFile = 'models/refDescriptorsDante1020';
load(modelFile); %variable referenceModel
checkImageFile = 'dante/test_4.jpg';
% checkImageFile = 'Zephyr_Dante_Statue_Dataset/_SAM1097.JPG';
testK = getInternals(checkImageFile); % estimated internal params of test image

[R1, T1] = pose_estimator(referenceModel, checkImageFile, method, testK);

ptCloud = pcread('Mesh.ply');
figure()
pcshow(ptCloud)
set(gcf,'color','w');
set(gca,'color','w');
set(gca, 'XColor', [0.15 0.15 0.15], 'YColor', [0.15 0.15 0.15], 'ZColor', [0.15 0.15 0.15]);
hold on
plotCameraOnImage(referenceModel.R, referenceModel.T, 'ref');
plotCameraOnImage(R1, T1, '1');

axis equal