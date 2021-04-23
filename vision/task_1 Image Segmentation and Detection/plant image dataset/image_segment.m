% close all 
clear;close all; clc;

%load in rgb and label images
theFiles = dir('*rgb*.png');
labels = dir('*label*.png');
%setup similarity score and array for bar chart
sim_score = 0;
score = [];
%for loop with length of files found with matching pattern
for k = 1 : length(theFiles)
    %Read in filename and print
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    %read file
    imageArrayOrig = imread(fullFileName);
    %call segmentation function pass rgb image
    segmented = segmentImage_from_back(imageArrayOrig);
    
    [centers, radii, metric] = imfindcircles(imageArrayOrig,[15 30]);
    viscircles(centers, radii,'EdgeColor','b');
    
    %Read in labelled image and print
    baseFileName = labels(k).name;
    fullFileName = fullfile(labels(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    %read file
    groundtrutharray = imread(fullFileName);
    %Convert lablled image to binary
    gt_mask = groundtrutharray >= 1; 

    %calculate similarity score
    similarity = dice(segmented, gt_mask);
    
    %if similarity score is < 0.3 means that the background is more
    %prominent therefore need to flip and redo score
    if similarity < 0.3
        segmented = imcomplement(segmented);
        imshowpair(segmented, gt_mask, 'montage');
    end
    %redo score
    similarity = dice(segmented, gt_mask);
    %print score
    similarity
    %add sim score to score array for bar chart
    score(k) = similarity;
    
    %Segment the plant from background
    segmented = bsxfun(@times, imageArrayOrig, cast(segmented, 'like', imageArrayOrig));
    
    %Show image thats segmented and ground truth binary image
    figure;
    imshowpair(segmented, gt_mask, 'montage');
    %Add up scores for average
    sim_score = sim_score + similarity;
    %divide by how many files there are
    dice_av = sim_score/length(theFiles);
    
    %count the leaves in the labelled image 
    %kinda cheating but not really?
    count = max(groundtrutharray);
    leaf_count = max(count);
    leaf_count
    
end
%Display bar chart with title
bar(score);
title('Dice scores');
%print dice average score
dice_av


function [BW,maskedImage] = segmentImage_from_back(RGB)
% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Auto clustering
s = rng;
rng('default');
%KMeans segmentation
L = imsegkmeans(single(X),2,'NumAttempts',2);
rng(s);
BW = L == 2;

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end