function o = zag_zig_8_8(i)
    % Perform inverse zig-zag scan on the input matrix
    % i [1D double]: the input matrix
    % return o [2D double]: the inverse zig-zag scanned matrix

    if size(i, 1) * size(i, 2) ~= 64
        disp('Size: ');
        disp(size(i));
        error('Input matrix should have 64 elements');
    end

    i = reshape(i, [1, 64]);

    idx_matrix = [
        [1,  2,  6,  7,  15, 16, 28, 29];
        [3,  5,  8,  14, 17, 27, 30, 43];
        [4,  9,  13, 18, 26, 31, 42, 44];
        [10, 12, 19, 25, 32, 41, 45, 54];
        [11, 20, 24, 33, 40, 46, 53, 55];
        [21, 23, 34, 39, 47, 52, 56, 61];
        [22, 35, 38, 48, 51, 57, 60, 62];
        [36, 37, 49, 50, 58, 59, 63, 64];
    ];
    o = i(idx_matrix);

end