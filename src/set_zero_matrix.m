function o = set_zero_matrix(i, N, direction)
    % Set the last N elements of the matrix to zero
    % i [2D double]: the input matrix
    % N [int]: the number of elements to set to zero
    % direction [str]: the direction to set the elements to zero
    % return o [2D double]: the output matrix

    o = i;
    [rows, cols] = size(i);
    if direction == "right"
        o(:, cols - N + 1:cols) = 0;
    elseif direction == "left"
        o(:, 1:N) = 0;
    elseif direction == "down"
        o(rows - N + 1:rows, :) = 0;
    elseif direction == "up"
        o(1:N, :) = 0;
    else
        error("Invalid direction");
    end

end