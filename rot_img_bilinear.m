function [ output ] = rot_img_bilinear( input_img, angle )
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

            % Linearly interpolate the nearest 4 pixels
            left_x = floor(loc(1));
            right_x = ceil(loc(1));
            top_y = floor(loc(2));
            bot_y = ceil(loc(2));

            if((left_x == right_x) && (top_y == bot_y))

                % The sample pixel lies directly on an original input_img pixel
                output(y, x, :) = input_img(y, x, :);

            else

                % The sample pixel lies inbetween several pixels

                % Location of the nearest 4 pixels
                px_locs = [left_x right_x left_x right_x; top_y top_y bot_y bot_y];

                px_dists = distance(loc, px_locs);
                px_dists = px_dists ./ sum(px_dists);

                % Take the linearly interpolated average of each color
                % channel's value
                output(y, x) = ...
                    px_dists(1) * input_img(px_locs(2, 4), px_locs(1, 4)) + ... % bottom-right
                    px_dists(2) * input_img(px_locs(2, 3), px_locs(1, 3)) + ... % bottom-left
                    px_dists(3) * input_img(px_locs(2, 2), px_locs(1, 2)) + ... % top-right
                    px_dists(4) * input_img(px_locs(2, 1), px_locs(1, 1));      % top-left
            end

        end

    end

    output = cast(output, class(input_img));


end