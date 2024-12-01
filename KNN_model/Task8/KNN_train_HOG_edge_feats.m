clc;
clear all;

parentFolder = "C:\Users\chint\OneDrive - IIT Hyderabad\Documents\NUS\ME5405-Machine_vision\Prj_grp_22\KNN_model";
samples = {'sampleH', 'sampleE', 'sampleL', 'sampleO',...
    'sampleW', 'sampleR', 'sampleD'};

master_matrix = [];
class_labels = [];

for i = 1:length(samples)
    sampleFolder = fullfile(parentFolder, 'p_dataset_26', samples{i});
    imageFiles = dir(fullfile(sampleFolder, 'img*.png')); 
    numImages = length(imageFiles);
    disp("The current sample:");
    display(samples{i});
    sampleMatrix = zeros(0.75*numImages, 1168);
    for j = 1:0.75*numImages
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
        sampleMatrix(j,:) = [hog_features, edge_features];
    end
    master_matrix = [master_matrix; sampleMatrix];
    labels = i * ones(size(sampleMatrix, 1), 1);
    class_labels = [class_labels; labels];
end

size(master_matrix)
size(class_labels)

save("Trained_data_hog.mat",'master_matrix','class_labels');