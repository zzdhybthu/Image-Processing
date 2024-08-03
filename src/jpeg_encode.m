function [DC_stream, AC_stream, rows, cols] = jpeg_encode(i, QTAB, DCTAB, ACTAB, enc_method, hidden_info)
    % Encode the input image using the JPEG algorithm
    % i [2D unit8]: the input image matrix
    % QTAB [2D double]: the quantization table
    % DCTAB [2D double]: the DC huffman table
    % ACTAB [2D double]: the AC huffman table
    % enc_method [str][Optional]: Encryption method, available are 'spatial', 'dct_all', 'dct_partial', 'dct_zigzag'
    % hidden_info [2D logical][Optional]: the hidden information matrix
    % return DC_stream [1D int]: the DC stream
    % return AC_stream [1D int]: the AC stream
    % return rows [int]: the number of rows of the input image
    % return cols [int]: the number of columns of the input image

    
    if nargin == 6 && ~any(strcmp(enc_method, {'spatial', 'dct_all', 'dct_partial', 'dct_zigzag'}))
        error('The dec_method must be one of the following: spatial, dct_all, dct_partial, dct_zigzag');
    end

    [rows, cols] = size(i);

    if nargin == 6 && enc_method == "spatial"
        i = bitset(i, 1, hidden_info);
    end

    C = blockproc_8_8(double(i) - 128, @dct2);  % DCT
    Q = blockproc_8_8(C, @(x) round(x ./ QTAB));  % Quantization

    if nargin == 6 && enc_method == "dct_all"
        Q = double(bitset(int64(Q), 1, hidden_info));
    end

    Z = blockproc_8_8(Q, @(x) zig_zag_8_8(x));  % Zig-zag scan
    Z = reshape(Z.', [64, ceil(rows / 8) * ceil(cols / 8)]);

    if nargin == 6 && enc_method == "dct_partial"
        [~, min_QTAB_idx] = min(QTAB(:));
        idx_matrix = zeros(8, 8);
        idx_matrix(mod(min_QTAB_idx - 1, 8) + 1, floor((min_QTAB_idx - 1) / 8) + 1) = 1;
        [~, min_QTAB_idx] = max(zig_zag_8_8(idx_matrix));
        Z(min_QTAB_idx, :) = double(bitset(int64(Z(min_QTAB_idx, :)), 1, hidden_info));
    elseif nargin == 6 && enc_method == "dct_zigzag"
        hidden_info = double(hidden_info);
        hidden_info(hidden_info == 0) = -1;
        for idx = 1 : min(size(Z, 2), length(hidden_info))
            non_zero_indices = find(Z(:, idx));
            if ~isempty(non_zero_indices)
                last_non_zero_idx = non_zero_indices(end);
                if last_non_zero_idx == size(Z, 1)
                    Z(last_non_zero_idx, idx) = hidden_info(idx);
                else
                    Z(last_non_zero_idx + 1, idx) = hidden_info(idx);
                end
            else
                Z(1, idx) = hidden_info(idx);
            end
        end
    end


    DC = Z(1, :);
    DC_diff = [DC(1), DC(1 : end - 1) - DC(2 : end)];
    DC_cata = min(ceil(log2(abs(DC_diff) + 1)), 11);
    get_code_and_mag_dc = @(cata, diff) [DCTAB(cata + 1, 2 : DCTAB(cata + 1, 1) + 1), dec2bin_arr(diff)];
    DC_stream = cell2mat(arrayfun(@(cata, diff) get_code_and_mag_dc(cata, diff), DC_cata, DC_diff, 'UniformOutput', false));
    
    AC = Z(2 : end, :);
    AC_size = min(ceil(log2(abs(AC) + 1)), 10);
    AC_stream = [];
    EOB = [1 0 1 0];
    ZRL = [1 1 1 1 1 1 1 1 0 0 1];
    get_code_and_mag_ac = @(run, size, amp) [ACTAB(run * 10 + size, 4 : ACTAB(run * 10 + size, 3) + 3), dec2bin_arr(amp)];
    for idx = 1 : size(AC, 2)
        num_zero = 0;
        for jdx = 1 : size(AC, 1)
            if AC(jdx, idx) == 0
                num_zero = num_zero + 1;
            else
                if num_zero > 15
                    AC_stream = [AC_stream, repmat(ZRL, 1, floor(num_zero / 16))];
                    num_zero = mod(num_zero, 16);
                end
                AC_stream = [AC_stream, get_code_and_mag_ac(num_zero, AC_size(jdx, idx), AC(jdx, idx))];
                num_zero = 0;
            end
        end
        AC_stream = [AC_stream, EOB];
    end


    function o = dec2bin_arr(i)
        % Convert the input decimal number to a binary array using 1's complement
        % i [int]: the input decimal number
        % return o [1D int]: the binary array
        
        if i ~= 0
            o = dec2bin(abs(i)) - '0';
            if i < 0
                o = ~o;
            end
        else
            o = [];
        end
    
    end

end
