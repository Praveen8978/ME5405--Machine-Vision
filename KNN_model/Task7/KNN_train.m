clear all;
clc;

parentFolder = "C:\Users\chint\OneDrive - IIT Hyderabad\Documents\NUS\ME5405-Machine_vision\Prj_grp_22\KNN_model";
samples = {'sampleH', 'sampleE', 'sampleL', 'sampleO',...
    'sampleW', 'sampleR', 'sampleD'};

reducedFeatureMatrices = struct();

for i = 1:length(samples)
    sampleFolder = fullfile(parentFolder, 'p_dataset_26', samples{i});
    imageFiles = dir(fullfile(sampleFolder, 'img*.png')); 
    numImages = length(imageFiles);
    disp("The current sample:");
    display(samples{i});
    sampleMatrix = zeros(0.75*numImages, 128*128);

    for j = 1:0.75*numImages
        disp(j);
        imagePath = fullfile(sampleFolder, imageFiles(j).name);
        img = imread(imagePath);
        bimg = imbinarize(img);
       
        %flatten the image to an array
        temp = bimg(:)';
        sampleMatrix(j, :) = temp;          
    end
    
    % applying PCA to reduce dimensionality
    % num_components = 253; % no. of feats post reduction
    % [coeff, score, ~] = pca(sampleMatrix); 
    % reduced_features = score(:, 1:num_components); 
    
    reducedFeatureMatrices.(samples{i}) = sampleMatrix;
end

master_matrix = [];
class_labels = [];

for i = 1:length(samples)
    class_matrix = reducedFeatureMatrices.(samples{i});
    
    % Append the class matrix to the master matrix
    master_matrix = [master_matrix; class_matrix];
    
    % Generate class labels and append them
    labels = i * ones(size(class_matrix, 1), 1);
    class_labels = [class_labels; labels];
end


precomputed_norms = sum(master_matrix.^2, 2);
% Save the struct to a .dat file
save('Trained_data.mat', 'master_matrix', 'precomputed_norms', 'class_labels');


