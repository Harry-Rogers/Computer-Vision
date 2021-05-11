clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
%convert image to gray
Igray = rgb2gray(f);
%Ignoring warningssc
warning('off')

% https://uk.mathworks.com/matlabcentral/answers/24669-down-quantization-8-bit-grey-to-n-bit-grey-n-8
% Reduce the number of bits to 6
reducedImage_6 = uint8((single(Igray)/256)*2^6);
 
% Reduce the number of bits to 4
reducedImage_4 = uint8((single(Igray)/256)*2^4);
 
% Reduce the number of bits to 2
reducedImage_2 = uint8((single(Igray)/256)*2^2);
%call functions and display relevant info
disp('Grayscale image');
graylevelmatrix(Igray)

disp('6 Bit image');
graylevelmatrix(reducedImage_6)

disp('4 Bit image');
graylevelmatrix(reducedImage_4)

disp('2 Bit image');
graylevelmatrix(reducedImage_2)


function graylevelmatrix(Igray)
%Gray levelrunmatrix from toolbox
%https://uk.mathworks.com/matlabcentral/fileexchange/17482-gray-level-run-length-matrix-toolbox
figure;
imshow(Igray);
[GLRLMS, SI] = grayrlmatrix(Igray);
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
T = table(angle_offset, SRE, LRE, GLN, RLN, RP, LGRE, HGRE, SRLGE, SRHGE, LRLGE, LRHGE);
T
writetable(T, 'test.xlsx','Sheet', 1);

end