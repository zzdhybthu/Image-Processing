function [o, hidden_info] = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB, dec_method)
    % Decode the DC and AC streams using the JPEG algorithm
    % DC_stream [1D int]: the DC stream
    % AC_stream [1D int]: the AC stream
    % rows [int]: the number of rows of the input image
    % cols [int]: the number of columns of the input image
    % QTAB [2D double]: the quantization table
    % DCTAB [2D double]: the DC huffman table
    % ACTAB [2D double]: the AC huffman table
    % dec_method [str][Optional]: Encryption method, available are 'spatial', 'dct_all', 'dct_partial', 'dct_zigzag'
    % return o [2D uint8]: the output image matrix
    % return hidden_info [2D logical]: the hidden information matrix


    if nargin == 8 && ~any(strcmp(dec_method, {'spatial', 'dct_all', 'dct_partial', 'dct_zigzag'}))
        error('The dec_method must be one of the following: spatial, dct_all, dct_partial, dct_zigzag');
    end

    Z = zeros(64, ceil(rows / 8) * ceil(cols / 8));

    DC_huffmanTree = struct('symbol', NaN, 'left', struct(), 'right', struct());
    for idx = 1:size(DCTAB, 1)
        DC_huffmanTree = addSymbolToTree(DC_huffmanTree, DCTAB(idx, 2 : DCTAB(idx, 1) + 1), idx - 1);
    end
    
    DC = [];
    DC_huffman_pointer = DC_huffmanTree;
    idx = 1;
    while idx <= size(DC_stream, 2)
        DC_code = DC_stream(idx);
        if DC_code == 0
            DC_huffman_pointer = DC_huffman_pointer.left;
        else
            DC_huffman_pointer = DC_huffman_pointer.right;
        end
        idx = idx + 1;
        if ~isnan(DC_huffman_pointer.symbol)
            DC_cata = DC_huffman_pointer.symbol;
            DC = [DC, bin_arr2dec(DC_stream(idx : idx + DC_cata - 1))];
            DC_huffman_pointer = DC_huffmanTree;
            idx = idx + DC_cata;
        end
    end

    for idx = 2 : size(DC, 2)
        DC(idx) = DC(idx - 1) - DC(idx);
    end
    Z(1, :) = DC;


    AC_huffmanTree = struct('symbol', NaN, 'left', struct(), 'right', struct());
    for idx = 1:size(ACTAB, 1)
        AC_huffmanTree = addSymbolToTree(AC_huffmanTree, ACTAB(idx, 4 : ACTAB(idx, 3) + 3), [ACTAB(idx, 1), ACTAB(idx, 2)]);
    end
    EOB = [1 0 1 0];
    ZRL = [1 1 1 1 1 1 1 1 0 0 1];
    AC_huffmanTree = addSymbolToTree(AC_huffmanTree, EOB, [0, 0]);
    AC_huffmanTree = addSymbolToTree(AC_huffmanTree, ZRL, [15, 0]);

    AC = [];
    AC_huffman_pointer = AC_huffmanTree;
    idx = 1;
    patch_idx = 1;
    while idx <= size(AC_stream, 2)
        AC_code = AC_stream(idx);
        if AC_code == 0
            AC_huffman_pointer = AC_huffman_pointer.left;
        else
            AC_huffman_pointer = AC_huffman_pointer.right;
        end
        idx = idx + 1;
        if ~isnan(AC_huffman_pointer.symbol)
            AC_run = AC_huffman_pointer.symbol(1);
            AC_size = AC_huffman_pointer.symbol(2);
            if AC_run == 0 && AC_size == 0
                Z(2 : size(AC, 1) + 1, patch_idx) = AC;
                AC = [];
                patch_idx = patch_idx + 1;
            else
                AC = [AC; zeros(AC_run, 1); bin_arr2dec(AC_stream(idx : idx + AC_size - 1))];
                idx = idx + AC_size;
            end
            AC_huffman_pointer = AC_huffmanTree;
        end
    end

    hidden_info = logical([]);
    if nargin == 8 && dec_method == "dct_partial"
        [~, min_QTAB_idx] = min(QTAB(:));
        idx_matrix = zeros(8, 8);
        idx_matrix(mod(min_QTAB_idx - 1, 8) + 1, floor((min_QTAB_idx - 1) / 8) + 1) = 1;
        [~, min_QTAB_idx] = max(zig_zag_8_8(idx_matrix));
        hidden_info = logical(bitget(int64(Z(min_QTAB_idx, :)), 1));
    elseif nargin == 8 && dec_method == "dct_zigzag"
        hidden_info = logical(zeros(1, size(Z, 2)));
        for idx = 1 : size(Z, 2)
            non_zero_indices = find(Z(:, idx));
            if ~isempty(non_zero_indices)
                last_non_zero_idx = non_zero_indices(end);
                hidden_info(idx) = Z(last_non_zero_idx, idx) == 1;
                % if last_non_zero_idx ~= size(Z, 1)  % Should not modify Z since encrypted method is not accessible for other people
                %     Z(last_non_zero_idx, idx) = 0;
                % end
            end
        end
    end

    Z = reshape(Z, [64 * ceil(cols / 8), ceil(rows / 8)]).';
    Q = blockproc(Z, [1, 64], @(block) zag_zig_8_8(block.data));

    if nargin == 8 && dec_method == "dct_all"
        hidden_info = logical(bitget(int64(Q), 1));
    end

    C = blockproc_8_8(Q, @(x) x .* QTAB);
    o = blockproc_8_8(C, @idct2) + 128;
    o = uint8(o(1:rows, 1:cols));

    if nargin == 8 && dec_method == "spatial" 
        hidden_info = logical(bitget(o, 1));
    end
    

    function tree = addSymbolToTree(tree, code, symbol)
        % Add the symbol to the huffman tree
        % tree [struct]: the huffman tree
        % code [1D int]: the huffman code
        % symbol [Any]: the symbol
        % return tree [struct]: the updated huffman tree

        if isempty(code)
            tree.symbol = symbol;
            return;
        end
        
        if code(1) == 0
            if isempty(fieldnames(tree.left))
                tree.left = struct('symbol', NaN, 'left', struct(), 'right', struct());
            end
            tree.left = addSymbolToTree(tree.left, code(2 : end), symbol);
        else
            if isempty(fieldnames(tree.right))
                tree.right = struct('symbol', NaN, 'left', struct(), 'right', struct());
            end
            tree.right = addSymbolToTree(tree.right, code(2 : end), symbol);
        end

    end


    function o = bin_arr2dec(i)
        % Convert the input binary array to a decimal number using 1's complement
        % i [1D int]: the input binary array
        % return o [int]: the decimal number
        
        if isempty(i)
            o = 0;
        else
            if i(1) == 0
                i = ~i;
                o = -bin2dec(num2str(i));
            else
                o = bin2dec(num2str(i));
            end
        end
    
    end

end