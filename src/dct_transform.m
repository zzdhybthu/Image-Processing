function o = dct_transform(i, func, varargin)
    % Transform the input image using the given function applied to each 8x8 block C matrix
    % i [2D unit8]: original image matrix
    % func [function handle]: the function to apply to each block
    % varargin [cell]: the arguments to pass to the function
    % return o [2D unit8]: the output image matrix

    C = blockproc_8_8(double(i) - 128, @dct2);
    C = blockproc_8_8(C, func, varargin{:});
    o = blockproc_8_8(C, @(x) uint8(idct2(x) + 128));

end