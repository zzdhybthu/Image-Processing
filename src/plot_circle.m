function plot_circle(img, linewidth, rgb, save_prefix)
    % Plot a circle on the image and save it
    % img [3D uint8]: the input image
    % linewidth [int]: width of the circle
    % rgb [1*3 double]: color of the circle, e.g. [255, 0, 0] for red
    % save_prefix [str][optional]: prefix of the saved file
    % return: None

    [rows, cols, ~] = size(img);

    center = [cols / 2, rows / 2];
    radius_outer = min(rows, cols) / 2;
    radius_inner = radius_outer - linewidth;

    [x, y] = meshgrid(1:cols, 1:rows);
    mask = (x - center(1)).^2 + (y - center(2)).^2 <= radius_outer^2 & (x - center(1)).^2 + (y - center(2)).^2 >= radius_inner^2;
    circle = double(img);
    circle(:,:,1) = rgb(1) * mask + circle(:,:,1) .* ~mask;
    circle(:,:,2) = rgb(2) * mask + circle(:,:,2) .* ~mask;
    circle(:,:,3) = rgb(3) * mask + circle(:,:,3) .* ~mask;
    imshow(uint8(circle));

    if nargin < 4
        save_or_wait(gca);
    else
        save_or_wait(gca, true, strcat(save_prefix, 'circle'));
    end

end