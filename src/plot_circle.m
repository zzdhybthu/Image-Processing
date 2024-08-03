function plot_circle(img, linewidth, color, save_prefix)
    % Plot a circle on the image and save it
    % img [3D double]: the input image
    % linewidth [int]: width of the circle
    % color [str]: color of the circle
    % save_prefix [str][optional]: prefix of the saved file
    % return: None

    [rows, cols, ~] = size(img);
    center = [cols / 2, rows / 2] + 0.5;  % 0.5 for better visualization
    radius = min(rows, cols) / 2;

    imshow(uint8(img));
    hold on;

    theta = linspace(0, 2 * pi, 1000);
    x = center(1) + radius .* cos(theta);
    y = center(2) + radius .* sin(theta);
    plot(x, y, color, 'LineWidth', linewidth);

    if nargin < 4
        title = '';
    else
        title = strcat(save_prefix, 'circle');
    end

    save_or_wait(gca, true, title);

end