clear all
close all
addpath 'dante' 'cav' 'functions';

% Caricamento informazioni camera
load('cav/imgInfo.mat')

% Immagine
img = imread('cav/cav.jpg');
p2D = imgInfo.punti2DImg;
p3D = imgInfo.punti3DImg;
K = imgInfo.K;

[f, d] = vl_sift(single(rgb2gray(img))) ;
[sel, dist] = dsearchn(f(1:2,:)',p2D);
threshold = 4; 
valid = dist < threshold;
sel = sel(valid);

refDescriptors = getRefDescriptors(p2D, p3D, f(:,sel), d(:,sel));
save('refDescriptorsCav.mat', 'refDescriptors');