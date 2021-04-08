function Structure_from_Motion(im1,im2)

%% paths
[path,~,~]=fileparts(im1);
output_dir='./result/';

%% instrinsic matrix
f=fopen(fullfile(path,'k.txt'));
Ktxt=textscan(f,'%f %f %f');
for i=1:3
    k(:,i)=Ktxt{i};
end
img1 = imread(im1);
img2 = imread(im2);
ms=size(img1,1);
ds=1200;

if ms>ds
    img1=imresize(img1,ds/ms);
    img2=imresize(img2,ds/ms);
    %k=k*ds/ms;
end

k=k(1:3,:)';

%k = [959.267081514917,0,0;0,959.590680682700,0;601.906665947597,452.537238945710,1];

%% extract and match the images' key features
th = 0.01;
%[pts1, pts2]=siftFeatures(img1,img2,th);
[pts1, pts2]=featuresmatch(img1,img2,th, 1);
%display the linked matched features 
figure
showMatchedFeatures(img1, img2, pts1, pts2, 'montage');

%% estimate and decompose the essential matrix
[R, t] = essentialMatrix(pts1, pts2, k);
P1 = [eye(3); [0 0 0]]*k;
P2 = [R; -t*R]*k;

%% triangulation
th2 = 0.001;
[pts1, pts2]=featuresmatch(img1,img2,th2, -1);
x = triangulate(pts1, pts2, P1, P2);

%% creation of the PLY object
cls = reshape(img1, [size(img1, 1) * size(img1, 2), 3]);
colorIdx = sub2ind([size(img1, 1), size(img1, 2)], round(pts1(:,2)),round(pts1(:, 1)));
xColor = x;
xColor(:,4:6) = cls(colorIdx, :);
SavePLY([output_dir,'2_views.ply'], xColor);

%% display of the point cloud obtained
figure
ptCloud = pcread([output_dir,'2_views.ply']);
pcshow(ptCloud, 'MarkerSize', 75);
disp(['Final 3D model available in ', output_dir,'2_views.ply']);

