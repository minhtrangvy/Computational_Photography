%% Project 3: Homographies
% Part 1: Homography

%% Clean up
clear all
close all

% %% Take in the images and grab the grey of them
% input_dir = '/Users/minhtrangvy/Documents/MATLAB/Computational_Photography/Homographies/atrium/';
% input_file_ext = 'JPG';
% files = dir([input_dir '*.' input_file_ext]);
% 
% for grey_image = 1:length(files)
%     current_name = files(grey_image).name;
%     current_image = im2double(imread([input_dir current_name]));
%     images{grey_image} = current_image(:,:,2);
% end
% 
% for peripheral_image = 2:length(files)
%     cpselect(images{peripheral_image},images{1}) % ..., 'Wait', true)
% end

load('atrium_saved_variables')
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
x1_2 = fixedPoints(:,1);
y1_2 = fixedPoints(:,2);
x2_2 = movingPoints(:,1);
y2_2 = movingPoints(:,2);
H{3} = computeHomography(x1_2,y1_2,x2_2,y2_2);

x_values = [];
y_values = [];
for current_image = 1:num_of_images
    [h, w] = size(images{current_image});
    x_limits = [1;w];
    y_limits = [1;h];
    [new_x, new_y] = applyHomography(inv(H{current_image}),x_limits,y_limits);
    x_values = [x_values, new_x];
    y_values = [y_values, new_y];
end

[X, Y] = meshgrid(min(x_values):max(x_values), min(y_values):max(y_values));

mosaic = cell(num_of_images);
for j = 1:num_of_images
    image_j = images{j};
    [meshX, meshY] = applyHomography(H{j},X,Y);
    meshX = reshape(meshX, size(X));
    meshY = reshape(meshY, size(Y));
%     mosaic_pieces{j} = reshape(interp2(image_j, meshX, meshY, '*cubic'), [size(X),3]);
    mosaic_pieces{j} = interp2(image_j, meshX, meshY, '*cubic');
end

mosaic = zeros(size(mosaic_pieces{1}));
for this_image = 1:num_of_images
    current_image = mosaic_pieces{this_image};
    [currentH, currentW] = size(current_image);
    valid_pixels = ~isnan(mosaic_pieces{this_image});
    mosaic(valid_pixels) = mosaic_pieces{this_image}(valid_pixels);
end
% for i = 1:num
%     I = images{i};
%    [newX,newY] = applyHomography(H{i},X,Y);
%    warpedImages{i}(:,:,1) = interp2(I(:,:,1),newX,newY,'*cubic');
%    warpedImages{i} = reshape(warpedImages{i}(:,:,:),[size(X),3]);
% end
% 
% J = zeros(size(warpedImages{1}));
% for j = 1:num
%     useable = ~isnan(warpedImages{j});
%     J(useable) = warpedImages{j}(useable);
%     
% end
figure
show(mosaic)