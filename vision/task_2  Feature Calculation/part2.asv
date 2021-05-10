clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
imshow(f);

Igray = rgb2gray(f);

% https://uk.mathworks.com/matlabcentral/answers/24669-down-quantization-8-bit-grey-to-n-bit-grey-n-8
% Reduce the number of bits to 6
reducedImage_6 = uint8((single(Igray)/256)*2^6);

% Reduce the number of bits to 4
reducedImage_4 = uint8((single(Igray)/256)*2^4);

% Reduce the number of bits to 2
reducedImage_2 = uint8((single(Igray)/256)*2^2);

figure;
x = histogram(Igray);
xlabel('Value')
ylabel('Frequency')

images_arr = [Igray, reducedImage_6, reducedImage_4, reducedImage_2];
for image=1:length(images_arr)
    
    [GLRLMS, SI] = grayrlmatrix(images_arr(image));
    stats = grayrlprops(GLRLMS);
    stats = vpa(stats);
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
    angles = [0;45;90;135];
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
    
    angles = reshape(angles,4,1);
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
    
    T = table(angles, SRE, LRE, GLN, RLN, RP, LGRE, HGRE, SRLGE, SRHGE, LRLGE, LRHGE);
    T
    
    angle_arr = [0 45 90 135];
    
    [pixelCounts, GLs] = imhist(images_arr(image));
    NM = sum(pixelCounts); % number of pixels
    
    meanGL = sum(GLs .* (pixelCounts / NM));
    
    varresult = 0;  % variance temp var
    skewresult = 0; % skewness temp var
    kurtresult = 0; % kurtosis temp var
    
    for i=0:1:length(pixelCounts)-1
        varresult = varresult + (i-meanGL)^2 * (pixelCounts(i+1)/NM);
        skewresult = skewresult + (i-meanGL)^3 * (pixelCounts(i+1)/NM);
        kurtresult = kurtresult + (i-meanGL)^4 * (pixelCounts(i+1)/NM)-3;
    end
    
    skewresult = skewresult * varresult ^-3; % skewness
    kurtresult = kurtresult * varresult ^-4; % kurtosis
    %energy
    energy = sum((pixelCounts / NM) .^ 2);
    %entropy
    pI = pixelCounts / NM;
    entropy1 = -sum(pI(pI~=0) .* log2(pI(pI~=0)));
    % returns the same result as above
    %entropy2 = -sum(pI .* log2(pI+eps))
    %entropy3 = entropy(img1)
    result = [meanGL, varresult, skewresult, kurtresult, energy, entropy1];
    t = table(meanGL, varresult, skewresult, kurtresult, energy, entropy1);
    t
    
    Igray = imresize(images_arr(image), [256 256]);
    
    for K=1:length(angles)
        angled = imrotate(Igray, angles(K));
        
        glcm = graycomatrix(angled, 'offset', [0 1]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        
        Image_Entropy = entropy(angled);
        
        t_0_1 = table(angles(K), con, corr, energy, homogen, asm, Image_Entropy);
        t_0_1
        
        
        glcm = graycomatrix(angled, 'offset', [-1 1]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        t_neg1_1 = table(angles(K), con, corr, energy, homogen, asm, Image_Entropy);
        t_neg1_1
        
        glcm = graycomatrix(angled, 'offset', [-1 0]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        t_neg1_0 = table(angles(K), con, corr, energy, homogen, asm, Image_Entropy);
        t_neg1_0
        
        glcm = graycomatrix(angled, 'offset', [-1 -1]);
        stats = graycoprops(glcm);
        con = [stats.Contrast];
        corr = [stats.Correlation];
        energy = [stats.Energy];
        homogen = [stats.Homogeneity];
        asm = energy * energy;
        t_neg1_neg1 = table(angles(K), con, corr, energy, homogen, asm, Image_Entropy);
        t_neg1_neg1
    end
end