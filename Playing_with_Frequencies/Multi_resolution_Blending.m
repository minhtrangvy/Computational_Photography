%% Project 2: Fun with Frequencies
% Part 4: Multi-resolution Blending

%% Clean up
clear all
close all

%% Take in the two images
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Playing_with_Frequencies/';
input_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

A_name = files(1).name; 
B_name = files(3).name;
A = im2double(imread([input_dir A_name]));
B = im2double(imread([input_dir B_name]));
A = A(:,:,2);
B = B(:,:,2);

%% Create the masks for the left and right halves
[vsz, hsz] = size(A);
half_hsz = hsz/2;
one_mask = ones(vsz,half_hsz);
zero_mask = zeros(vsz,half_hsz);
mask = cat(2,one_mask, zero_mask);

% size(A)
% size(B)
% size(mask)

%% Build gaussian pyramids for A, B, and left and right masks
levels_of_stack = 5;
sigma = 3;
gaussians_A = cell(1,levels_of_stack);
gaussians_B = cell(1,levels_of_stack);
gaussians_mask = cell(1,levels_of_stack);

for x = 1:levels_of_stack
    gaussian_filter = fspecial('gaussian', [20 20], sigma);
    gaussians_A{1,x} = imfilter(A,gaussian_filter);
    gaussians_B{1,x} = imfilter(B,gaussian_filter);
    gaussians_mask{1,x} = imfilter(mask,gaussian_filter);
    sigma = sigma*2;
end

%% Build lapacian pyramids for A, B, and left and right masks
M = size(gaussians_A);
M = M(2);
laplacians_A = gaussians_A;
laplacians_B = gaussians_B;
laplacians_mask = gaussians_mask;

for y = 1:(M-1)
    laplacians_A{1,y} = gaussians_A{1,y} - gaussians_A{1,y+1};
    laplacians_B{1,y} = gaussians_B{1,y} - gaussians_B{1,y+1};
    laplacians_mask{1,y} = gaussians_mask{1,y} - gaussians_mask{1,y+1};
end
laplacians_A{1,M} =  gaussians_A{1,M};
laplacians_B{1,M} =  gaussians_B{1,M};
laplacians_mask{1,M} =  gaussians_mask{1,M};

% size(laplacians_A{1,1})
% size(laplacians_B{1,1})
% size(laplacians_mask{1,1})

figure
for x = 1:levels_of_stack
    subplot(1,5,x)
    imshow(gaussians_A{1,x})
end

figure
for x = 1:levels_of_stack
    subplot(1,5,x)
    imshow(gaussians_B{1,x})
end

figure
for x = 1:levels_of_stack
    subplot(1,5,x)
    imshow(gaussians_mask{1,x})
end

figure
for x = 1:levels_of_stack
    subplot(1,5,x)
    imshow(mat2gray(laplacians_A{1,x}))
end

figure
for x = 1:levels_of_stack
    subplot(1,5,x)
    imshow(mat2gray(laplacians_B{1,x}))
end

figure
for x = 1:levels_of_stack
    subplot(1,5,x)
    imshow(mat2gray(laplacians_mask{1,x}))
end

%% Combined pyramid
combined_laplacian = cell(1,levels_of_stack);
combined_gaussian = cell(1,levels_of_stack);

for l = 1:M
    combined_laplacian{1,l} = laplacians_mask{1,l}.*laplacians_A{1,l} + (1-laplacians_mask{1,l}).*laplacians_B{1,l};
    combined_gaussian{1,l} = gaussians_mask{1,l}.*gaussians_A{1,l} + (1-gaussians_mask{1,l}).*gaussians_B{1,l};
end

%% Expand? and sum layers
finished = zeros(vsz,hsz);
for k = 1:M
    finished = finished + combined_laplacian{1,k};
end
% finished = finished + combined_gaussian{1,M};

% figure
% imshow(finished)