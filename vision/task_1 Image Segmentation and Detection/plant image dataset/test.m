close all;
I = imread('ara2013_plant060_rgb.png');

segmented = segmentImage_from_back(I);
%imshow(segmented);
%title('Segmented image');
imageArrayGray = im2gray(I);
lvl = graythresh(imageArrayGray);
bw = imbinarize(imageArrayGray, lvl);


similarity = dice(segmented, bw);

if similarity < 0.3
    segmented = imcomplement(segmented);
    imshowpair(segmented, bw, 'montage');
end

similarity = dice(segmented, bw);
similarity

figure;
imshowpair(segmented, bw, 'montage');
%imshow(binary);
%title('Binary image');
%figure;
%D = bwdist(segmented);
%D = -D;
gmag = imgradient(imageArrayGray);
%imshow(gmag, []);
%L = watershed(gmag);
%Lrgb = label2rgb(L);
%imshow(Lrgb);
se = strel('disk',5);
Io = imopen(imageArrayGray,se);
%imshow(Io);
Ie = imerode(imageArrayGray,se);
Iobr = imreconstruct(Ie,imageArrayGray);
%imshow(Iobr);
Ioc = imclose(Io,se);
%imshow(Ioc);
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
%imshow(Iobrcbr);
fgm = imregionalmax(Iobrcbr);
%imshow(fgm);
I2 = labeloverlay(imageArrayGray,fgm);
%imshow(I2);
se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(imageArrayGray,fgm4);
%imshow(I3);
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
%imshow(bgm);

gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);
Lrgb = label2rgb(L,'jet','w','shuffle');
%imshow(Lrgb);
%figure;

CC = bwconncomp(bw);

labels = labelmatrix(CC);
numObjects = max(L(:));
numObjects







function [BW,maskedImage] = segmentImage_from_back(RGB)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW,MASKEDIMAGE] = segmentImage(RGB) segments image RGB using
%  auto-generated code from the imageSegmenter app. The final segmentation
%  is returned in BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 10-Mar-2021
%----------------------------------------------------


% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Auto clustering
s = rng;
rng('default');
L = imsegkmeans(single(X),2,'NumAttempts',2);
rng(s);
BW = L == 2;

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end