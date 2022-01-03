clear all;
addpath functions;
ptCloud = pcread('Dante_cloudPoints.ply');
% pcshow(ptCloud);
p3D = ptCloud.Location;
internals = importdata('internals.txt');
filenames = {internals.textdata{3:end}};
externals = importdata('externals.txt');
imgIdx = 1;
image = imread(strcat('Zephyr_Dante_Statue_Dataset/',filenames{imgIdx}));
imgInternals = internals.data(imgIdx, :);
imgExternals = externals.data(imgIdx, :);
fx = imgInternals(1);
fy = imgInternals(2);
cx = imgInternals(3);
cy = imgInternals(4);
skew = imgInternals(5);
K = [
fx skew cx
0 fy cy
0 0 1
];

% rotTform = eul2tform(deg2rad(imgExternals(4:6)),'XYZ');
% R = rotTform(1:3,1:3);
R = eul(imgExternals(4:6));
T = imgExternals(1:3)';
P = [R T];

figure(2)
imshow(image);
hold on;
[u,v] = proj(P,p3D);
plot(u,v,'go');
