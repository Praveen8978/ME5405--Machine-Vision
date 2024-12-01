function binary_img = constant_threshold(img, th)
    [row,col] = size(img);
    binary_img = zeros(row,col);
    for r = 1:row
            for c = 1:col
                if (img(r,c)>th)
                    binary_img(r,c) = 1;
                end
            end
    end
end