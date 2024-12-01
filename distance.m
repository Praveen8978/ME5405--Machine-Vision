function output = distance(A,B)
    output = [];
    mat_size = size(B);
    columns = mat_size(1,2);
    for i=1:columns
        v1 = A(:,1);
        v2 = B(:,i);
        x_dst = (v2(1,1) - v1(1,1))^2;
        y_dst = (v2(2,1) - v1(2,1))^2;
        dst = sqrt(x_dst + y_dst);
        output = [output, dst];
    end
end
