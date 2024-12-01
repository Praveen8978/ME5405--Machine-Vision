function predicted_class = predict_knn(img, k)
    %samples = {'sampleH', 'sampleE', 'sampleL', 'sampleO',...
    %'sampleW', 'sampleR', 'sampleD'};

    load("Trained_data.mat",'master_matrix', 'precomputed_norms', 'class_labels');
    
    img = imresize(img, [128, 128], 'bicubic');
    gray_img = rgb2gray(img);
    bimg = imbinarize(gray_img);
    query_vector = bimg(:)';
    distances = sqrt(precomputed_norms + sum(query_vector.^2) - 2 * (master_matrix * query_vector'));
    
    % finding k nearest neighbours
    [~, indices] = mink(distances, k);

    nearest_labels = class_labels(indices);
    predicted_class = mode(nearest_labels);

    %predicted_letter = samples{predicted_class};
    
end


