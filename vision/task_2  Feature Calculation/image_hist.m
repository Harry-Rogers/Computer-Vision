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
disp('Grayscale image');
histogram_features(Igray)

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
%create histogram for calculations
[pixelCounts, graybin] = imhist(Igray);
%count number of pixels
pixels = sum(pixelCounts);
%average  sum of gray bins * pixel count/pixle num
averagebin = sum(graybin .* (pixelCounts / pixels));
%set variance
variance = 0;  
%set skewness
skew = 0; 
%set kurtosis
kurtosis = 0; 
%For loop to calculate the features
for i=0:1:length(pixelCounts)-1
    %variance calculation
    variance = variance + (i-averagebin)^2 * (pixelCounts(i+1)/pixels);
    %skew calculation
    skew = skew + (i-averagebin)^3 * (pixelCounts(i+1)/pixels);
    %kurtosis calculation
    kurtosis = kurtosis + (i-averagebin)^4 * (pixelCounts(i+1)/pixels)-3;
end
%find skewness
skew = skew * variance ^-3;
%find kurtosis
kurtosis = kurtosis * variance ^-4; % kurtosis
%display results in a table
t = table(averagebin, variance, skew, kurtosis);
t
end
