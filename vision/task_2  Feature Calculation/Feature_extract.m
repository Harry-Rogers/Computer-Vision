clear;close all; clc;
I = imread('ImgPIA.jpg');

Igray = rgb2gray(I);

corners = detectHarrisFeatures(Igray);
[features, valid_corners] = extractFeatures(Igray, corners);
figure, imshow(I);hold on
plot(valid_corners);

points = detectSURFFeatures(Igray);
[features, valid_points] = extractFeatures(Igray, points);
figure; imshow(Igray); hold on;
plot(valid_points.selectStrongest(10),'showOrientation',true);

regions = detectMSERFeatures(Igray);
[features, valid_points] = extractFeatures(Igray,regions,'Upright',true);
figure; imshow(I); hold on;
plot(valid_points,'showOrientation',true);

%points = detectBRISKFeatures(Igray);
%[features, valid_points] = extractFeatures(Igray, points);
%figure;imshow(Igray); hold on;
%plot(valid_points.selectStrongest(10), 'ShowOrientation', true);

%
regions = detectMSERFeatures(Igray);
figure; imshow(Igray); hold on;
plot(regions, 'showPixelList', true, 'showEllipses', false);

figure; imshow(Igray); hold on;
plot(regions);