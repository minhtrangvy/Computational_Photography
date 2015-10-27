%% Project 2: Fun with Frequencies
% Part 2: Hybrid frequency images

%% Clean up
clear all
close all

%% Take in the two images
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies/pomona/small/';
output_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies';
input_file_ext = 'JPG';
output_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

I1_name = files(3).name; 
I2_name = files(7).name;
I1 = im2double(imread([input_dir I1_name]));
I2 = im2double(imread([input_dir I2_name]));

%% Grab the mask
% Green
I1 = I1(:,:,2);
I2 = I2(:,:,2);

% figure
% subplot(1,2,1)
% imshow(I1)
% title('Original Image 1')
% subplot(1,2,2)
% imshow(I2)
% title('Original Image 2')

M1 = abs(fftshift(fft2(I1)));
M2 = abs(fftshift(fft2(I2)));

% figure
% subplot(1,2,1)
% imshow(M1)
% title('Magnitude of Original Image 1')
% subplot(1,2,2)
% imshow(M2)
% title('Magnitude of Original Image 2')

%% Filter images
gaussian1 = fspecial('Gaussian', [5 5], 10);
gaussian2 = fspecial('Gaussian', [300 300], 300);

% Low filter image 1
lowPassI1 = imfilter(I1,gaussian1);

% High filter image 2
lowPassI2 = imfilter(I2,gaussian2);
highPassI2 = I2 - lowPassI2;

figure
subplot(1,2,1)
imshow(lowPassI1)
title('Low Pass Filter on Image 1')
subplot(1,2,2)
imshow(highPassI2)
title('High Pass Filter on Image 2')

lowPassI1_M1 = abs(fftshift(fft2(lowPassI1)));
highPassI2_M2 = abs(fftshift(fft2(highPassI2)));

% figure
% subplot(1,2,1)
% imshow(lowPassI1_M1)
% title('Magnitude of Low Pass of Image 1')
% subplot(1,2,2)
% imshow(highPassI2_M2)
% title('Magnitude of High Pass of Image 2')

%% Hybrid image
% hybrid = imfuse(lowPassI1,highPassI2);
% hold on
% figure
% h = imshow(lowPassI1);
% title('Hybrid image')
% hold off
% set(h, 'AlphaData',highPassI2);

% [ysz xsz] = size(lowPassI1);
% 
% for xi = 1:xsz
%     for yi = 1:ysz
%         
%     end
% end
hybrid = (lowPassI1 + highPassI2)/2;

figure
imshow(hybrid)
title('Hybrid image')