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
disp('Grayscale image');
graylevelmatrix(Igray)
disp('Grayscale image upper left');
graylevelmatrix(im_upperLeft)
disp('Grayscale image upper right');
graylevelmatrix(im_upperRight)
disp('Grayscale image lower left');
graylevelmatrix(im_lowerLeft)
disp('Grayscale image lower right');
graylevelmatrix(im_lowerRight)

disp('32 Bit image');
graylevelmatrix(reducedImage_32)
disp('32 Bit image upper left');
graylevelmatrix(im32_upperLeft)
disp('32 Bit image upper right');
graylevelmatrix(im32_upperRight)
disp('32 Bit image lower left');
graylevelmatrix(im32_lowerLeft)
disp('32 Bit image lower right');
graylevelmatrix(im32_lowerRight)


disp('8 Bit image');
graylevelmatrix(reducedImage_8)
disp('8 Bit image upper left');
graylevelmatrix(im8_upperLeft)
disp('8 Bit image upper right');
graylevelmatrix(im8_upperRight)
disp('8 Bit image lower left');
graylevelmatrix(im8_lowerLeft)
disp('8 Bit image lower right');
graylevelmatrix(im8_lowerRight)

disp('6 Bit image');
graylevelmatrix(reducedImage_6)
disp('6 Bit image upper left');
graylevelmatrix(im6_upperLeft)
disp('6 Bit image upper right');
graylevelmatrix(im6_upperRight)
disp('6 Bit image lower left');
graylevelmatrix(im6_lowerLeft)
disp('6 Bit image lower right');
graylevelmatrix(im6_lowerRight)

disp('4 Bit image');
graylevelmatrix(reducedImage_4)
disp('4 Bit image upper left');
graylevelmatrix(im4_upperLeft)
disp('4 Bit image upper right');
graylevelmatrix(im4_upperRight)
disp('4 Bit image lower left');
graylevelmatrix(im4_lowerLeft)
disp('4 Bit image lower right');
graylevelmatrix(im4_lowerRight)


disp('2 Bit image');
graylevelmatrix(reducedImage_2)
disp('2 Bit image upper left');
graylevelmatrix(im2_upperLeft)
disp('2 Bit image upper right');
graylevelmatrix(im2_upperRight)
disp('2 Bit image lower left');
graylevelmatrix(im2_lowerLeft)
disp('2 Bit image lower right');
graylevelmatrix(im2_lowerRight)

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

function graylevelmatrix(Igray)
%Gray levelrunmatrix from toolbox
%https://uk.mathworks.com/matlabcentral/fileexchange/17482-gray-level-run-length-matrix-toolbox
figure;
imshow(Igray);
[GLRLMS, ~] = grayrlmatrix(Igray);
%Get stats for gray level run
stats = grayrlprops(GLRLMS);
%set stats to be values that aren't values of e
stats = vpa(stats);
%set variables to empty array to add to table
%Short Run Emphasis (SRE)
%Long Run Emphasis (LRE)
%Gray-Level Nonuniformity (GLN)
%Run Length Nonuniformity (RLN)
%Run Percentage (RP)
%Low Gray-Level Run Emphasis (LGRE)
%High Gray-Level Run Emphasis (HGRE)
%Short Run Low Gray-Level Emphasis (SRLGE)
%Short Run High Gray-Level Emphasis (SRHGE)
%Long Run Low Gray-Level Emphasis (LRLGE)
%Long Run High Gray-Level Emphasis (LRHGE)
SRE = [];
LRE = [];
GLN = [];
RLN = [];
RP = [];
LGRE = [];
HGRE = [];
SRLGE = [];
SRHGE = [];
LRLGE = [];
LRHGE = [];
%Set angle list for offset
angle_offset = [0;45;90;135];
%for loop appending arrays
for K=1:4
    SRE = [SRE, stats(K,1)];
    LRE = [LRE, stats(K,2)];
    GLN = [GLN, stats(K,3)];
    RLN = [RLN, stats(K,4)];
    RP = [RP, stats(K,5)];
    LGRE = [LGRE, stats(K,6)];
    HGRE = [HGRE, stats(K,7)];
    SRLGE = [SRLGE, stats(K,8)];
    SRHGE = [SRHGE, stats(K,9)];
    LRLGE = [LRLGE, stats(K,10)];
    LRHGE = [LRHGE, stats(K,11)];
end
%unpack and reshape arrays for table
SRE = reshape(double(SRE), 4,1);
GLN = reshape(double(GLN), 4,1);
LRE = reshape(double(LRE), 4,1);
GLN = reshape(double(GLN), 4,1);
RLN = reshape(double(RLN), 4,1);
RP = reshape(double(RP), 4,1);
LGRE = reshape(double(LGRE), 4,1);
HGRE = reshape(double(HGRE), 4,1);
SRLGE = reshape(double(SRLGE), 4,1);
SRHGE = reshape(double(SRHGE), 4,1);
LRLGE = reshape(double(LRLGE), 4,1);
LRHGE = reshape(double(LRHGE), 4,1);
%Show in table
T = table(angle_offset, SRE, LRE, GLN, RLN, RP, LGRE, HGRE, SRLGE, SRHGE, LRLGE, LRHGE)
end