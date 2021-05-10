clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 18;
% Read in demo image.
% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'cameraman.tif';
fullFileName = fullfile(folder, baseFileName);
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
  % Didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
grayImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(grayImage);
% Display the original gray scale image.
subplot(2, 2, 1);
imshow(grayImage, [0 255]);
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off') 
% Let's compute and display the histogram.
[pixelCount grayLevels] = imhist(grayImage);
subplot(2, 2, 2); 
bar(pixelCount);
title('Histogram of Original Image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;
% Ask user for a number.
defaultValue = 7;
userPrompt = 'Enter the number of bits between 1 and 8';
caUserInput = inputdlg(userPrompt, 'Enter the threshold value',1,{num2str(defaultValue)});
integerValue = round(str2num(cell2mat(caUserInput)));
% Check for a valid integer.
if isempty(integerValue) || integerValue < 1 || integerValue > 8
    % They didn't enter a number.  
    % They entered a character, symbols, or something else not allowed.
    integerValue = defaultValue;
    message = sprintf('I said it had to be an integer between 1 and 8.\nI will use %d and continue.', integerValue);
    uiwait(warndlg(message));
end
% Reduce the number of bits.
reducedImage = uint8((single(grayImage)/256)*2^integerValue);
% Display the reduced bits gray scale image.
subplot(2, 2, 3);
imshow(reducedImage, [0 255]);
title('Reduced Bits Grayscale Image', 'FontSize', fontSize);
% Let's compute and display the histogram.
[pixelCount2 grayLevels2] = imhist(reducedImage);
subplot(2, 2, 4); 
bar(pixelCount2);
grid on;
title('Histogram of Reduced Bits Grayscale Image', 'FontSize', fontSize);
xlim([0 grayLevels2(end)]); % Scale x axis manually.