clear all;
clc;

wd = "C:\Users\chint\OneDrive - IIT Hyderabad\Documents\NUS\ME5405-Machine_vision\Prj_grp_22\KNN_model\predict\image2";

sample = {'H', 'E', 'L', 'O', 'W', 'R', 'D'};
k=3;
predicted_label = zeros(length(sample),1);
for i =1:length(sample)
   imagePath = fullfile(wd, sample{i} + ".png");
   img = imread(imagePath);
   predicted_label(i,1) = predict_knn(img,k);
end

predicted_label

% labels are H - 1; E - 2; L - 3; O - 4; W - 5; R - 6; D - 7