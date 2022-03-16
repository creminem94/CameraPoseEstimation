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
    imageIndex = '1013';
    [K_ref, R_ref, T_ref, p2D, p3D] = dante_get_points('dante/SamPointCloud.ply', ...
        "dante/VisibilityRef"+imageIndex+".txt", ...
        "Zephyr_Dante_Statue_Dataset/_SAM"+imageIndex+".xmp");
    refImg = imread("Zephyr_Dante_Statue_Dataset/_SAM"+imageIndex+".JPG");
end
nPoint = length(p3D);


[f, d] = vl_sift(single(rgb2gray(refImg))) ;
[sel, dist] = dsearchn(f(1:2,:)',p2D);
threshold = 4; 
valid = dist < threshold;
sel = sel(valid);

[p2D_ref, p3D_ref, f_ref, d_ref] = getRefDescriptors(p2D, p3D, f(:,sel), d(:,sel));
if strcmp(env,'cav')
    fileName = 'models/refDescriptorsCav.mat';
else
    fileName = "models/refDescriptorsDante"+imageIndex+".mat";
end
save(fileName, 'p2D_ref' , 'p3D_ref', 'f_ref', 'd_ref', 'K_ref', 'R_ref', 'T_ref', 'refImg');