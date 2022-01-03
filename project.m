clear all;
ptCloud = pcread('Dante_cloudPoints.ply');
% pcshow(ptCloud);
p3d = ptCloud.Location;
internals = importdata('internals.txt');
filenames = {internals.textdata{3:end}};
image = imread('Zephyr_Dante_Statue_Dataset/_SAM1001.JPG');