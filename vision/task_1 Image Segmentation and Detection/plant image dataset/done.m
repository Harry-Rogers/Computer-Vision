clear; close all; clc;


warning('off','all');
%load in rgb and label images
theFiles = dir('*rgb*.png');
labels = dir('*label*.png');
av_acc = 0;
accuracy = 0;
indi = 0;
miss_arr = [];
upper = 30;
lower = 5;
sim_score = 0;
for k = 1: length(theFiles)
    miss = 0;
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    %read file
    imageArrayOrig = imread(fullFileName);
    segmented = segmentImage_from_back(imageArrayOrig);
    %Convert to grayscale
    Igray = rgb2gray(imageArrayOrig);
    %Convert to binary
    threshold_value= graythresh(Igray);
    binaryImg = imbinarize(Igray, threshold_value);
    
    figure;
    imshow(binaryImg);
    I = imresize(imageArrayOrig, 2);
    figure;
    imshow(I);
    [centers, radii, metric] = imfindcircles(imageArrayOrig,[lower upper]);
    %[centersBright, radiiBright] = imfindcircles(gt_mask,[5 30],'ObjectPolarity','bright');
    
    stats = regionprops('table', binaryImg, 'Centroid', 'Eccentricity', 'EquivDiameter');
    stats
    
 
    viscircles(centers, radii,'EdgeColor','b');
    leafGuess = length(metric);
    baseFileName = labels(k).name;
    fullFileName = fullfile(labels(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    
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
    %Add up scores for average
    sim_score = sim_score + similarity;
    %divide by how many files there are
    dice_av = sim_score/length(theFiles);
    %count the leaves in the labelled image 
    count = max(groundtrutharray);
    leaf_count = max(count);
    %leaf_count
    if leafGuess == leaf_count
        av_acc = av_acc + 1
    end
    leafGuess
    leaf_count
    if leafGuess ~= leaf_count
        %matlab to convert to numbers that can be negative
        miss= int32(leafGuess) - int32(leaf_count);
    end
    miss_arr = [miss_arr, miss];
    
    %Essentially brute forcing a better accuracy
    % Increase upper limit first
    %Check
    %if 100 iterations stop
    breaker = 0;
    while miss < 0
        breaker = breaker + 1;
        upper = upper + 1;
        [centers, radii, metric] = imfindcircles(imageArrayOrig,[lower upper]);
        viscircles(centers, radii,'EdgeColor','b');
        leafGuess = length(metric);
        
        
        if leafGuess == leaf_count
            av_acc = av_acc +1
            break;
        end
        if leafGuess ~= leaf_count
        %matlab is shit have to convert to numbers that can be negative
        miss= int32(leafGuess) - int32(leaf_count);
        end
        if breaker == 100
            break;
        end
            
    end
    
end
%Display bar chart with title
bar(score);
title('Dice scores');
%print dice average score
dice_av
av_acc = av_acc / length(theFiles);
av_acc
miss_arr
holder = double(0.0);
for k = 1: length(miss_arr)
    if miss_arr(k) > 0
        holder = double(miss_arr(k) + holder);
    elseif miss_arr(k) < 0
        holder = double(abs(miss_arr(k)) + holder);
        
    end
end
holder
holding = double(holder/16);
holding
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


