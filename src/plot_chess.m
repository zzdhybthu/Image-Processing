function plot_chess(img, length, save_prefix)
    % Plot a chessboard on the image and save it
    % img [3D uint8]: the input image
    % length [int]: length of the chessboard
    % save_prefix [str][optional]: prefix of the saved file
    % return: None

    [rows, cols, channels] = size(img);

    [x, y] = meshgrid(1:cols, 1:rows);
    checkerboard = mod(floor((x - 0.5) / length) + floor((y - 0.5) / length), 2);  % 0.5 for better visualization
    mask = repmat(checkerboard, [1, 1, channels]) == 0;

    chess = double(img);
    chess(mask) = 0;
    imshow(uint8(chess));

    if nargin < 3
        save_or_wait(gca);
    else
        save_or_wait(gca, true, strcat(save_prefix, 'chess'));
    end
    
end