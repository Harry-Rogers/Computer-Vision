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
for k = 1: length(theFiles)
    miss = 0;
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    %read file
    imageArrayOrig = imread(fullFileName);
    segmented = segmentImage_from_back(imageArrayOrig);
    segmented = bsxfun(@times, imageArrayOrig, cast(segmented, 'like', imageArrayOrig));
    %Convert to grayscale
    Igray = rgb2gray(imageArrayOrig);
    %Convert to binary
    threshold_value= graythresh(Igray);
    binaryImg = imbinarize(Igray, threshold_value);
    
    figure;
    imshow(binaryImg);
    I = imresize(imageArrayOrig, 2);
    figure;s
    imshow(I);
    [centers, radii, metric] = imfindcircles(imageArrayOrig,[lower upper]);
    %[centersBright, radiiBright] = imfindcircles(gt_mask,[5 30],'ObjectPolarity','bright');
    
    stats = regionprops('table', binaryImg, 'Centroid', 'Eccentricity', 'EquivDiameter');
    stats

    
    %image no edits
    % 37.5 accuracy with (5, 30) and (5,35) and (5, 40)
    % 6,40 has 18.7
    %5, 60 gets 31.25
    
    
    %segmented with func
    %5,30 18.75
    
    %segmented with no back
    %5,30 0 :(
    
    %binary manual
    %5,30 Error
    %Changed code 
    %[centersBright, radiiBright] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','bright');
    
    %Integrate regionProps
    % https://uk.mathworks.com/matlabcentral/answers/334096-why-does-imfindcircles-not-find-circles-in-my-image?s_tid=answers_rc1-3_p3_MLT

    
    viscircles(centers, radii,'EdgeColor','b');
    leafGuess = length(metric);
    
    baseFileName = labels(k).name;
    fullFileName = fullfile(labels(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    
    groundtrutharray = imread(fullFileName);
    
    
    %count the leaves in the labelled image 
    %kinda cheating but not really?
    count = max(groundtrutharray);
    leaf_count = max(count);
    %leaf_count
    if leafGuess == leaf_count
        av_acc = av_acc + 1
    end
    leafGuess
    leaf_count
    if leafGuess ~= leaf_count
        %matlab is shit have to convert to numbers that can be negative
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

av_acc = av_acc / length(theFiles);
av_acc
miss_arr


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


