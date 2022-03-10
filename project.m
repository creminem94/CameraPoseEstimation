%% get reference data (K, R, T, p2D, p3D) and save best points descriptors 
clear all
close all

addpath 'dante' 'cav' 'functions';
run('functions\sift\toolbox\vl_setup');
% run('C:\Program Files\MATLAB\R2020b\toolbox\sift\toolbox\vl_setup');

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
    img = imread('Zephyr_Dante_Statue_Dataset/_SAM1013.JPG');
    p2D = VisPoints(:,2:3);
    p3D = Xvis;
end
nPoint = length(p3D);

%RANSAC
[model, inliers, outliers, inliersIdx] = ransacPose(p3D,100,0.8,floor(nPoint*0.95));
figure()
scatter3(inliers(:,1),inliers(:,2),inliers(:,3),5,'r');
hold on;
scatter3(outliers(:,1),outliers(:,2),outliers(:,3),5,'g');
% axis equal
p3D = inliers;
p2D = p2D(inliersIdx,:);

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

figure()
scatter3(p3D(:,1),p3D(:,2),p3D(:,3),5,'r');
axis equal
%% match with a new image
if strcmp(env,'cav')
    load('refDescriptorsCav.mat')
    checkImg =  imread('cav/cav_new.jpg');
    refImg = imread('cav/cav.jpg');
else
    load('refDescriptorsDante.mat')
    checkImg = imread('test.jpg');
%     checkImg = imrotate(checkImg, 90);
    refImg =  imread('Zephyr_Dante_Statue_Dataset/_SAM1013.JPG');
end

f = [refDescriptors.f];
d = [refDescriptors.d];
p2D_ref = [refDescriptors.p2D];
p2D_ref = reshape(p2D_ref, 2, [])';
p3D_ref = [refDescriptors.p3D];
p3D_ref = reshape(p3D_ref, 3, [])';

[fc, dc] = vl_sift(single(rgb2gray(checkImg)));
[matches, scores] = vl_ubcmatch(d, dc);

[drop, perm] = sort(scores, 'ascend');

toPlot = size(perm,2);
matches = matches(:, perm(1:toPlot));
scores = scores(perm(1:toPlot));

x_ref = f(1,matches(1,:));
x_check = fc(1,matches(2,:))+size(refImg,2);
y_ref = f(2,matches(1,:));
y_check = fc(2,matches(2,:));
p2D_refMatch = [x_ref', y_ref'];
p2D_check = fc(1:2,matches(2,:))';
p3D_check = p3D_ref(matches(1,:),:);
%%
padSize = size(refImg)-size(checkImg);
checkImg = padarray(checkImg, padSize(1:2), 'post');
figure();
imagesc(cat(2, refImg, checkImg));
axis image off;
hold on;
vl_plotframe(f(:,matches(1,:)));
fc(1,:) = fc(1,:)+size(checkImg,2);
vl_plotframe(fc(:,matches(2,:)));
axis image off;

h = line([x_ref;x_check],[y_ref;y_check]);


% 
% hold on;
% h1 = vl_plotframe(f(:,sel)) ;
% h2 = vl_plotframe(f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;



%% compute exterior
newK = getInternals('test.jpg');
modelPoints = 1:length(x_check);
% Exterior orientation
% Estraggo un sottoinsieme tra tutte le corrispondenze
G = compute_exterior(newK,[R T], p2D_check(modelPoints,:)',p3D_check(modelPoints,:)', MethodName.Fiore);
% Riproietto i punti 3D usando la nuova matrice degli esterni:
plotOnImage(checkImg,p2D_check(modelPoints,:), p3D_check(modelPoints,:), newK, G);
title('check img');

G_ref = compute_exterior(K,[eye(3) zeros(3,1)], p2D_refMatch(modelPoints,:)',p3D_check(modelPoints,:)', MethodName.Fiore);
plotOnImage(refImg,p2D_refMatch(modelPoints,:), p3D_check(modelPoints,:), K, G_ref);
title('ref img');


figure()
scatter3(p3D_check(:,1),p3D_check(:,2),p3D_check(:,3),5,'r');
axis equal

%% NUOVA CAMERA CON PICKING 3D