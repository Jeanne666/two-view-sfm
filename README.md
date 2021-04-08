# Two-view Structure from Motion 

## How to run :
1. For this program to run smoothly, please make sure that your Matlab version has the Computer Vision Toolbox.  
2. The `result` folder contains the final object. 
The ply model is displayed at the end of the program, but you can also view it in any 3D software like Blender or Meshlab. 
For the comfort of the user it is recommended to change the background color from black to a lighter color like green.
3.  To start the program, run the file `main.m`.
4. While running, figures will appear, of the images' key and matched features. When the program is finished, the 

## The main steps of the program :
1. Decipher the intrinsic matrix text file.
2. Extract and match key features of the two images.
3. Estimate then decompose the essential matrix.
5. Triangulate the matched points into a 3D model.
6. Creation of the final PLY model.

## How to make your own model :
1. Take two pictures of the same object from similar but different views. The horizontal orientation is recommended.
2. Calibrate your camera with the Matlab Toolbox and write the resulting intrinsic matrix into a file named `intrinsic.txt`, which you must place in the same folder as the two images.
3. Put them into the same folder, then modify `main.m` to point to the images. 
Add a line of code like so : `Structure_from_Motion(image1Path, image2Path)`, with image1Path and image2Path being the paths of the two images you want to stitch together. 
