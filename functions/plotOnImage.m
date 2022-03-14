function plotOnImage(img,p2D, p3D, K, G, index)
figure;
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.','MarkerSize', 10);
P1=K*G;
[u1,v1] = proj(P1,p3D);
plot(u1,v1,'bo');
if nargin == 6
    text(p2D(:,1), p2D(:,2),num2str(index'))
end
end

