function [pts1, pts2] = siftFeatures(img1, img2)

 %% get features and descriptors
 [f1, d1] = vl_sift(rgb2gray(img1), th);
 [f2, d2] = vl_sift(rgb2gray(img2), th);

 %% get matches from vl_ubcmatch()
 matches = vl_ubcmatch(d1,d2);
 pts1 = matches(1, :);
 pts2 = matches(2, :);

end
