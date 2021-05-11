clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
imshow(f);
%convert image to gray
Igray = rgb2gray(f);

% https://uk.mathworks.com/matlabcentral/answers/24669-down-quantization-8-bit-grey-to-n-bit-grey-n-8
% Reduce the number of bits to 6
reducedImage_6 = uint8((single(Igray)/256)*2^6);

% Reduce the number of bits to 4
reducedImage_4 = uint8((single(Igray)/256)*2^4);

% Reduce the number of bits to 2
reducedImage_2 = uint8((single(Igray)/256)*2^2);
%show image histogram
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

%Array of images with varying bit depth
images_arr = [Igray, reducedImage_6, reducedImage_4, reducedImage_2];
%for loop to go through all images
for image=1:length(images_arr)
    %Gray levelrunmatrix from toolbox
    %https://uk.mathworks.com/matlabcentral/fileexchange/17482-gray-level-run-length-matrix-toolbox
    [GLRLMS, SI] = grayrlmatrix(images_arr(image));
    %Get stats for gray level run
    stats = grayrlprops(GLRLMS);
    %set stats to be values that aren't values of e
    stats = vpa(stats);
    %set variables to empty array to add to table
    %Short Run Emphasis (SRE)
    %Long Run Emphasis (LRE)
    %Gray-Level Nonuniformity (GLN)
    %Run Length Nonuniformity (RLN)
    %Run Percentage (RP)
    %Low Gray-Level Run Emphasis (LGRE)
    %High Gray-Level Run Emphasis (HGRE)
    %Short Run Low Gray-Level Emphasis (SRLGE)
    %Short Run High Gray-Level Emphasis (SRHGE)
    %Long Run Low Gray-Level Emphasis (LRLGE)
    %Long Run High Gray-Level Emphasis (LRHGE)
    SRE = [];
    LRE = [];
    GLN = [];
    RLN = [];
    RP = [];
    LGRE = [];
    HGRE = [];
    SRLGE = [];
    SRHGE = [];
    LRLGE = [];
    LRHGE = [];
    %Set angle list for offset 
    angle_offset = [0;45;90;135];
    %for loop appending arrays
    for K=1:4
        SRE = [SRE, stats(K,1)];
        LRE = [LRE, stats(K,2)];
        GLN = [GLN, stats(K,3)];
        RLN = [RLN, stats(K,4)];
        RP = [RP, stats(K,5)];
        LGRE = [LGRE, stats(K,6)];
        HGRE = [HGRE, stats(K,7)];
        SRLGE = [SRLGE, stats(K,8)];
        SRHGE = [SRHGE, stats(K,9)];
        LRLGE = [LRLGE, stats(K,10)];
        LRHGE = [LRHGE, stats(K,11)];
    end
    
    SRE = reshape(double(SRE), 4,1);
    GLN = reshape(double(GLN), 4,1);
    LRE = reshape(double(LRE), 4,1);
    GLN = reshape(double(GLN), 4,1);
    RLN = reshape(double(RLN), 4,1);
    RP = reshape(double(RP), 4,1);
    LGRE = reshape(double(LGRE), 4,1);
    HGRE = reshape(double(HGRE), 4,1);
    SRLGE = reshape(double(SRLGE), 4,1);
    SRHGE = reshape(double(SRHGE), 4,1);
    LRLGE = reshape(double(LRLGE), 4,1);
    LRHGE = reshape(double(LRHGE), 4,1);
    disp(images_arr(image));
    %Show 
    T = table(angle_offset, SRE, LRE, GLN, RLN, RP, LGRE, HGRE, SRLGE, SRHGE, LRLGE, LRHGE);
    T
    %resize the image for graycomatrix
    Igray = imresize(images_arr(image), [256 256]);
    %For loop using offset angles 
    %set arrays for table
    con = [];
    corr = [];
    energy = [];
    homogen = [];
    asm = [];
    image_entropy = [];
    for K=1:length(angle_offset)
        %rotate image
        angled = imrotate(Igray, angle_offset(K));
        %Complete graycomatrix for offset 0 D
        glcm = graycomatrix(angled, 'offset', [0 1]);
        %Get builtin stats
        stats = graycoprops(glcm);
        %contrast
        con = [stats.Contrast];
        %Correlation
        corr = [stats.Correlation];
        %Engergy
        energy = [stats.Energy];
        %homogeneity
        homogen = [stats.Homogeneity];
        %angular second moment, energy is sqrt(asm)
        asm = energy * energy;
        %calculate entropy with built in
        Image_Entropy = entropy(angled);
        
        t = table(angle_offset(K), con, corr, energy, homogen, asm, Image_Entropy);      
        
        glcm = graycomatrix(angled, 'offset', [-1 1]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        t = table(angle_offset(K), con, corr, energy, homogen, asm, Image_Entropy);
        t
        
        
        glcm = graycomatrix(angled, 'offset', [-1 0]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        t_neg1_0 = table(angle_offset(K), con, corr, energy, homogen, asm, Image_Entropy);
        t_neg1_0
        
        glcm = graycomatrix(angled, 'offset', [-1 -1]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        t_neg1_neg1 = table(angle_offset(K), con, corr, energy, homogen, asm, Image_Entropy);
        t_neg1_neg1
    end
end