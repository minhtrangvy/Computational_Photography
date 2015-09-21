%% Clean up
% open "extra" windows.
clear all
close all


%% Variables
input_dir = '/Users/minhtrangvy/Documents/School/zFall_2015/CS181M/experiment_02/office/';
output_dir = '/Users/minhtrangvy/Documents/School/zFall_2015/CS181M/experiment_02/';
input_file_ext = 'pgm';
output_file_ext = 'tif';
files = dir([input_dir '*.' input_file_ext]);


%% Iterate over all files
for file = files'
    % Read in the current image
    file_name = file.name;
    I = im2double(imread([input_dir file_name]));
    [height, width] = size(I);
    
    % Create masks for each color channel
    R_mask = zeros(size(I));
    R_mask(1:2:end,1:2:end) = 1;
    B_mask = circshift(R_mask, [1,1]);
    G_mask = circshift(R_mask + B_mask, [1, 0]);

    % Extract the three color channels
    R = I .* R_mask;
    G = I .* G_mask;
    B = I .* B_mask;

    % Demosaic using nearest-neighbor algorithms
    [nnR, nnG, nnB] = nearestNeighborDemosaic(R,G,B);
    J = cat(3, nnR, nnG, nnB);

    % Demosaic using bilinear interpolation
    [biR, biG, biB] = bilinear_interpolation_demosaic(R,G,B);
    K = cat(3, biR, biG, biB);
    
    % Write image as a color tif
    imwrite(J, [output_dir file_name(1:end-3) output_file_ext]);
    imwrite(K, [output_dir file_name(1:end-4) '_bilinear.' output_file_ext]);
end
