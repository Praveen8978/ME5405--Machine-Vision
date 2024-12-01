clc;
clear all;

samples = {'H', 'E', 'L', 'O', 'W', 'R', 'D'};
samples_image_1 = {'E', 'H', 'L', 'O'};

%change this directory to image1 to check for bonus task
wd = "C:\Users\chint\OneDrive - IIT Hyderabad\Documents\NUS\" + ...
    "ME5405-Machine_vision\Prj_grp_22\KNN_model\predict\image2";

test_matrix = [];
actual_labels = [1 2 3 4 5 6 7]'; % change actual labels to [2 1 3 4]' for bonus task

%replace samples with samples_image_1 in this loop to check for bonus task 
for i = 1:length(samples)
    imagePath = fullfile(wd, samples{i} + ".png");
    img = imread(imagePath);
    smoothed_image = medfilt2(rgb2gray(img), [3, 3]); %median filter to
    % smooth image
    resized_image = imresize(smoothed_image, [32, 32], 'bicubic');
    binary_image = imbinarize(resized_image);

    % hog features and edge features extraction
    %hog_features = extractHOGFeatures(binary_image, 'CellSize', [8, 8]);
    hog_features = custom_hog(binary_image);
    edges = edge(binary_image, 'Canny');
    edge_features = edges(:)';
    combined_features = [hog_features, edge_features];
    
    test_matrix = [test_matrix; combined_features];    
end

%% testing
load("Trained_data_hog.mat",'master_matrix','class_labels');

k = 7;
predicted_labels = zeros(size(test_matrix, 1), 1);
for i = 1:size(test_matrix, 1)
    query_vector = test_matrix(i, :);
    distances = sum(abs(master_matrix - query_vector), 2);
    [~, indices] = mink(distances, k);

    nearest_labels = class_labels(indices);
    predicted_class = mode(nearest_labels);
    predicted_labels(i) = predicted_class;

end

accuracy = mean(predicted_labels == actual_labels) * 100
predicted_labels
% labels are H - 1; E - 2; L - 3; O - 4; W - 5; R - 6; D - 7
