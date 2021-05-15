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
disp('Grayscale image');
histogram_features(Igray)

disp('32 Bit image');
histogram_features(reducedImage_32)

disp('8 Bit image');
histogram_features(reducedImage_8)

disp('6 Bit image');
histogram_features(reducedImage_6)

disp('4 Bit image');
histogram_features(reducedImage_4)

disp('2 Bit image');
histogram_features(reducedImage_2)


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

t = table(averagebin, variance, skew, kurtosis);
t
end
