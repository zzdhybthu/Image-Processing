function C = dct_2(P, s)
    % Perform 2D DCT on the input matrix
    % P [2D double]: the input matrix
    % s [1D int][optional]: the size of the matrix
    % return C [2D double]: the DCT matrix

    
    function D = dct_D(N)
        % Create the 2D DCT matrix
        % N [int]: the size of the matrix
        % return D [2D double]: the DCT matrix
    
        D = [1 : N - 1]' * [1: 2: 2 * N - 1];
        D = cos(D * pi / (2 * N));
        D = [repmat(sqrt(0.5), [1, N]); D];
        D = D * sqrt(2 / N);
    
    end


    [rows, cols] = size(P);
    
    if nargin < 2
        if rows == cols
            D = dct_D(rows);
            C = D * P * D';
        else
            D = dct_D(rows);
            D_T = dct_D(cols)';
            C = D * P * D_T;
        end
    else
        P_padding = zeros(s);
        min_rows = min(rows, s(1));
        min_cols = min(cols, s(2));
        P_padding(1:min_rows, 1:min_cols) = P(1:min_rows, 1:min_cols);
        if s(1) == s(2)
            D = dct_D(s(1));
            C = D * P_padding * D';
        else
            D = dct_D(s(1));
            D_T = dct_D(s(2))';
            C = D * P_padding * D_T;
        end
    end
    
end