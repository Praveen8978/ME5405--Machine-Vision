function w = bicubic_weights(d)
    mod_d = abs(d);  % Absolute value of distance
    if mod_d < 1
        w = 1 - 2 * mod_d^2 + mod_d^3;
    elseif mod_d < 2
        w = 4 - 8 * mod_d + 5 * mod_d^2 - mod_d^3;
    else
        w = 0;  % Outside the interpolation range
    end
end