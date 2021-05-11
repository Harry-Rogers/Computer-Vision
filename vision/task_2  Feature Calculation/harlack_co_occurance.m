clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
%convert image to gray
Igray = rgb2gray(f);

% https://uk.mathworks.com/matlabcentral/answers/24669-down-quantization-8-bit-grey-to-n-bit-grey-n-8
% Reduce the number of bits to 6
reducedImage_6 = uint8((single(Igray)/256)*2^6);
 
% Reduce the number of bits to 4
reducedImage_4 = uint8((single(Igray)/256)*2^4);
 
% Reduce the number of bits to 2
reducedImage_2 = uint8((single(Igray)/256)*2^2);
%call functions and display relevant info
rotation = [0,45,90,135];

disp('Grayscale image');
coocurancematrix(Igray, rotation)

disp('6 Bit image');
coocurancematrix(reducedImage_6, rotation)

disp('4 Bit image');
coocurancematrix(reducedImage_4, rotation)

disp('2 Bit image');
coocurancematrix(reducedImage_2, rotation)


function coocurancematrix(image, rotation)
%set array for features
con = [];
corr = [];
energy = [];
homogen = [];
asm = [];
Image_entropy = [];
%For loop go over each different rotation and offset
for K=1:length(rotation)
    %roatate the image
    angled = imrotate(image, rotation(K));
    %0-D offset
    glcm = graycomatrix(angled, 'offset', [0 1]);
    %unpack stats
    stats = graycoprops(glcm);
    %add stats to arrays
    con = [con, [stats.Contrast]];
    corr = [corr,[stats.Correlation]];
    energy = [energy, [stats.Energy]];
    homogen = [homogen, [stats.Homogeneity]];
    asm_hold = energy .* energy;
    asm = [asm_hold];
    Image_entropy = entropy(angled);
    Image_entropy = [Image_entropy];
    
    %-D D offset
    glcm = graycomatrix(angled, 'offset', [-1 1]);
    stats = graycoprops(glcm);
    con = [stats.Contrast];
    corr = [stats.Correlation];
    energy = [stats.Energy];
    homogen = [stats.Homogeneity];
    asm_hold = energy .* energy;
    asm = [asm_hold];

    %-D 0 offset
    glcm = graycomatrix(angled, 'offset', [-1 0]);
    stats = graycoprops(glcm);
    con = [stats.Contrast];
    corr = [stats.Correlation];
    energy = [stats.Energy];
    homogen = [stats.Homogeneity];
    asm_hold = energy .* energy;
    asm = [asm_hold];
    
    %-D -D offset
    glcm = graycomatrix(angled, 'offset', [-1 -1]);
    stats = graycoprops(glcm);
    con = [stats.Contrast];
    corr = [stats.Correlation];
    energy = [stats.Energy];
    homogen = [stats.Homogeneity];
    asm_hold = energy .* energy;
    asm = [asm_hold];
    
    %print table
    t = table(rotation(K), con, corr, energy, homogen, asm, Image_entropy);
    t
end

end