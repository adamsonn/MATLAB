% Read the series of images.
 for p=1:20
   filename = sprintf('brain_%03d.dcm', p);
   X(:,:,1,p) = dicomread(filename);
end