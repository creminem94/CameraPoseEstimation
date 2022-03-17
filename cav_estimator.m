%env setup
clear all
close all
addpath 'functions';
run('functions/sift/toolbox/vl_setup');

%params
method = MethodName.Fiore;
modelFile = 'models/refDescriptorsCav';
load(modelFile);

for i = 1:13
checkImageFile = "cav/cav_test_"+num2str(i)+".jpg";
testK = getInternals(checkImageFile); % estimated internal params of test image
[R, T, p2D_ref, p3D_ref, K_ref, T_ref, R_ref] = pose_estimator(modelFile, checkImageFile, method, testK);
if i == 1
    figure(100)
    scatter3(p3D_ref(:,1),p3D_ref(:,2),p3D_ref(:,3),5,'r');
    hold on
    plotCameraOnImage(R_ref, T_ref, 'ref');
end
figure(100)
hold on;
plotCameraOnImage(R, T, num2str(i));
axis equal
end



