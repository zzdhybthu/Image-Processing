function v = train(imgs, L)
    % Train the model given images
    % imgs [cell]: images
    % L [int]: the number of bits for each channel
    % return: v [1 * 2 ^ (3 * L)]: the model
    
    vals = zeros(1, 2 ^ (3 * L));
    edge = -0.5 : 1 : 2 ^ (3 * L) - 0.5;
    for idx = 1:length(imgs)
        img = imgs{idx};
        [h, w, ~] = size(img);
        % val = arrayfun(@(i, j) rgb2scalar(squeeze(img(i, j, :)), L), repmat((1:h)', 1, w), repmat(1:w, h, 1));  % Unsufficient
        img = reshape(img, [h * w, 3]);
        val = zeros(1, h * w);
        for i = 1 : h * w
            val(i) = rgb2scalar(int64(img(i, :)), L);
        end
        vals = vals + histcounts(val, edge) / (h * w);
    end
    v = vals / length(imgs);

end