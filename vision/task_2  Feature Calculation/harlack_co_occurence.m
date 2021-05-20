clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
%convert image to gray
Igray = rgb2gray(f);
[im_upperLeft, im_upperRight, im_lowerLeft, im_lowerRight] = split(Igray);
%Ignoring warnings
warning('off')

% https://uk.mathworks.com/matlabcentral/answers/24669-down-quantization-8-bit-grey-to-n-bit-grey-n-8

% Reduce the number of bits to 32
reducedImage_32 = uint8((single(Igray)/256)*2^5);
%Split image
[im32_upperLeft, im32_upperRight, im32_lowerLeft, im32_lowerRight] = split(reducedImage_32);

% Reduce the number of bits to 8
reducedImage_8 = uint8((single(Igray)/256)*2^3);
%Split image
[im8_upperLeft, im8_upperRight, im8_lowerLeft, im8_lowerRight] = split(reducedImage_8);

% Reduce the number of bits to 6
reducedImage_6 = uint8((single(Igray)/256)*2^2.58496);
%Split image
[im6_upperLeft, im6_upperRight, im6_lowerLeft, im6_lowerRight] = split(reducedImage_6);

% Reduce the number of bits to 4
reducedImage_4 = uint8((single(Igray)/256)*2^2);
%Split image
[im4_upperLeft, im4_upperRight, im4_lowerLeft, im4_lowerRight] = split(reducedImage_4);

% Reduce the number of bits to 2
reducedImage_2 = uint8((single(Igray)/256)*2^1);
%Split image
[im2_upperLeft, im2_upperRight, im2_lowerLeft, im2_lowerRight] = split(reducedImage_2);

%call functions and display relevant info
rotation = [0,45,90,135];

%call functions and display relevant info
disp('Grayscale image');
coocurancematrix(Igray, rotation)
disp('Grayscale image upper left');
coocurancematrix(im_upperLeft, rotation)
disp('Grayscale image upper right');
coocurancematrix(im_upperRight, rotation)
disp('Grayscale image lower left');
coocurancematrix(im_lowerLeft, rotation)
disp('Grayscale image lower right');
coocurancematrix(im_lowerRight, rotation)

disp('32 Bit image');
coocurancematrix(reducedImage_32, rotation)
disp('32 Bit image upper left');
coocurancematrix(im32_upperLeft, rotation)
disp('32 Bit image upper right');
coocurancematrix(im32_upperRight, rotation)
disp('32 Bit image lower left');
coocurancematrix(im32_lowerLeft, rotation)
disp('32 Bit image lower right');
coocurancematrix(im32_lowerRight, rotation)


disp('8 Bit image');
coocurancematrix(reducedImage_8, rotation)
disp('8 Bit image upper left');
coocurancematrix(im8_upperLeft, rotation)
disp('8 Bit image upper right');
coocurancematrix(im8_upperRight, rotation)
disp('8 Bit image lower left');
coocurancematrix(im8_lowerLeft, rotation)
disp('8 Bit image lower right');
coocurancematrix(im8_lowerRight, rotation)

disp('6 Bit image');
coocurancematrix(reducedImage_6, rotation)
disp('6 Bit image upper left');
coocurancematrix(im6_upperLeft, rotation)
disp('6 Bit image upper right');
coocurancematrix(im6_upperRight, rotation)
disp('6 Bit image lower left');
coocurancematrix(im6_lowerLeft, rotation)
disp('6 Bit image lower right');
coocurancematrix(im6_lowerRight, rotation)

disp('4 Bit image');
coocurancematrix(reducedImage_4, rotation)
disp('4 Bit image upper left');
coocurancematrix(im4_upperLeft, rotation)
disp('4 Bit image upper right');
coocurancematrix(im4_upperRight, rotation)
disp('4 Bit image lower left');
coocurancematrix(im4_lowerLeft, rotation)
disp('4 Bit image lower right');
coocurancematrix(im4_lowerRight, rotation)


disp('2 Bit image');
coocurancematrix(reducedImage_2, rotation)
disp('2 Bit image upper left');
coocurancematrix(im2_upperLeft, rotation)
disp('2 Bit image upper right');
coocurancematrix(im2_upperRight, rotation)
disp('2 Bit image lower left');
coocurancematrix(im2_lowerLeft, rotation)
disp('2 Bit image lower right');
coocurancematrix(im2_lowerRight, rotation)

function[upperLeft, upperRight, lowerLeft, lowerRight] = split(f)
%https://uk.mathworks.com/matlabcentral/answers/46699-how-to-segment-divide-an-image-into-4-equal-halves
[rows, columns, ~] = size(f);
% Get the rows and columns to split at,
% Taking care to handle odd-size dimensions:
col1 = 1;
col2 = floor(columns/2);
col3 = col2 + 1;
row1 = 1;
row2 = floor(rows/2);
row3 = row2 + 1;
% Now crop
upperLeft = imcrop(f, [col1 row1 col2 row2]);
upperRight = imcrop(f, [col3 row1 columns - col2 row2]);
lowerLeft = imcrop(f, [col1 row3 col2 row2]);
lowerRight = imcrop(f, [col3 row3 columns - col2 rows - row2]);
end

function coocurancematrix(image, rotation)
%For loop go over each different rotation and offset
for K=1:length(rotation)
    %roatate the image
    angled = imrotate(image, rotation(K));
    %0-D offset
    glcm = graycomatrix(angled, 'offset', [0 1]);
    disp('0 -D offset')
    stats(glcm, rotation(K))
    %-D D offset
    glcm = graycomatrix(angled, 'offset', [-1 1]);
    disp('-D D offset')
    stats(glcm, rotation(K))
    %-D 0 offset
    glcm = graycomatrix(angled, 'offset', [-1 0]);
    disp('-D 0 offset')
    stats(glcm, rotation(K))
    
    %-D -D offset
    glcm = graycomatrix(angled, 'offset', [-1 -1]);
    disp('-D -D offset')
    stats(glcm, rotation(K))
end

end

function stats(glcm, rotation)
%heavily based on https://www.imageeprocessing.com/2019/04/texture-measures-from-glcm-matlab-code.html

%divide original by sum
GLCMProb = glcm./sum(glcm(:));
%Create a mesh grid of size 1 to size of glcm by 1 to size of glcm  
[jj,ii]=meshgrid(1:size(glcm,1),1:size(glcm,2));
%Create final mesh
ij=ii-jj;
%calculate features
Con = sum(sum(GLCMProb.*(ij).^2));
Hom = sum(sum(GLCMProb./(1+(ij).^2)));
Asm = sum(sum(GLCMProb.^2));
Meanx = sum(sum(GLCMProb.*ii));
Meany = sum(sum(GLCMProb.*jj));
%more calculations
Energy = sqrt(Asm);
MaxGLCM = max(GLCMProb(:));
Entropy = sum(sum(-GLCMProb .* log10(GLCMProb+0.00001)));
GLCMMean = (Meanx+Meany)/2;
%complete variance of x and y
Varx = sum(sum(GLCMProb.*(ii-Meanx).^2));
Vary = sum(sum(GLCMProb.*(jj-Meany).^2));
%combine variance for overall
GLCMVar = (Varx+Vary)/2;
%calculate correlation
GLCMCorrelation = sum(sum(GLCMProb.*(ii-Meanx).*(jj-Meany)/sqrt(Varx*Vary)));
%print
fprintf('Rotation is')
disp(rotation)
fprintf("Contrast:%f\nHomogeneity:%f\n",Con,Hom);
fprintf("Angular Second Moment :%f\nMax Probability:%f\nEntropy:%f\nEnergy:%f\n",Asm,MaxGLCM,Entropy,Energy);
fprintf("GLCM Mean:%f\nGLCM Variance:%f\nGLCM Correlation:%f\n",GLCMMean,GLCMVar,GLCMCorrelation);
fprintf("----------------------------------------------------------\n")
end



