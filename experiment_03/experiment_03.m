%% Clean up
% open "extra" windows.
clear all
close all

%% Variables
input_dir = '/Users/minhtrangvy/Documents/School/zFall_2015/CS181M/experiment_03/1600_1/';
output_dir = '/Users/minhtrangvy/Documents/School/zFall_2015/CS181M/experiment_03/';
input_file_ext = 'tiff';
output_file_ext = 'tiff';
files = dir([input_dir '*.' input_file_ext]);
file_name = files(1).name; 
I = im2double(imread([input_dir file_name]));
OG = I(:,:,2);                 %OG = original green lol
averageI = zeros(size(OG));

%% Iterate over all files and add the values of each cell to the averaged_I
for file = files'
    
    % Read in the current image
    file_name = file.name;
    currentI = im2double(imread([input_dir file_name]));

    % Extract the green color channels
    currentG = currentI(:,:,2);
    averageI = averageI + currentG;
    
end

% Divide each pixel by the num of files
numOfFiles = size(files);
numOfFiles = numOfFiles(1);
averageI = averageI / numOfFiles;

noise = OG - averageI;
histogram(noise);