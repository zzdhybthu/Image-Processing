function o = zag_zig(i, N)
    % Perform inverse zig-zag scan on the input matrix
    % i [1D double]: the input matrix
    % return o [2D double]: the inverse zig-zag scanned matrix

    i = i(:);

    o = zeros(N);
    o(1) = i(1, 1);
    row = 1;
    col = 1;
    flag = 0;  % 1 means row increases and column decreases

    for idx = 2 : size(i, 1)
        if col == N && flag == 0
            row = row + 1;
            flag = 1;
        elseif row == N && flag == 1
            col = col + 1;
            flag = 0;
        elseif row == 1  && flag == 0
            col = col + 1;
            flag = 1;
        elseif col == 1  && flag == 1
            row = row + 1;
            flag = 0;
        elseif flag == 1
            row = row + 1;
            col = col - 1;
        else
            row = row - 1;
            col = col + 1;
        end
        o(row, col) = i(idx);
    end

end