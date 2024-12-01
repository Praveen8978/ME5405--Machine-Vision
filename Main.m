clc;
clear all;
close all;
%% Image 1 - Task 1
% need to have the image in the same directory
image1 = imread("HELLO.jpg");
figure(1);
imshow(image1);

% converting to gray scale
image1_gray = color2gray(image1);
figure(2);
imshow(image1_gray);

% contrast enhancement
stretch1 = contrast_stretch(image1_gray, 0, 255);
stretch2 = contrast_stretch(image1_gray, 40, 200);
stretch3 = contrast_stretch(image1_gray, 80, 150);
figure(3);
subplot(1, 3, 1);
imshow(stretch1);
subplot(1, 3, 2);
imshow(stretch2);
subplot(1, 3, 3);
imshow(stretch3);

%% Image 1 - Task 2

nn_rotation = rot_img_nn(image1_gray, 2);
linear_rotation = rot_img_bilinear(image1_gray, 2);
bicubic_rotation = rot_img_bicubic(image1_gray, 2);

figure(4);
subplot(1, 3, 1);
imshow(nn_rotation);
subplot(1, 3, 2);
imshow(linear_rotation);
subplot(1, 3, 3);
imshow(imrotate(image1_gray, -2, 'bicubic'));

%% Image 1 - Task 3

img=imread('HELLO.jpg');
filter3x3=fspecial('average',[3 3]);
smoothedImg3x3=imfilter(img,filter3x3);
filter5x5=fspecial('average',[5 5]);
smoothedImg5x5=imfilter(img,filter5x5);
filter7x7=fspecial('average',[7 7]);
smoothedImg7x7=imfilter(img,filter7x7);
filter9x9=fspecial('average',[9 9]);
smoothedImg9x9=imfilter(img,filter9x9);
figure;
subplot(2,3,1),imshow(img),title('original figure');
subplot(2,3,2),imshow(smoothedImg3x3),title('3x3');
subplot(2,3,3),imshow(smoothedImg5x5),title('5x5');
subplot(2,3,4),imshow(smoothedImg7x7),title('7x7');
subplot(2,3,5),imshow(smoothedImg9x9),title('9x9');

%% Image 1 - Task 4

% Load and display original image
image = imread('Hello.jpg');

% Convert to grayscale
gray_image = rgb2gray(image);

% Contrast enhancement using histogram equalization
enhanced_image = histeq(gray_image);

%4. Compute the 2D Fourier Transform of the image
F = fft2(double(gray_image));
Fshift = fftshift(F);

% Create a ideal high-pass filter
[M, N] = size(gray_image);
[X, Y] = meshgrid(1:N, 1:M);
centerX = round(N/2);
centerY = round(M/2);
D0 = 30; % Cutoff frequency; adjust as needed
H_ideal = double(sqrt((X - centerX).^2 + (Y - centerY).^2) > D0);

% Apply the filter and inverse transform
filtered_F_ideal = Fshift .* H_ideal;
filtered_image_ideal = ifft2(ifftshift(filtered_F_ideal));
filtered_image_ideal = abs(filtered_image_ideal);
figure, imshow(uint8(filtered_image_ideal)), title('Ideal High-Pass Filtered Image');


% create butterworth high-pass filter
n = 10; % The higher the value of the order, the more obvious the filter overstep
H_butterworth = 1 ./ (1 + (D0 ./ sqrt((X - centerX).^2 + (Y - centerY).^2)).^(2*n));

% Apply the filter
filtered_F_butterworth = Fshift .* H_butterworth;

% inverse fourier transform
filtered_image_butterworth = ifft2(ifftshift(filtered_F_butterworth));
filtered_image_butterworth = abs(filtered_image_butterworth);
figure, imshow(uint8(filtered_image_butterworth)), title('Butterworth High-Pass Filtered Image');


% Create a Gauss high-pass filter
H_gaussian = 1 - exp(-((X - centerX).^2 + (Y - centerY).^2) / (2 * (D0^2)));

% Apply the filter
filtered_F_gaussian = Fshift .* H_gaussian;

% inverse fourier transform
filtered_image_gaussian = ifft2(ifftshift(filtered_F_gaussian));
filtered_image_gaussian = abs(filtered_image_gaussian);
figure, imshow(uint8(filtered_image_gaussian)), title('Gaussian High-Pass Filtered Image');

%% Image 1 - Task 5

strt_img = linear_rotation(41:end-40, 41:end-40);
bimg = otsu_threshold(strt_img); % uses otsu thresholding
bimg_comp = imcomplement(bimg);

[labelImg, numLabel] = bwlabel(bimg_comp);
props = regionprops(labelImg, "BoundingBox");
characterImages = cell(numLabel, 1);
for j = 1:numLabel
    boundingBox = round(props(j).BoundingBox);
    cropped_image = imcrop(bimg_comp, boundingBox);

    characterImages{j} = cropped_image;
    figure; 
    imshow(cropped_image); %title(['Character ' num2str(j)]);
end

%% Image 2 - Task 1,2 & 3
%1. Load and display the original image
image2 = imread('hello_world.jpg');
figure, imshow(image2), title('Original Image');

%2. Determine the region of interest (ROI) for the middle line.
row_start = 100;  
row_end = 150;   
col_start = 5;   
col_end = 450;  

%3. Extract the sub-image
sub_image = image2(row_start:row_end, col_start:col_end, :);
figure, imshow(sub_image), title('Middle Line - HELLO, WORLD');

% Convert the sub-image to grayscale
gray_sub_image = color2gray(sub_image);

% Apply a threshold to convert the grayscale image to binary
binary_image = constant_threshold(gray_sub_image, 130);
% Display the binary image
figure, imshow(binary_image), title('Binary Image of HELLO, WORLD');

%% Image 2 Task 4
bimg = binary_image;
[m, n] = size(bimg);            
img = padarray(bimg, [1 1], 0);  
 en = 0;  
[obj_row,obj_col] = find(bimg== 1);

while en ~= 1 
        tmp_img = img;

for p = 2:length(obj_row)
            rand_array = randperm(length(obj_row));
            i = obj_row(rand_array(1));
            j = obj_col(rand_array(1));
            if i == 1 || i == m
                continue
            elseif j == 1 || j == n
                continue
            end

            core_pixel  = [img(i,j)     img(i-1,j)   img(i-1,j+1) ...
                           img(i,j+1)   img(i+1,j+1) img(i+1,j)   ...
                           img(i+1,j-1) img(i,j-1)   img(i-1,j-1) ... 
                           img(i-1,j)];
 
            A_P1 = 0;    % value change times
            B_P1 = 0;    % non zero neighbors
            for k = 2:9
                if core_pixel (k) < core_pixel (k+1)
                    A_P1 = A_P1 + 1;
                end
                if core_pixel (k) == 1
                    B_P1 = B_P1 + 1;
                end
            end

if ((core_pixel(1) == 1)                                    &&...
                   (A_P1 == 1)                                          &&...
                   ((B_P1 >= 2) && (B_P1 <= 6))                         &&...
                   (core_pixel(2) * core_pixel(4) * core_pixel(6) == 0) &&...
                   (core_pixel(4) * core_pixel(6) * core_pixel(8) == 0))
               img(i, j) = 0;
            end
        end
        
        en = isequal(tmp_img, img);
        if en      
           break
        end

tmp_img = img;      
        for p = 2:length(obj_row)
 
            rand_array=randperm(length(obj_row));
            i = obj_row(rand_array(1));
            j = obj_col(rand_array(1));
 
            if i== 1 || i == m
                continue
            elseif j==1 || j== n
                continue
            end
 
            core_pixel  = [img(i,j)     img(i-1,j)   img(i-1,j+1) ...
                           img(i,j+1)   img(i+1,j+1) img(i+1,j)   ...
                           img(i+1,j-1) img(i,j-1)   img(i-1,j-1) ... 
                           img(i-1,j)];
A_P1 = 0;
            B_P1 = 0;
            for k = 2:9
                if core_pixel (k) < core_pixel (k+1)
                    A_P1 = A_P1 + 1;
                end
                if core_pixel (k) == 1
                    B_P1 = B_P1 + 1;
                end
            end
 
            if ((core_pixel(1) == 1)                                    &&...
                   (A_P1 == 1)                                          &&...
                   ((B_P1 >= 2) && (B_P1 <= 6))                         &&...
                   (core_pixel(2) * core_pixel(4) * core_pixel(8) == 0) &&...
                   (core_pixel(2) * core_pixel(6) * core_pixel(8) == 0))
               img(i, j) = 0;
            end
        end
        
        en = isequal(tmp_img, img);
        if en      
           return
        end
end
 
    img_thinned = [m,n];
    img = 1 - img;
    for i = 2:m+1
        for j = 2:n+1
            img_thinned(i-1, j-1) = img(i,j);
        end
    end
figure, imshow(img_thinned,'InitialMagnification','fit');

%% Image 2 - Task 5 & 6

image=imread("hello_world.jpg");
row_start = 100; 
row_end = 170;
col_start = 5;
col_end = 440;
subImage = image(row_start:row_end, col_start:col_end, :);
gray_subImage = rgb2gray(subImage);
threshold = 130;
binary_image = gray_subImage > threshold;
se=strel("square",3);
erodedimg=imerode(binary_image,se);
bImgBdry=binary_image&~erodedimg;
imshow(bImgBdry);


image=imread("hello_world.jpg");
row_start = 100; 
row_end = 170;
col_start = 5;
col_end = 440;
subImage = image(row_start:row_end, col_start:col_end, :);
gray_subImage = rgb2gray(subImage);
threshold = 130;
bimg = gray_subImage > threshold;
[labelImg, numLabel] = bwlabel(bimg); 
props = regionprops(labelImg, "BoundingBox"); 
characterImages = cell(numLabel, 1); 
padding = 4;
for j = 1:numLabel
    boundingBox = round(props(j).BoundingBox);
    boundingBox(1) = boundingBox(1) - padding; 
    boundingBox(2) = boundingBox(2) - padding;  
    boundingBox(3) = boundingBox(3) + 2*padding; 
    boundingBox(4) = boundingBox(4) + 2*padding; 
    boundingBox = max(boundingBox, 1);
    cropped_image = imcrop(bimg, boundingBox);
    characterImages{j} = cropped_image;
[~, idx] = sort(arrayfun(@(x) x.BoundingBox(1), props));
props = props(idx);
    figure;
    imshow(cropped_image);
    title(["Character" num2str(j)]);
end

%% Image 2 Task 7 & 8
% find it in the knn subfolder in this folder











