function [pts1,pts2]=featuresmatch(img1,img2,th, display)
%% extract the first image's key features
impts1 = detectMinEigenFeatures(rgb2gray(img1), 'MinQuality', th);

%% display the image's 500 most important points
if display ~= -1
    imshow(img1); hold on;
    plot(impts1.selectStrongest(500));
end

%% track these features in the other image
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
impts1 = impts1.Location;
initialize(tracker, impts1, img1);
[impts2, i] = step(tracker, img2);

%% select the common points on both images
pts1 = impts1(i, :);
pts2 = impts2(i, :);
end