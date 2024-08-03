function o = blockproc_8_8(i, func, varargin)
    % Apply the function to each 8x8 block of the input matrix
    % i [2D double]: the input matrix
    % func [function handle]: the function to apply to each block
    % varargin [cell]: the arguments to pass to the function
    % return o [2D double]: the output matrix
    
    o = blockproc(i, [8, 8], @(block) func(block.data, varargin{:}), 'PadPartialBlocks', true);

end