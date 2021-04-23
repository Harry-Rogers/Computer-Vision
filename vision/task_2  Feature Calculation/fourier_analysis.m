clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
imshow(f);

Igray = rgb2gray(f);

angle_arr = [0, 45, 90, 135, 180, 225, 270, 315, 360];


%Result = imrotate(Igray,angle);

resized = imresize(Igray, [256 256]);

for K=1: length(angle_arr)
    angled = imrotate(resized, angle_arr(K));
    % Compute Fourier Transform
    F = fft2(angled,256,256);
    figure;
    imshow(F);
    F = fftshift(F); % Center FFT
    figure;
    imshow(F);
    % Measure the minimum and maximum value of the transform amplitude
    min_trans = min(min(abs(F)))
    max_trans = max(max(abs(F)))
    figure;
    imshow(abs(F),[0 100]); colormap(jet); colorbar
    figure;
    imshow(log(1+abs(F)),[0,3]); colormap(jet); colorbar
    
    % Look at the phases
    figure;
    imshow(angle(F),[-pi,pi]); colormap(jet); colorbar
    
    I = ifft2(F, 256,256);
    figure;
    imshow(I);
end


%offsets = [0 D; -D D; -D 0; -D -D];
for K=1: length(angle_arr)
    angled = imrotate(resized, angle_arr(K));
    %Co-occurence
    glcm_0_s = graycomatrix(angled, 'offset', [0 K],'NumLevels', 256, 'Symmetric',true);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + 'True Sym');
    
    
    glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',true);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + ' True Sym');
    
    
    glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',true);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + ' True Sym');
    
    glcm_0_s = graycomatrix(angled, 'offset', [-K -K],'NumLevels', 256, 'Symmetric',true);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + ' True Sym');
    
    glcm_0_s = graycomatrix(angled, 'offset', [0 K],'NumLevels', 256, 'Symmetric',false);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + 'False Sym');
    
    
    glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',false);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + ' False Sym');
    
    
    glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',false);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + ' False Sym');
    
    glcm_0_s = graycomatrix(angled, 'offset', [-K -K],'NumLevels', 256, 'Symmetric',false);
    figure;
    imshow(glcm_0_s);
    title(angle_arr(K) + ' False Sym');
   
    
end


