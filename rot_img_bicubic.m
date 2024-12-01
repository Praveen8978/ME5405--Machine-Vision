function [output] = rot_img_bicubic(input_img, angle)
%   rot_img Rotates the given image by angle about position
%   Given an image in the format [y, x], rotates it by the given angle
%   around the centre of the image
    
    if(nargin < 2)
        error('input_img and angle parameters are both required');
    end

    if(angle == 0)
        output = input_img;
        return;
    end

    [height, width] = size(input_img);
    half_width = width/2 - 0.5;
    half_height = height/2 - 0.5;

    % Compute the translation vector to move from a top-left origin to a
    % centred-origin
    T = [-half_width half_height]';

    % A lambda function for creating a 2D rotation matrix
    rotmat = @(th) [cos(th) -sin(th); sin(th) cos(th)];

    % Convert angle to radians and generate rotation matrix R for CR
    % rotation
    R = rotmat(deg2rad(angle));

    output = zeros(height, width);

    for y=1:height

        for x=1:width

            loc = [x-1 y-1]';

            % Transform the current pixel location into the
            % origin-at-centre coordinate frame
            loc = loc .* [1; -1] + T;

            % Apply the inverse rotation mapping to this ouput pixel to
            % determine the location in the original input_img that this pixel
            % corresponds to
            loc = R * loc;

            % Transform back from the origin-at-centre coordinate frame to
            % the original input_img's origin-at-top-left frame
            loc = (loc - T) .* [1; -1] + [1; 1];


            if((loc(1) < 1) || (loc(1) > width) || (loc(2) < 1) || (loc(2) > height))
                % This pixel falls outside the input_img - leave it at 0
                continue;
            end

            output(y, x) = bicubic_interpolate(input_img, loc);


        end
    end
    [m,n] = size(output);
    for i = 1:m
        for j = 1:n
            if output(i,j) < 0
                output(i,j) = 0;
            elseif output(i,j) > 255
                output(i,j) = 255;
            end
        end
    end

    output = cast(output, class(input_img));
end