function face_recognition(img, height, width, step_h, step_w, L, v, threshold)
    % Face recognition
    % img [matrix]: the input image
    % height [int]: the height of the window
    % width [int]: the width of the window
    % step_h [int]: the step of the height
    % step_w [int]: the step of the width
    % L [int]: the number of bits for each channel
    % v [1 * 2 ^ (3 * L)]: the model
    % threshold [float]: the threshold
    % return: None

    [h, w, ~] = size(img);
    edge = -0.5 : 1 : 2 ^ (3 * L) - 0.5;
    position = [];
    for i = 1 : step_h : h - height + 1
        for j = 1 : step_w : w - width + 1
            window = img(i : i + height - 1, j : j + width - 1, :);
            [h_, w_, ~] = size(window);
            window = reshape(window, [h_ * w_, 3]);
            val = zeros(1, h_ * w_);
            for k = 1 : h_ * w_
                val(k) = rgb2num(int64(window(k, :)), L);
            end
            val = histcounts(val, edge) / (h_ * w_);
            % Bhattacharyya distance
            d = 1 - sum(sqrt(v .* val));
            if d < threshold
                position = [position; j, i, width, height];
            end
        end
        disp("Progress: " + i / (h - height + 1) * 100 + "%");
    end

    disp("The number of faces: " + size(position, 1));


    if isempty(position)
        return;
    end

    flag = true;
    first_epoch = true;
    overlap_ratio = 0.5;
    delete_ratio = 1;
    while flag
        idx = 1;
        flag = false;
        position = sortrows(position);
        n = size(position, 1);
        keep = true(n, 1);
        for idx = 1 : n - 1
            if ~keep(idx)
                continue;
            end
            for idy = idx + 1 : n
                if ~keep(idy)
                    continue;
                end
                overlap = rectint(position(idx, :), position(idy, :));
                area = min(position(idx, 3) * position(idx, 4), position(idy, 3) * position(idy, 4));
                ratio = overlap / area;
                if ratio > overlap_ratio
                    position(idx, 1) = min(position(idx, 1), position(idy, 1));
                    position(idx, 2) = min(position(idx, 2), position(idy, 2));
                    position(idx, 3) = max(position(idx, 1) + position(idx, 3), position(idy, 1) + position(idy, 3)) - min(position(idx, 1), position(idy, 1));
                    position(idx, 4) = max(position(idx, 2) + position(idx, 4), position(idy, 2) + position(idy, 4)) - min(position(idx, 2), position(idy, 2));
                    keep(idy) = false;
                    flag = true;
                end
            end
        end
        position = position(keep, :);
        avg_area = mean(position(:, 3) .* position(:, 4));
        less_than_avg_area = position(:, 3) .* position(:, 4) < avg_area * delete_ratio;
        position(less_than_avg_area, :) = [];
        if any(less_than_avg_area)
            flag = true;
        end
        if first_epoch
            first_epoch = false;
            overlap_ratio = 0.25;
            delete_ratio = 0.5;
        end

    end

    imshow(img);
    hold on;
    for i = 1 : size(position, 1)
        rectangle('Position', position(i, :), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    hold off;

end