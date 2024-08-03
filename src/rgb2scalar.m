function num = rgb2scalar(rgb, L)
    % Convert RGB to a scalar
    % rgb [1D int]: the RGB array
    % L [int]: the number of bits for each color
    % return num [int]: the scalar

    num = bitshift(rgb(1), L - 8) * (2 ^ (2 * L)) + bitshift(rgb(2), L - 8) * (2 ^ L) + bitshift(rgb(3), L - 8);

end