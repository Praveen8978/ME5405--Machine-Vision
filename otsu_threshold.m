function [binary_image, thresh] = otsu_threshold(img)
    [row,col] = size(img);
    binary_image = zeros(row, col);
    classVariance = 1e10;
    [counts, ~] = imhist(img,256);
    for intensity = 0:255
        w1 = 0;
        m1 = 0;
        m1_2 = 0;
        w2 = 0;
        m2 = 0;
        m2_2 = 0;
        for i1 = 0:intensity
            w1 = w1 + counts(i1+1);
            m1 = m1 + i1*counts(i1+1);
            m1_2 = m1_2 + i1^2*counts(i1+1);
        end
        for i2 = intensity+1:255
            w2 = w2 + counts(i2+1);
            m2 = m2 + i2*counts(i2+1);
            m2_2 = m2_2 + i2^2*counts(i2+1);
        end
        if (w1>0 && w2>0)
            m1 = m1/w1;
            m1_2 = m1_2/w1;
            var1 = m1_2-m1^2;
            w1 = w1/double(row*col);
            m2 = m2/w2;
            m2_2 = m2_2/w2;
            var2 = m2_2-m2^2;
            w2 = w2/double(row*col);
            variance = w1*var1 + w2*var2;
            if (variance<classVariance)
                classVariance = variance;
                thresh = intensity;
            end
        end
    end
    for r = 1:row
        for c = 1:col
            if (img(r,c)>thresh)
                binary_image(r,c) = 1;
            end
        end
    end
end