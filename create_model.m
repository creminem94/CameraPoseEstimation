addpath 'dante' 'cav' 'functions';
run('functions\sift\toolbox\vl_setup');

env = 'dante'; %dante or cav

% Load reference camera info
if strcmp(env,'cav')
    load('cav/imgInfo.mat')
    refImg = imread('cav/cav.jpg');
    p2D = imgInfo.punti2DImg;
    p3D = imgInfo.punti3DImg;
    K_ref = imgInfo.K;
    R_ref = imgInfo.R;
    T_ref = imgInfo.T;
else
    pose_driver;
    K_ref = K;
    R_ref = R;
    T_ref = T;
    refImg = imread('Zephyr_Dante_Statue_Dataset/_SAM1013.JPG');
    p2D = VisPoints(:,2:3);
    p3D = Xvis;
end
nPoint = length(p3D);


[f, d] = vl_sift(single(rgb2gray(refImg))) ;
[sel, dist] = dsearchn(f(1:2,:)',p2D);
threshold = 4; 
valid = dist < threshold;
sel = sel(valid);

[p2D_ref, p3D_ref, f_ref, d_ref] = getRefDescriptors(p2D, p3D, f(:,sel), d(:,sel));
if strcmp(env,'cav')
    save('refDescriptorsCav.mat', 'p2D_ref' , 'p3D_ref', 'f_ref', 'd_ref', 'K_ref', 'R_ref', 'T_ref', 'refImg');
else
    save('refDescriptorsDante.mat', 'p2D_ref' , 'p3D_ref', 'f_ref', 'd_ref', 'K_ref', 'R_ref', 'T_ref', 'refImg');
end