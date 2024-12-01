function bimg = edge_detect(img)
    % sobel filters
    Gx = [-1 0 1; -2 0 2; -1 0 1]; 
    Gy = [-1 -2 -1; 0 0 0; 1 2 1];

    % to find gx and gy convolute sobel filters with image
    gx = conv2(double(img), Gx, 'same');
    gy = conv2(double(img), Gy, 'same');

    mag = sqrt(gx.^2 + gy.^2);
    % dir = atan2d(grad_y, grad_x);
    % dir(dir<0) = dir(dir<0) + 360;

    mag_mask = mag > 0.25*max(mag);
    
    edges = bwconncomp(mag_mask,8);
    bimg = labelmatrix(edges) > 0;

end