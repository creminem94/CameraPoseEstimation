clear all
close all

addpath 'dante' 'cav' 'functions';
%run('functions\sift\toolbox\vl_setup');
run('C:\Program Files\MATLAB\R2020b\toolbox\sift\toolbox\vl_setup');

env = 'dante'; %dante or cav

% Load reference camera info
if strcmp(env,'cav')
    load('cav/imgInfo.mat')
    img = imread('cav/cav.jpg');
    p2D = imgInfo.punti2DImg;
    p3D = imgInfo.punti3DImg;
    K = imgInfo.K;
    R = imgInfo.R;
    T = imgInfo.T;
else
    pose_driver;
    img = imread('Zephyr_Dante_Statue_Dataset/_SAM1097.JPG');
    p2D = VisPoints(:,2:3);
    p3D = Xvis;
end





[f, d] = vl_sift(single(rgb2gray(img))) ;
[sel, dist] = dsearchn(f(1:2,:)',p2D);
threshold = 4; 
valid = dist < threshold;
sel = sel(valid);

refDescriptors = getRefDescriptors(p2D, p3D, f(:,sel), d(:,sel));
if strcmp(env,'cav')
    save('refDescriptorsCav.mat', 'refDescriptors');
else
    save('refDescriptorsDante.mat', 'refDescriptors');
end