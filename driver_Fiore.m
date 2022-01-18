clear all
close all
addpath 'dante' 'cav' 'functions';

% Caricamento informazioni camera
load('cav/imgInfo.mat')

% Immagine
img = imread('cav/cav.jpg');

% Informazioni immagine
p2D = imgInfo.punti2DImg;
p3D = imgInfo.punti3DImg;
K = imgInfo.K;

% Punti 3D:
figure(1)
scatter3(p3D(:,1),p3D(:,2),p3D(:,3),5,'c');
axis equal

%
% Riproietto i punti 3D usando i dati di calibrazione:
figure(2)
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
P=K*[imgInfo.R imgInfo.T];

[u,v] = proj(P,p3D);
plot(u,v,'go');

% Punti 3D:
figure(2)
scatter3(p3D(:,1),p3D(:,2),p3D(:,3),5,'c');
axis equal

% Exterior orientation
% Estraggo un sottoinsieme tra tutte le corrispondenze
G = compute_exterior(K,p2D(1:100,:),p3D(1:100,:), MethodName.Lowe);
%
% Riproietto i punti 3D usando la nuova matrice degli esterni:
plotOnImage(img,p2D, p3D, K, G)

% Confronto tra la posa stimata con dalla calibrazione e quella
% stimata con il metodo di Fiore:
[imgInfo.R imgInfo.T G]

