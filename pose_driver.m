% Umberto Castellani, Computer Vision 
% Analyse Zephyr outputs:
%
% Read cloud of points, and project points to 2D images (using information
% on visibility)
%
directory_ref = '.\dante\';
directory = '.\Zephyr_Dante_Statue_Dataset\';
%Read and show sparse point clouds: (there are many noisy points, it is good to subsample the cloud) 
[Points] = plyread([directory_ref 'SamPointCloud.ply']);
X=[Points.vertex.x Points.vertex.y Points.vertex.z];
% figure(1)
% plot3(X(1:10:end, 1),X(1:10:end, 2), X(1:10:end,3), 'r.');
% axis equal;
% grid on;

%Read and show mesh
%  figure(3)
%  [Tri,Pts] = plyread([directory 'Mesh.ply'],'tri');
%  trisurf(Tri,Pts(:,1),Pts(:,2),Pts(:,3)); 
%  colormap(gray); axis equal;
%  hold on
%  plot3(X(1:10:end, 1),X(1:10:end, 2), X(1:10:end,3), 'r.');
 

 fid=fopen([directory_ref 'VisibilityRef.txt'], 'r');
% fid=fopen([directory_ref 'VisibilityRef1013.txt'], 'r');
% 
% line_ex = fgetl(fid);
% disp(line_ex);

% nviews= str2num(fgetl(fid));

% disp('num cameras: '); disp(['num cameras: ' num2str(nviews)])

%Load all images and cameras
% for n=1:nviews
    string=fgetl(fid);
    name_view=string(end-11:end);
    % 
    npoint=str2num(fgetl(fid));
    disp(['Processing file: ' name_view ' with points ' num2str(npoint)]);
    VisPoints=zeros(npoint,3);
    for p=1:npoint
        VisPoints (p,:)=str2num(fgetl(fid));
        %In matlab array starts from 1:
        VisPoints(p, 1)= VisPoints(p, 1)+1;
    end
    % Read visible points
    
    Xvis=X(VisPoints(:,1),:);
%     figure(1)
%     hold off
%     plot3(X(1:10:end, 1),X(1:10:end, 2), X(1:10:end,3), 'r.');
%     hold on
%     plot3(Xvis(:, 1),Xvis(:, 2), Xvis(:,3), 'b.');
%     axis equal;
%     grid on;
    
    %Read image:
%     I=imread([directory name_view]);
%     figure(2);
%     imshow(I);
%     hold on;
%     plot(VisPoints(:,2), VisPoints(:,3), 'ro');
    % 
    % Read camera parameters:
    name = [directory name_view(1:end-3) 'xmp'];
    [K, R, T] = read_xmp(name);
    G = [R T; 0 0 0 1];
    %Full matrix
%     ppm = K * [1 0 0 0
%             0 1 0 0
%             0 0 1 0] * G;
%     %Project points to image
%     [uv, vv] = proj(ppm,Xvis);
%     plot(uv, vv, 'g.');
    
% end






