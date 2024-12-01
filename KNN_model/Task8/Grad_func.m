function [gradient, angle] = Grad_func(cellImage)
    [m,n] = size(cellImage);
    gradient = zeros(m,n);
    angle = zeros(m,n);
    for i = 1:m
        for j=1:n
            if j == 1
                Gx = cellImage(i, j+1) - cellImage(i, j); % Forward difference
            elseif j == n
                Gx = cellImage(i, j) - cellImage(i, j-1); % Backward difference
            else
                Gx = cellImage(i, j+1) - cellImage(i, j-1); % Central difference
            end

            if i == 1
                Gy = cellImage(i+1, j) - cellImage(i, j); % Forward difference
            elseif i == m
                Gy = cellImage(i, j) - cellImage(i-1, j); % Backward difference
            else
                Gy = cellImage(i+1, j) - cellImage(i-1, j); % Central difference
            end
            
            gradient(i,j) = sqrt(Gx^2 + Gy^2);
            A = atan2d(Gy,Gx);
            if A<0
                A = A + 180;
            end
            angle(i,j) = A;
        end
    end 

end