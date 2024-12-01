clc;
clear all;

parentFolder = "C:\Users\chint\OneDrive - IIT Hyderabad\Documents\NUS\ME5405-Machine_vision\Prj_grp_22\KNN_model";
samples = {'sampleH', 'sampleE', 'sampleL', 'sampleO',...
    'sampleW', 'sampleR', 'sampleD'};
%% Validation

% read image
% do similar pre processing
% we'll have for each class - 254x100 matrix
% combine all of them as train data and have their labels as well!
% predict using KNN - store them also as matrix similar to class_labels
% 1778x1 is the predicted class_labels and actual class labels
% find accuracy by creating a boolean based on predicted == actual class
% labels
Validation_data = struct();
for i = 1:length(samples)
    sampleFolder = fullfile(parentFolder, 'p_dataset_26', samples{i});
    imageFiles = dir(fullfile(sampleFolder, 'img*.png')); 
    numImages = length(imageFiles);
    disp("The current sample:");
    display(samples{i});
    sampleMatrix = zeros(0.25*numImages, 128*128);

    for j = 0.75*numImages+1:numImages
        disp(j);
        imagePath = fullfile(sampleFolder, imageFiles(j).name);
        img = imread(imagePath);
        bimg = imbinarize(img);
        
        %flatten the image to an array
        temp = bimg(:)';
        row_index = j - 762;
        sampleMatrix(row_index, :) = temp;          
    end
    
    % applying PCA to reduce dimensionality
    % num_components = 253; % no. of feats post reduction
    % [coeff, score, ~] = pca(sampleMatrix); 
    % reduced_features = score(:, 1:num_components); 
    
    Validation_data.(samples{i}) = sampleMatrix;
end

Validation_matrix = [];
actual_labels = [];

for i = 1:length(samples)
    class_matrix = Validation_data.(samples{i});
    
    % Append the class matrix to the master matrix
    Validation_matrix = [Validation_matrix; class_matrix];
    
    % Generate class labels and append them
    labels = i * ones(size(class_matrix, 1), 1);
    actual_labels = [actual_labels; labels];
end

% Save the struct to a .dat file
save('Validation.mat', 'Validation_matrix', 'actual_labels');
