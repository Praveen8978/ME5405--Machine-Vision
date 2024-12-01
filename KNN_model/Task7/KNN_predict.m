clear all;
clc

%% Predictions

load("Trained_data.mat",'master_matrix', 'precomputed_norms', 'class_labels');
load('Validation.mat', 'Validation_matrix', 'actual_labels');

k = 3;
predicted_labels = zeros(size(Validation_matrix, 1), 1);

for i = 1:size(Validation_matrix, 1)
    query_vector = Validation_matrix(i, :);
    distances = sqrt(precomputed_norms + sum(query_vector.^2) - 2 * (master_matrix * query_vector'));
    % finding k nearest neighbours
    [~, indices] = mink(distances, k);

    nearest_labels = class_labels(indices);
    predicted_class = mode(nearest_labels);
    predicted_labels(i) = predicted_class;
end

% calculating Accuracy

accuracy = mean(predicted_labels == actual_labels) * 100

