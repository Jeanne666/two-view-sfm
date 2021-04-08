function [R, t] = essentialMatrix(pts1, pts2, k)

%% homography
nbPts = size(pts1, 1);
pts1h=pts1';
pts1h(3,:)=1.0;
pts2h=pts2';
pts2h(3,:)=1.0;

%% estimate the essential matrix 
th=0.01;
minD = realmax('double');

for i=1:10000
    
    %estimate the fundamental matrix with the 8 point algorithm
    sampleIndicies = randperm(nbPts, 5);
    F = eightpoint(pts1h(:, sampleIndicies), pts2h(:, sampleIndicies));
    
    %calculate the reprojection error
    pfp = (pts2h' * F)';
    pfp = pfp .* pts1h;
    d = sum(pfp, 1) .^ 2;

    %find the best inliers
    inliers = coder.nullcopy(false(1, nbPts));
    inliers(d<=th)=true;
    n=sum(inliers);
    
    %RANSAC mesurements
    dist = cast(sum(d(inliers)),'double') + th*(nbPts - n);
    if minD > dist
      minD = dist;
      inliersIdx = inliers;
    end
end

%compute F from the inliers found with the least distance (epipolar lines)
F = eightpoint(pts1h(:, inliersIdx), pts2h(:, inliersIdx));
inliers1 = pts1(inliersIdx, :);
inliers2 = pts2(inliersIdx, :);

%calculate E from F and k
E = k * F * k';

%% decompose E into R and t
[U, ~, V] = svd(E);
diag = [1 0 0;
        0 1 0;
        0 0 0];
E = U * diag * V';
[U, ~, V] = svd(E);

W=[0 -1 0;
    1 0 0;
    0 0 1];

Z = [0 1 0;
    -1 0 0;
     0 0 0];

R1 = U * W * V';
R2 = U * W' * V';

if det(R1) < 0
    R1 = -R1;
end
if det(R2) < 0
    R2 = -R2;
end

Tx = U * Z * U';
t = -[Tx(3, 2), Tx(1, 3), Tx(2, 1)];
R=R1';

%% find the right camera position (reconstruction)
negs = zeros(1, 4);
nInliers=size(inliers1, 1);
P1 = ([eye(3);[0 0 0]]*k)';
M1 = P1(1:3, 1:3);
c1 = -M1 \ P1(:,4);

%test all 4 options
for i = 1:4
    if i>2
        R=R2';
    end
    
    t=-t;
    P2 = ([R; t]*k)';
    M2 = P2(1:3, 1:3);
    c2 = -M2 \ P2(:,4);
    
    for j = 1:nInliers
        a1 = M1 \ [inliers1(j, :), 1]';
        a2 = M2 \ [inliers2(j, :), 1]';
        A = [a1, -a2];
        alpha = (A' * A) \ A' * (c2 - c1);
        p = (c1 + alpha(1) * a1 + c2 + alpha(2) * a2) / 2;
        m1(j, :) = p';
    end
    
    m2 = bsxfun(@plus, m1 * R, t);
    negs(i) = sum((m1(:,3) < 0) | (m2(:,3) < 0));
end

[~, idx] = min(negs);

%choose the right rotation and translation matrixes in accordance with the results
if idx<3
    R=R1';
end

if (idx==1 || idx ==3)
    t=-t;
end

t = -(t ./ norm(t)) * R';

end