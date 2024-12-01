clc;
clear all;

parentFolder = "C:\Users\chint\OneDrive - IIT Hyderabad\Documents\NUS\ME5405-Machine_vision\Prj_grp_22\KNN_model";
samples = {'sampleH', 'sampleE', 'sampleL', 'sampleO',...
    'sampleW', 'sampleR', 'sampleD'};

validation_matrix = [];
actual_labels = [];

for i = 1:length(samples)
    sampleFolder = fullfile(parentFolder, 'p_dataset_26', samples{i});
    imageFiles = dir(fullfile(sampleFolder, 'img*.png')); 
    numImages = length(imageFiles);
    disp("The current sample:");
    display(samples{i});
    sampleMatrix = zeros(0.25*numImages, 1168);
     for j = 0.75*numImages+1:numImages
        disp(j);
        imagePath = fullfile(sampleFolder, imageFiles(j).name);
        img = imread(imagePath);
        resized_image = imresize(img, [32, 32], 'bicubic');
        binary_image = imbinarize(resized_image);

        % using HOG features:
        %hog_features = extractHOGFeatures(binary_image, 'CellSize', [8, 8]);
        hog_features = custom_hog(binary_image);
        % using edge based features
        edges = edge(binary_image, 'Canny');
        edge_features = edges(:)';

        %combining both feats:
        row_index = j - 762;
        sampleMatrix(row_index,:) = [hog_features, edge_features];
     end
     validation_matrix = [validation_matrix; sampleMatrix];
     labels = i * ones(size(sampleMatrix, 1), 1);
     actual_labels = [actual_labels; labels];
end
size(validation_matrix)
size(actual_labels)

save('Validation_data_hog.mat', 'validation_matrix', 'actual_labels');