clear;close all; clc;
% Prepare image
f = imread('ImgPIA.jpg');
imshow(f);

Igray = rgb2gray(f);
resized = imresize(Igray, [256 256]);
f = fft2(resized, 256, 256);
f = fftshift(f);
figure;
imshow(f);

% Measure the minimum and maximum value of the transform amplitude
min = min(min(abs(f)));
max = max(max(abs(f)));
figure;
imshow(abs(f),[]); colormap(jet); colorbar;
figure;
transformed_img = log(1+abs(f));
imshow(transformed_img,[]); colormap(jet); colorbar;



% Spectral approach
% iteratve over image f
% 

%Result = imrotate(Igray,angle);
% 
% resized = imresize(Igray, [256 256]);
% figure;
% plot(resized);
% f = fft2(resized, 256,256);
% figure;
% imshow(f);
% % Measure the minimum and maximum value of the transform amplitude
% min(min(abs(f)));
% max(max(abs(f)));
% figure;
% imshow(abs(f),[0 100]); colormap(jet); colorbar;
% figure;
% imshow(log(1+abs(f)),[0,3]); colormap(jet); colorbar;
% 
% % Look at the phases
% figure;
% imshow(angle(f),[-pi,pi]); colormap(jet); colorbar;

%[x, y] = cart2pol(Igray);
%x
% 
% for K=1: length(angle_arr)
%     angled = imrotate(resized, angle_arr(K));
%     % Compute Fourier Transform
%     F = fft2(angled,256,256);
%     figure;
%     imshow(F);
%     % Measure the minimum and maximum value of the transform amplitude
%     min_trans = min(min(abs(F)));
%     max_trans = max(max(abs(F)));
%     figure;
%     imshow(abs(F),[0 100]); colormap(jet); colorbar;
%     figure;
%     imshow(log(1+abs(F)),[0,3]); colormap(jet); colorbar;
%     
%     % Look at the phases
%     figure;
%     imshow(angle(F),[-pi,pi]); colormap(jet); colorbar;
% end


% Convert to polar coords
%Complete frequency domain formulas

%Josh;'s func
% for i=1: length(thetas)
%     sum = 0;
%     for j=1: length(radii)
%         [x, y] = pol2cart(deg2rad(thetas(i)), radii(j));
%         sum = sum + abs(F(round(image_width/2+x), round(image_width.2+y));
%         
%     end
% end






% 
% 
% %offsets = [0 D; -D D; -D 0; -D -D];
% for K=1: length(angle_arr)
%     angled = imrotate(resized, angle_arr(K));
%     %Co-occurence
%     glcm_0_s = graycomatrix(angled, 'offset', [0 K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + 'True Sym');
%     
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + ' True Sym');
%     
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + ' True Sym');
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K -K],'NumLevels', 256, 'Symmetric',true);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + ' True Sym');
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [0 K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + 'False Sym');
%     
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + ' False Sym');
%     
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + ' False Sym');
%     
%     glcm_0_s = graycomatrix(angled, 'offset', [-K -K],'NumLevels', 256, 'Symmetric',false);
%     figure;
%     imshow(glcm_0_s);
%     title(angle_arr(K) + ' False Sym');
%    
%     
% end


