clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
%convert image to gray
Igray = rgb2gray(f);

% https://uk.mathworks.com/matlabcentral/answers/24669-down-quantization-8-bit-grey-to-n-bit-grey-n-8

% Reduce the number of bits to 32
reducedImage_32 = uint8((single(Igray)/256)*2^5);

% Reduce the number of bits to 8
reducedImage_8 = uint8((single(Igray)/256)*2^3);

% Reduce the number of bits to 6
reducedImage_6 = uint8((single(Igray)/256)*2^2.58496);

% Reduce the number of bits to 4
reducedImage_4 = uint8((single(Igray)/256)*2^2);

% Reduce the number of bits to 2
reducedImage_2 = uint8((single(Igray)/256)*2^1);

%call functions and display relevant info
rotation = [0,45,90,135];

disp('Grayscale image');
coocurancematrix(Igray, rotation)

disp('32 Bit image');
coocurancematrix(reducedImage_32, rotation)

disp('8 Bit image');
coocurancematrix(reducedImage_8, rotation)

disp('6 Bit image');
coocurancematrix(reducedImage_6, rotation)

disp('4 Bit image');
coocurancematrix(reducedImage_4, rotation)

disp('2 Bit image');
coocurancematrix(reducedImage_2, rotation)

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
%initilase variables
Con=0;
Hom=0;
Asm=0;
Meanx=0;
Meany=0;
Varx=0;
Vary=0;
GLCMCorrelation=0;

%normalise glcm
GProb = glcm./sum(glcm(:));
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



