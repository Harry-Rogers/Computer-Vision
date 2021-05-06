clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
imshow(f);
Igray = rgb2gray(f);
x = histogram(Igray);
xlabel('Value')
ylabel('Frequency')

angle_arr = [0 45 90 135 180 225 270 315 360];

[pixelCounts, GLs] = imhist(Igray);
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
vpa(result)

glcm_0_s = graycomatrix(Igray, 'offset', [0 1],'NumLevels', 256, 'Symmetric', true);
figure;
plot(glcm_0_s);

glcm_0_ns = graycomatrix(Igray, 'offset', [0 1],'NumLevels', 256, 'Symmetric', false);
figure;
plot(glcm_0_ns);

stats_0_s = graycoprops(glcm_0_s,{'contrast','correlation','energy','homogeneity'});
stats_0_ns = graycoprops(glcm_0_ns,{'contrast','correlation','energy','homogeneity'});

stats_0_s
stats_0_ns
glcm_0_s = graycomatrix(matrix)
% for K=1: length(angle_arr)
%     angled = imrotate(Igray, angle_arr(K));
%     %Co-occurence
%     glcm_0_s = graycomatrix(angled, 'offset', [0 K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     plot(glcm_0_s);
%      
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     plot(glcm_0_s);
%        
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     plot(glcm_0_s);
%        
%     glcm_0_s = graycomatrix(angled, 'offset', [-K -K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     plot(glcm_0_s);
%         
%     glcm_0_s = graycomatrix(angled, 'offset', [0 K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     plot(glcm_0_s);
%        
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     plot(glcm_0_s);
%    
%     
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     plot(glcm_0_s);
%     
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K -K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     plot(glcm_0_s);  
%     
% end


