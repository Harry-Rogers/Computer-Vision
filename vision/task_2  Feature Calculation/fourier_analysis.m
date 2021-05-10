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
figure;
transformed_img = log(1+abs(f));
imshow(transformed_img,[]); colormap(jet); colorbar;


%Radius can be anything but do all intesitiy going from 0 to pi until you
%reach end of image plot on graph
%angle 
transformed_img_log = log(transformed_img);

vector_S_r= [];

for r = 0:127
    S_r = 0;
    for theta = 0:-1:-180
    theta = deg2rad(theta);
    [x, y] = pol2cart(theta, r);
    x = round(x + 128); %Half of the image length
    y = round(y + 128);
    S_r = S_r + transformed_img_log(x, y);
    %break
    end
    vector_S_r = [vector_S_r; S_r];
    %break
end
% close all
% vector_S_r
figure('Name', 'Function of S(r)')
plot(log(vector_S_r))
xlabel('Radius (in terms of pixels)')
ylabel('Frequency distribution across Theta')

%Theta but in radius
vector_S_theta = [];
count = 0;
for theta = 0:-1:-180
    theta = deg2rad(theta);
    S_theta = 0;
    for r = 0:127
        [x,y] = pol2cart(theta, r);
        x = round(x + 128); %Half of the image length
        y = round(y + 128);
        S_theta = S_theta + transformed_img_log(x, y);       
    end
    vector_S_theta = [vector_S_theta; S_theta];
    count = count + 1;
end
figure('Name', 'Function of S(theta)')
plot(log(vector_S_theta))
xlabel('Radius (in terms of pixels)')
ylabel('Frequency distribution across Theta')

