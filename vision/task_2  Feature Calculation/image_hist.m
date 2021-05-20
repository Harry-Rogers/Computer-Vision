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
histogram_features(Igray)
disp('Grayscale image upper left');
histogram_features(im_upperLeft)
disp('Grayscale image upper right');
histogram_features(im_upperRight)
disp('Grayscale image lower left');
histogram_features(im_lowerLeft)
disp('Grayscale image lower right');
histogram_features(im_lowerRight)

disp('32 Bit image');
histogram_features(reducedImage_32)
disp('32 Bit image upper left');
histogram_features(im32_upperLeft)
disp('32 Bit image upper right');
histogram_features(im32_upperRight)
disp('32 Bit image lower left');
histogram_features(im32_lowerLeft)
disp('32 Bit image lower right');
histogram_features(im32_lowerRight)


disp('8 Bit image');
histogram_features(reducedImage_8)
disp('8 Bit image upper left');
histogram_features(im8_upperLeft)
disp('8 Bit image upper right');
histogram_features(im8_upperRight)
disp('8 Bit image lower left');
histogram_features(im8_lowerLeft)
disp('8 Bit image lower right');
histogram_features(im8_lowerRight)

disp('6 Bit image');
histogram_features(reducedImage_6)
disp('6 Bit image upper left');
histogram_features(im6_upperLeft)
disp('6 Bit image upper right');
histogram_features(im6_upperRight)
disp('6 Bit image lower left');
histogram_features(im6_lowerLeft)
disp('6 Bit image lower right');
histogram_features(im6_lowerRight)

disp('4 Bit image');
histogram_features(reducedImage_4)
disp('4 Bit image upper left');
histogram_features(im4_upperLeft)
disp('4 Bit image upper right');
histogram_features(im4_upperRight)
disp('4 Bit image lower left');
histogram_features(im4_lowerLeft)
disp('4 Bit image lower right');
histogram_features(im4_lowerRight)


disp('2 Bit image');
histogram_features(reducedImage_2)
disp('2 Bit image upper left');
histogram_features(im2_upperLeft)
disp('2 Bit image upper right');
histogram_features(im2_upperRight)
disp('2 Bit image lower left');
histogram_features(im2_lowerLeft)
disp('2 Bit image lower right');
histogram_features(im2_lowerRight)

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

function histogram_features(Igray)
figure;
imshow(Igray);
figure;
x = histogram(Igray);
xlabel('Value')
ylabel('Frequency')

%https://uk.mathworks.com/matlabcentral/answers/15307-image-operations-skewness-and-kurtosis
%https://uk.mathworks.com/matlabcentral/answers/84205-how-can-i-calculate-variance-of-the-intensity-in-an-gray-scale-image

%create histogram for calculations
[pixelCounts, graybin] = imhist(Igray);
%count number of pixels
pixels = sum(pixelCounts);
%average  sum of gray bins * pixel count/pixle num
averagebin = sum(graybin .* (pixelCounts / pixels));
% Get the number of pixels in the histogram.
numberOfPixels = sum(pixelCounts);
% Get the mean gray lavel.
meanGL = sum(pixelCounts .* pixelCounts) / numberOfPixels;
% Get the variance, which is the second central moment.
varianceGL = sum((pixelCounts - meanGL) .^ 2 .* pixelCounts) / (numberOfPixels-1);
% Get the standard deviation.
sd = sqrt(varianceGL);
% Get the skew.
skew = sum((pixelCounts - meanGL) .^ 3 .* pixelCounts) / ((numberOfPixels - 1) * sd^3);
% Get the kurtosis.
kurtosis = sum((pixelCounts - meanGL) .^ 4 .* pixelCounts) / ((numberOfPixels - 1) * sd^4);

Igray = double(Igray);
variance = var(Igray(:));

t = table(averagebin, variance, skew, kurtosis)
end
