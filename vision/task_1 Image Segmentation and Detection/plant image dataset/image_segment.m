%Clear all
clear; close all; clc;
%load in rgb and label images
theFiles = dir('*rgb*.png');
labels = dir('*label*.png');
%Create variables for calculations
%accuracy for leaf count
av_acc_leaf = 0;
%array of missed leaves
miss_arr = [];
%upper limit for leaf finding
upper = 30;
%lower limit for leaf finding
lower = 5;
%similarity score
sim_score = 0;
%Arrays for leaf guessing and actual
leaf_guess_arr = [];
leaf_acc_arr = [];
%loop over dataset
for k = 1: length(theFiles)
    %Set miss to 0
    miss = 0;
    %Read in files
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    %read file
    imageArrayOrig = imread(fullFileName);
    %Segment image
    segmented = segmentImage_from_back(imageArrayOrig);
    %Convert to grayscale
    Igray = rgb2gray(imageArrayOrig);
    %Convert to binary
    threshold_value= graythresh(Igray);
    binaryImg = imbinarize(Igray, threshold_value);
    %Show image
    figure;
    imshow(binaryImg);
    %Resize image to try and identify smaller leaves
    I = imresize(imageArrayOrig, 2);
    figure;
    imshow(I);
    %Find leaves with boundaries
    [centers, radii, metric] = imfindcircles(imageArrayOrig,[lower upper]);
    %Show leaves found on image    
    viscircles(centers, radii,'EdgeColor','b');
    %Take guess for leaves
    leafGuess = length(metric);
    
    %Read in labelled images
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
    %Segmentation is based on 2 objects so will pick put background and
    %object
    if similarity < 0.3
        segmented = imcomplement(segmented);
        imshowpair(segmented, gt_mask, 'montage');
    end
    %redo score
    similarity = dice(segmented, gt_mask);

    %add sim score to score array for bar chart
    score(k) = similarity;
    %Add up scores for average
    sim_score = sim_score + similarity;
    %divide by how many files there are
    dice_av = sim_score/length(theFiles);
    %count the leaves in the labelled image 
    count = max(groundtrutharray);
    leaf_count = max(count);
    %leaf_count accuracy
    if leafGuess == leaf_count
        av_acc_leaf = av_acc_leaf + 1
    end
    
    %If leafguess not accurate add to miss
    if leafGuess ~= leaf_count
        %matlab to convert to numbers that can be negative
        miss= int32(leafGuess) - int32(leaf_count);
    end
    %add miss to array
    miss_arr = [miss_arr, miss];
    
    %Essentially brute forcing a better accuracy
    % Increase upper limit since lower is at bottom for imfindcircles
    %if 100 iterations stop probbaly won't find it
    breaker = 0;
    while miss < 0
        breaker = breaker + 1;
        upper = upper + 1;
        [centers, radii, metric] = imfindcircles(imageArrayOrig,[lower upper]);
        viscircles(centers, radii,'EdgeColor','b');
        leafGuess = length(metric);
        
        %Check if any difference
        if leafGuess == leaf_count
            av_acc_leaf = av_acc_leaf +1
            break;
        end
        if leafGuess ~= leaf_count
        %matlab to convert to numbers that can be negative
        miss= int32(leafGuess) - int32(leaf_count);
        end
        if breaker == 100
            break;
        end
            
    end
    %Add guess and actual to arrays
    leaf_guess_arr = [leaf_guess_arr, leafGuess];
    leaf_acc_arr = [leaf_acc_arr, leaf_count];
end
%Display bar chart with title
bar(score);
title('Dice scores');
%print dice average score
dice_av
%print and calculate accuracy overall
av_acc_leaf = av_acc_leaf / length(theFiles);
av_acc_leaf
%Reshape arrays for table
leaf_guess_arr = reshape(leaf_guess_arr, 16,1);
leaf_acc_arr = reshape(leaf_acc_arr, 16,1);
%holder for calculations for mean leaf count
holder = double(0.0);
for k = 1: length(miss_arr)
    %positive calc
    if miss_arr(k) > 0
        holder = double(miss_arr(k) + holder);
    %negative calc
    elseif miss_arr(k) < 0
        holder = double(abs(miss_arr(k)) + holder);
        
    end
end
%Calc mean diff for leaves
mean_diff_leaf = double(holder/16);
mean_diff_leaf
%Reshape miss array for table
miss_arr = reshape(miss_arr, 16, 1);
%image number
img_num = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16];
%make table
T = table(img_num, leaf_guess_arr, leaf_acc_arr, miss_arr)
%print table
mean_diff_leaf

%Function for segmentation using matlab apps
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


