%% Project 3: Homographies
% Part 1: Homography

%% Clean up
clear all
close all

%% Load previously saved pair points
load('atrium_8_9_points')

%% Take in the images and grab the grey of them
input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Homographies/atrium/';
input_file_ext = 'JPG';
files = dir([input_dir '*.' input_file_ext]);

for grey_image = 1:length(files)
    current_name = files(grey_image).name;
    current_image = im2double(imread([input_dir current_name]));
    current_image = imresize(current_image,0.1);
    images{grey_image} = rgb2gray(current_image);
end

% for peripheral_image = 2:length(files)
%     cpselect(images{peripheral_image},images{1}) % ..., 'Wait', true)
% end

%% Compute homographies
num_of_images = length(images);
H = cell(1,2);
H{1} = eye(3);
movingPoints = cpcorr(movingPoints,fixedPoints,images{2},images{1});
x1 = fixedPoints(:,1);
y1 = fixedPoints(:,2);
x2 = movingPoints(:,1);
y2 = movingPoints(:,2);
H{2} = computeHomography(x1,y1,x2,y2);
movingPoints2 = cpcorr(movingPoints2,fixedPoints2,images{3},images{1});
x1_2 = fixedPoints2(:,1);
y1_2 = fixedPoints2(:,2);
x2_2 = movingPoints2(:,1);
y2_2 = movingPoints2(:,2);
H{3} = computeHomography(x1_2,y1_2,x2_2,y2_2);


%% Find the max and min coordinates of the mosaic
x_values = [];
y_values = [];
for current_image = 1:num_of_images
    [h, w] = size(images{current_image});
    x_limits = [1;w;1;w];
    y_limits = [h;h;1;1];
    [new_x, new_y] = applyHomography(inv(H{current_image}),x_limits,y_limits);
    x_values = [x_values, new_x];
    y_values = [y_values, new_y];
end

min_X = min(x_values);
min_Y = min(y_values);
max_X = max(x_values);
max_Y = max(y_values);

[X, Y] = meshgrid(min_X(2):max_X(2), min_Y(2):max_Y(3));
% [X, Y] = meshgrid(-50:400, -200:310);
mesh_width = max_X(2) - min_X(2);
mesh_height = max_Y(3) - min_Y(2);

%% Apply homography to all images
mosaic = cell(num_of_images);
for j = 1:num_of_images
    image_j = images{j};
    [meshX, meshY] = applyHomography(H{j},X,Y);
    mosaic_pieces{j} = interp2(image_j, meshX, meshY);
%     figure
%     imshow(mosaic_pieces{j})
%     title(['mosaic piece ', j])
end

mosaic = zeros(size(mosaic_pieces{1}));
gaussian_filter = fspecial('gaussian', [30 30], 30);

for this_image = 1:num_of_images

    %Creating alpha masks for each image
    alpha_masks{this_image} = ~isnan(mosaic_pieces{this_image});
    
    %Blur the masks
    blurred_masks{this_image} = imfilter(im2double(alpha_masks{this_image}), gaussian_filter);
    
    % Getting rid of pixels that weren't there before
    clean_blurred_masks{this_image} = alpha_masks{this_image} .* blurred_masks{this_image};

%     figure
%     imshow(valid_pixels{this_image})
%     title(['valid pixels ', this_image])
%     
%     figure
%     imshow(blurred_masks{this_image})
%     title(['blurred pixels ', this_image])

    figure
    imshow(clean_blurred_masks{this_image})
    title(['cleaned blurred masks ', this_image])
%     
end

%% Blending
total_of_all_masks = clean_blurred_masks{1} + clean_blurred_masks{2} + clean_blurred_masks{3};
for mask = 1:num_of_images
    % Normalize all the blurred masks
    clean_blurred_masks{mask} = clean_blurred_masks{mask} ./ total_of_all_masks;
    
    % Multiply with the images
    mosaic_pieces{mask} = mosaic_pieces{mask} .* clean_blurred_masks{mask};
    
    figure
    imshow(clean_blurred_masks{mask})
    title(['cleaned normalized masks ', this_image])
    
    figure
    imshow(mosaic_pieces{mask})
    title(['blurred mosaic pieces ', this_image])
end

for final_mosaic = 1:num_of_images
    current_mask = clean_blurred_masks{final_mosaic};
    mosaic(logical(current_mask)) = mosaic_pieces{final_mosaic}(logical(current_mask));
end

%% Final result
figure
imshow(mosaic)
title('final image')