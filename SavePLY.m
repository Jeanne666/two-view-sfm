% This code is for saving the reconstructed 3D points into PLY file.
% You can open PLY files using 3D viewer like 'MeshLab'.

function SavePLY(filename, X)
    out=fopen(filename,'w');
    fprintf(out,'ply\n');
    fprintf(out,'format ascii 1.0\n');
    fprintf(out,'element vertex %d\n',size(X,1));
    fprintf(out,'property float x\n');
    fprintf(out,'property float y\n');
    fprintf(out,'property float z\n');
    fprintf(out,'property uchar red\n');
    fprintf(out,'property uchar green\n');
    fprintf(out,'property uchar blue\n');
    fprintf(out,'end_header\n');
    for i=1:size(X,1)
        fprintf(out,'%f %f %f %d %d %d\n',[X(i,1),X(i,2),X(i,3),min(round(X(i,4)),255),min(round(X(i,5)),255),min(round(X(i,6)),255)]);
    end
    fclose(out);
end