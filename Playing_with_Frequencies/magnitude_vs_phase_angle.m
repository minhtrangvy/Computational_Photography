%% Project 2: Fun with Frequencies
% Part 1: Magnitude vs phase angle

%% Clean up
clear all
close all

%% Take in the two images
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies/pomona/small/';
output_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies';
input_file_ext = 'JPG';
output_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

I1_name = files(2).name; 
I2_name = files(4).name;
I1 = im2double(imread([input_dir I1_name]));
I2 = im2double(imread([input_dir I2_name]));

%% Grab the masks
% Red
I1_R = I1(:,:,1);
I2_R = I1(:,:,1);
% Green
I1_G = I1(:,:,2);
I2_G = I2(:,:,2);
% Blue
I1_B = I1(:,:,3);
I2_B = I2(:,:,3);

figure
subplot(1,2,1)
imshow(I1_G)
title('original image 1 green mask')
subplot(1,2,2)
imshow(I2_G)
title('original image 2 green mask')

%% Apply Fourier transforms on the two images
% Red
F1_R = fftshift(fft2(I1_R));
F2_R = fftshift(fft2(I2_R));
% Green
F1_G = fftshift(fft2(I1_G));
F2_G = fftshift(fft2(I2_G));
% Blue
F1_B = fftshift(fft2(I1_B));
F2_B = fftshift(fft2(I2_B));

%% Magnitures of the images1
% Red
M1_R = abs(F1_R);
M2_R = abs(F2_R);

% figure
% subplot(1,2,1)
% imshow(M1_R)
% title('Image 1 magnitude: red')
% subplot(1,2,2)
% imshow(M2_R)
% title('Image 2 magnitude: red')

% Green
M1_G = abs(F1_G);
M2_G = abs(F2_G);

% figure
% subplot(1,2,1)
% imshow(M1_G)
% title('Image 1 magnitude: green')
% subplot(1,2,2)
% imshow(M2_G)
% title('Image 2 magnitude: green')

% Blue
M1_B = abs(F1_B);
M2_B = abs(F2_B);

% figure
% subplot(1,2,1)
% imshow(M1_B)
% title('Image 1 magnitude: blue')
% subplot(1,2,2)
% imshow(M2_B)
% title('Image 2 magnitude: blue')

%% Phases of the images
% Red
P1_R = angle(F1_R);
P2_R = angle(F2_R);

% figure
% subplot(1,2,1)
% imshow(P1_R)
% title('Image 1 phase: red')
% subplot(1,2,2)
% imshow(P2_R)
% title('Image 2 phase: red')

% Green
P1_G = angle(F1_G);
P2_G = angle(F2_G);

% figure
% subplot(1,2,1)
% imshow(P1_G)
% title('Image 1 phase: green')
% subplot(1,2,2)
% imshow(P2_G)
% title('Image 2 phase: green')

% Blue
P1_B = angle(F1_B);
P2_B = angle(F2_B);

% figure
% subplot(1,2,1)
% imshow(P1_B)
% title('Image 1 phase: blue')
% subplot(1,2,2)
% imshow(P2_B)
% title('Image 2 phase: blue')

%% Generate new images from magnitude and phases
% Red
NewI1_R = M1_R .* exp(1i * P2_R);
NewI2_R = M2_R .* exp(1i * P1_R);
% Green
NewI1_G = M1_G .* exp(1i * P2_G);
NewI2_G = M2_G .* exp(1i * P1_G);
% Blue
NewI1_B = M1_B .* exp(1i * P2_B);
NewI2_B = M2_B .* exp(1i * P1_B);

% figure
% subplot(1,2,1)
% imagesc(log(1 + abs(NewI1_R)))
% title('Image 1 swapped recombinations: red')
% subplot(1,2,2)
% imagesc(log(1 + abs(NewI2_R)))
% title('Image 2 swapped recombinations: red')
% 
% figure
% subplot(1,2,1)
% imagesc(log(1 + abs(NewI1_G)))
% title('Image 1 swapped recombinations: green')
% subplot(1,2,2)
% imagesc(log(1 + abs(NewI2_G)))
% title('Image 2 swapped recombinations: green')
% 
% figure
% subplot(1,2,1)
% imagesc(log(1 + abs(NewI1_B)))
% title('Image 1 swapped recombinations: blue')
% subplot(1,2,2)
% imagesc(log(1 + abs(NewI2_B)))
% title('Image 2 swapped recombinations: blue')
