function x3D = triangulate(pts1,pts2,P1,P2)
%% get the matched points and the positions of the cameras
x2D(:,:,1)=pts1;
x2D(:,:,2)=pts2;
P(:,:,1)=P1;
P(:,:,2)=P2;
n = size(x2D, 1);

%% initialize the final 3D matrix
x3D = zeros(n, 3, 'like', x2D);

%% triangulate
for i = 1:n
    pairs=squeeze(x2D(i, :, :))';
    A = zeros(4, 4);
    for j = 1:2
        Pj = P(:,:,j)';
        A(2*j-1,:)=pairs(j, 1)*Pj(3,:)-Pj(1,:);
        A(2*j,:)=pairs(j, 2)*Pj(3,:)-Pj(2,:);
    end
    [~,~,V] = svd(A);
    X = V(:, end);
    X = X/X(end);
    x3D(i, :) = X(1:3)';
end
