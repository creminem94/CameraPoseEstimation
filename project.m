load('refDescriptorsCav.mat')

f = [refDescriptors.f];
d = [refDescriptors.d];
checkImg =  imread('cav/cav_new.jpg');
refImg = imread('cav/cav.jpg');
[fc, dc] = vl_sift(single(rgb2gray(checkImg)));
[matches, scores] = vl_ubcmatch(d, dc);

[drop, perm] = sort(scores, 'ascend');
matches = matches(:, perm(1:20));
scores = scores(perm(1:20));

x_ref = f(1,matches(1,:));
x_check = fc(1,matches(2,:))+size(refImg,2);
y_ref = f(2,matches(1,:));
y_check = fc(2,matches(2,:));

padSize = size(refImg)-size(checkImg);
checkImg = padarray(checkImg, padSize(1:2), 'post');

figure;
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