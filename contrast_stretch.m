function high_contr_img = contrast_stretch(img, new_Min, new_Max)
[row, col] = size(img);
intensityMin = min(img(:));
intensityMax = max(img(:));
alpha = (new_Max - new_Min) / double(intensityMax - intensityMin);
beta = new_Min - alpha * double(intensityMin);
high_contr_img = zeros(row,col,'uint8');

for r = 1:row
    for c = 1:col
        high_contr_img(r,c) = round(alpha*double(img(r,c)) + beta);
        if (high_contr_img(r,c)>255)
                high_contr_img(r,c) = 255;
        end
        if (high_contr_img(r,c)<0)
                high_contr_img(r,c) = 0;
        end
    end
end
end
