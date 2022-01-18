clear all
close all
clc

% Caricamento informazioni camera
load('imgInfo.mat')

% Immagine
img = imread('cav.jpg');

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

[Rposit, Tposit, objectVectors] = exterior_posit(p2D, p3D, K(1,1), K(1:2,3));


% Traslazione secondo il sistema mondo:
Tposit_w=-((Rposit*p3D(1,:)')-Tposit');


[imgInfo.R imgInfo.T Rposit Tposit' Tposit_w];

[ieul(imgInfo.R), ieul(Rposit)];

%%%%
% Riproietto i punti 3D usando la nuova matrice degli esterni:
figure(3);
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
Pposit=K*[Rposit Tposit'];
[u1,v1] = proj(Pposit,objectVectors);
plot(u1,v1,'bo');
%
%
figure(4)
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
%Proiezione con esterni sul ref mondo dei punti originali
Pword=K*[Rposit Tposit_w];
[u1,v1] = proj(Pword,p3D);
plot(u1,v1,'co');



