function [gray_img] = color2gray(im)
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);

    im_size = size(im);
    L = im_size(1);
    W = im_size(2);
    gray_img = zeros(L,W,'uint8');
    for i=1:L
        for j=1:W
            gray_img(i,j) = (R(i, j)*0.2989)+(G(i, j)*0.5870)+(B(i, j)*0.114);
        end
    end
end



    
