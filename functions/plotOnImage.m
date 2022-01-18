function plotOnImage(img,p2D, p3D, K, G)
figure;
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
P1=K*G;
[u1,v1] = proj(P1,p3D);
plot(u1,v1,'bo');
end

