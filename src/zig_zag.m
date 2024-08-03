function o = zig_zag(i)
    % Perform zig-zag scan on the input matrix
    % i [2D double]: the input matrix
    % return o [1D double]: the zig-zag scanned matrix

    [N, M] = size(i);
    if N ~= M
        error("The input matrix must be square");
    end

    o = zeros(1, N * N);
    o(1) = i(1, 1);
    row = 1;
    col = 1;
    flag = 0;  % 1 means row increases and column decreases

    for idx = 2 : N * N
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
        o(idx) = i(row, col);
    end

end