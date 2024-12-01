function [binary_image, thresh] = Median_threshold(img)
    [rows,cols] = size(img);
    binary_image = zeros(rows,cols);
    vectorImg = reshape(img,1,rows*cols);
    thresh = median(vectorImg);
    for r = 1:rows
        for c = 1:cols
            if (img(r,c)>thresh)
                binary_image(r,c) = 1;
            end
        end
    end

end
