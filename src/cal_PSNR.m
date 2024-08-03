function PSNR = cal_PSNR(ori, img)
    % Calculate the PSNR of the image
    % ori: the original image
    % img: the image to be compared
    % PSNR: the PSNR value

    MSE = sum((double(ori) - double(img)).^2, 'all') / numel(ori);
    PSNR = 10 * log10(255^2 / MSE);

end