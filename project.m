if strcmp(env,'cav')
    load('refDescriptorsCav.mat')
    checkImg =  imread('cav/cav_new.jpg');
    refImg = imread('cav/cav.jpg');
else
    load('refDescriptorsDante.mat')
    checkImg = imread('Zephyr_Dante_Statue_Dataset/_SAM1096.JPG');
    refImg =  imread('Zephyr_Dante_Statue_Dataset/_SAM1097.JPG');
end

f = [refDescriptors.f];
d = [refDescriptors.d];
p3D_ref = [refDescriptors.p3D];
p3D_ref = reshape(p3D_ref, [],3);

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


padSize = size(refImg)-size(checkImg);
checkImg = padarray(checkImg, padSize(1:2), 'post');

figure(1);
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

p3D_check = p3D_ref(matches(1,:),:);
p2D_check = fc(1:2,matches(2,:))';



% Exterior orientation
% Estraggo un sottoinsieme tra tutte le corrispondenze
G = compute_exterior(K,p2D_check(1:100,:)',p3D_check(1:100,:)', MethodName.Fiore);
% 
% Riproietto i punti 3D usando la nuova matrice degli esterni:
plotOnImage(checkImg,p2D_check, p3D_check, K, G)

