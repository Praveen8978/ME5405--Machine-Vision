function value = bicubic_interpolate(img, loc)
    x = loc(1);
    y = loc(2);

    x1 = floor(x); y1 = floor(y);

    value = 0;

    for i = -1:2
        for j = -1:2
            xi = min(max(x1 + i, 1), size(img, 2));  % Clamp to valid range
            yi = min(max(y1 + j, 1), size(img, 1));

            % Compute weights using the custom kernel
            wx = bicubic_weights(x - (x1 + i));
            wy = bicubic_weights(y - (y1 + j));

            % Accumulate weighted sum
            value = value + wx * wy * img(yi, xi);
        end
    end
end