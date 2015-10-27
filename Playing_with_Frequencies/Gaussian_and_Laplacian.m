%% Project 2: Fun with Frequencies
% Part 3: Gaussian and Laplacian Pyramids

%% Clean up
clear all
close all

%% Take in the two images
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies/';
input_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

I_name = files(1).name; 
I = im2double(imread([input_dir I_name]));

%% Grab the mask
% Green
I = I(:,:,2);

%% Create an array of all the gaussian filtered images
levels_of_stack = 5;
sigma = 2;
figure
for x = 1:levels_of_stack
    gaussian_filter = fspecial('gaussian', [20 20], sigma);
    array_of_Gaussians(:,:,x) = imfilter(I,gaussian_filter);
    sigma = sigma*2;
   
    subplot(1,5,x)
    imshow(array_of_Gaussians(:,:,x))
    title(['Gaussian at level ' num2str(x) ' and sigma is ' num2str(sigma)])
end

%% Create an array of laplacian filtered images
M = size(array_of_Gaussians);
M = M(3);

figure
for y = 1:(M-1)
    array_of_Laplacians(:,:,y) = array_of_Gaussians(:,:,y) - array_of_Gaussians(:,:,y+1);
    subplot(1,5,y)
    imshow(mat2gray(array_of_Laplacians(:,:,y)))
    title(['Laplacian: G' num2str(y) ' - G' num2str(y+1)])
end
array_of_Laplacians(:,:,M) =  array_of_Gaussians(:,:,M);
subplot(1,5,5)
imshow(array_of_Laplacians(:,:,M))
title(['Laplacian: G' num2str(M)]) 