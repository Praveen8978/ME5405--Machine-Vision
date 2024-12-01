clc;
clear all;

load("Trained_data_hog.mat",'master_matrix','class_labels');
load('Validation_data_hog.mat', 'validation_matrix', 'actual_labels');

k = 7;
predicted_labels = zeros(size(validation_matrix, 1), 1);

for i = 1:size(validation_matrix, 1)
    query_vector = validation_matrix(i, :);
    distances = sum(abs(master_matrix - query_vector), 2);
    [~, indices] = mink(distances, k);

    nearest_labels = class_labels(indices);
    predicted_class = mode(nearest_labels);
    predicted_labels(i) = predicted_class;

end

accuracy = mean(predicted_labels == actual_labels) * 100