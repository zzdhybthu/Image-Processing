function subplots(M, N, images, titles)
    % Plot the images in subplots
    % M [int]: the number of rows
    % N [int]: the number of columns
    % images [cell]: images
    % titles [cell]: titles of the images
    % return: None

    if length(images) > M * N
        error('The number of images is greater than the number of subplots');
    end

    figure;
    currentPosition = get(gcf, 'Position');
    set(gcf, 'Position', [currentPosition(1), currentPosition(2), 200 * N, 200 * M]);

    for i = 1 : length(images)
        subplot(M, N, i);
        imshow(images{i});
        title(titles{i});
    end

end