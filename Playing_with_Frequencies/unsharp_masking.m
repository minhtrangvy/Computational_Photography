%% Project 2: Fun with Frequencies
% Part 0: Unsharp masking
%    sharpen a gray scale images using the unsharp masking technique

%% Clean up
clear all
close all

%% Take in image and get the Green mask
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies/pomona/small/';
output_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies';
input_file_ext = 'JPG';
output_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);
file_name = files(2).name; 
I = im2double(imread([input_dir file_name]));
OG = I(:,:,2);                 %OG = original green lol

%% Create Gaussian filter
gaussianed = fspecial('Gaussian', [10 10], 20);
blurredG = imfilter(OG,gaussianed);
difference = OG - blurredG;
sharpenedImage = OG + difference;

%% Show the image
figure
subplot(1, 2, 1);
imshow(OG)
title('Original image')
subplot(1, 2, 2);
imshow(sharpenedImage)
title('sharpenedImage image')