clear;close all; clc;
I = imread('ImgPIA.jpg');
figure, imshow(I);
labeledImage = bwlabel(I, 5);
objectMeasureMents = regionprops(labeledImage, 'all');
figure, imshow(objectMeasureMents);