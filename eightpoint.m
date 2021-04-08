function F = eightpoint(pts1h, pts2h)
%% normalize the points
n = size(pts1h, 2);
[pts1h, t1] = vision.internal.normalizePoints(pts1h, 2, 'double');
[pts2h, t2] = vision.internal.normalizePoints(pts2h, 2, 'double');

%% unravel
M = coder.nullcopy(zeros(n, 9, 'double'));
M(:,1)=(pts1h(1,:).*pts2h(1,:))';
M(:,2)=(pts1h(2,:).*pts2h(1,:))';
M(:,3)=pts2h(1,:)';
M(:,4)=(pts1h(1,:).*pts2h(2,:))';
M(:,5)=(pts1h(2,:).*pts2h(2,:))';
M(:,6)=pts2h(2,:)';
M(:,7)=pts1h(1,:)';
M(:,8)=pts1h(2,:)';
M(:,9)=1;

%% calculate the eigen vector and estimate F
[~, ~, VM] = svd(M, 0);
F = reshape(VM(:, end), 3, 3)';
[U, S, V] = svd(F);
S(end) = 0;
F = U * S * V';

%% denormalize F
F = t2' * F * t1;
F = F / norm(F);
if F(end) < 0
  F = -F;
end