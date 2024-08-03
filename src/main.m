clear;


% Loading data
load('./resource/hall.mat');
load('./resource/JpegCoeff.mat');
load('./resource/snow.mat');


% % 1.1
% help images;


% % 1.2
% hall_color_double = double(hall_color);

% % plot_circle(hall_color_double, 2, 'r');
% plot_circle(hall_color_double, 2, 'r', './report/asserts/1_2_');

% % plot_chess(hall_color_double, 10);
% plot_chess(hall_color_double, 10, './report/asserts/1_2_');


% % 2.1
% patch00 = double(hall_gray(1:8, 1:8));
% c_patch00_ori = dct2(patch00 - 128);
% c_patch00_trans = dct2(patch00);
% c_offset = dct2(zeros(8, 8) + 128);
% disp('c_offset: ');
% disp(c_offset);
% c_patch00_trans(1, 1) = c_patch00_trans(1, 1) - c_offset(1, 1);
% disp("SSE: " + sum((c_patch00_trans - c_patch00_ori).^2, 'all'));


% % 2.2
% patch00 = double(hall_gray(1:8, 1:8));
% c_patch00 = dct2(patch00 - 128);
% c_patch00_ = dct_2(patch00 - 128);
% disp("SSE: " + sum((c_patch00 - c_patch00_).^2, 'all'));
% c_patch00 = dct2(patch00 - 128, [6, 10]);
% c_patch00_ = dct_2(patch00 - 128, [6, 10]);
% disp("SSE: " + sum((c_patch00 - c_patch00_).^2, 'all'));


% % 2.3
% res_ori = dct_transform(hall_gray, @(x) x);
% res_right_4 = dct_transform(hall_gray, @set_zero_matrix,  4, 'right');
% res_left_4 = dct_transform(hall_gray, @set_zero_matrix,  4, 'left');
% subplots(1, 3, {res_ori, res_right_4, res_left_4}, {'Original', 'Set right 4 to zero', 'Set left 4 to zero'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_3_image');

% hall_gray_patch = hall_gray(73:80, 81:88);
% res_ori = dct_transform(hall_gray_patch, @(x) x);
% res_right_4 = dct_transform(hall_gray_patch, @set_zero_matrix,  4, 'right');
% res_left_4 = dct_transform(hall_gray_patch, @set_zero_matrix,  4, 'left');
% subplots(1, 3, {res_ori, res_right_4, res_left_4}, {'Original', 'Set right 4 to zero', 'Set left 4 to zero'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_3_patch');


% % 2.4
% res_ori = dct_transform(hall_gray, @(x) x);
% res_transpose = dct_transform(hall_gray, @(x) x');
% res_rotate_90 = dct_transform(hall_gray, @(x) rot90(x, 1));
% res_rotate_180 = dct_transform(hall_gray, @rot90, 2);
% subplots(2, 2, {res_ori, res_transpose, res_rotate_90, res_rotate_180}, {'Original', 'Transpose', 'Rotate 90', 'Rotate 180'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_4_image');

% hall_gray_patch = hall_gray(73:80, 81:88);
% res_ori = dct_transform(hall_gray_patch, @(x) x);
% res_transpose = dct_transform(hall_gray_patch, @(x) x');
% res_rotate_90 = dct_transform(hall_gray_patch, @(x) rot90(x, 1));
% res_rotate_180 = dct_transform(hall_gray_patch, @rot90, 2);
% subplots(2, 2, {res_ori, res_transpose, res_rotate_90, res_rotate_180}, {'Original', 'Transpose', 'Rotate 90', 'Rotate 180'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_4_patch');


% % 2.5
% % y(n) = x(n - 1) - x(n)
% b = [-1, 1];
% a = 1;
% freqz(b, a);
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_5_freqz');


% % 2.6
% % C = min(ceil(log2(abs(delta) + 1)), 11)  % cannot use floor(log2(abs(delta))) + 1 because delta possibly equals to 0


% % 2.7
% input_8_8 = [
%      1,  2,  6,  7, 15, 16, 28, 29;
%      3,  5,  8, 14, 17, 27, 30, 43;
%      4,  9, 13, 18, 26, 31, 42, 44;
%      10, 12, 19, 25, 32, 41, 45, 54;
%      11, 20, 24, 33, 40, 46, 53, 55;
%      21, 23, 34, 39, 47, 52, 56, 61;
%      22, 35, 38, 48, 51, 57, 60, 62;
%      36, 37, 49, 50, 58, 59, 63, 64;
% ];
% disp(zig_zag_8_8(input_8_8));
% input_9_9 = [
%     1,  2,  6,  7, 15, 16, 28, 29, 45;
%     3,  5,  8, 14, 17, 27, 30, 44, 46;
%     4,  9, 13, 18, 26, 31, 43, 47, 60;
%     10, 12, 19, 25, 32, 42, 48, 59, 61;
%     11, 20, 24, 33, 41, 49, 58, 62, 71;
%     21, 23, 34, 40, 50, 57, 63, 70, 72;
%     22, 35, 39, 51, 56, 64, 69, 73, 78;
%     36, 38, 52, 55, 65, 68, 74, 77, 79;
%     37, 53, 54, 66, 67, 75, 76, 80, 81;
% ];
% disp(zig_zag(input_9_9));
% diff = zig_zag_8_8(input_8_8) - zig_zag(input_8_8);
% disp(sum(diff.^2, 'all'));


% % 2.8-2.10
% [DC_stream, AC_stream, rows, cols] = jpeg_encode(hall_gray, QTAB, DCTAB, ACTAB);
% save('./resource/jpegcodes.mat', 'DC_stream', 'AC_stream', 'rows', 'cols');
% disp("Compression ratio: " + (8 * rows * cols) / (length(DC_stream) + length(AC_stream)));


% % 2.11
% disp(zag_zig_8_8([1:64]));
% disp(zag_zig([1:64], 8));
% disp(zag_zig([1:81], 9));

% load('./resource/jpegcodes.mat');
% hall_gray_decode = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB);
% disp('PSNR: ' + string(cal_PSNR(hall_gray, hall_gray_decode)));
% subplots(1, 2, {hall_gray, hall_gray_decode}, {'Original', 'Decoded'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_11_decode');


% % 2.12
% QTAB_ = QTAB / 2;
% [DC_stream, AC_stream, rows, cols] = jpeg_encode(hall_gray, QTAB_, DCTAB, ACTAB);
% disp("Compression ratio: " + (8 * rows * cols) / (length(DC_stream) + length(AC_stream)));
% hall_gray_decode = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB_, DCTAB, ACTAB);
% disp('PSNR: ' + string(cal_PSNR(hall_gray, hall_gray_decode)));
% subplots(1, 2, {hall_gray, hall_gray_decode}, {'Original', 'Decoded'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_12_decode');


% % 2.13
% [DC_stream, AC_stream, rows, cols] = jpeg_encode(snow, QTAB, DCTAB, ACTAB);
% disp("Compression ratio: " + (8 * rows * cols) / (length(DC_stream) + length(AC_stream)));
% snow_decode = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB);
% disp('PSNR: ' + string(cal_PSNR(snow, snow_decode)));
% subplots(1, 2, {snow, snow_decode}, {'Original', 'Decoded'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/2_13_decode');


% % 3.1
% rand_info = logical(randi([0, 1], size(hall_gray)));
% [DC_stream, AC_stream, rows, cols] = jpeg_encode(hall_gray, QTAB, DCTAB, ACTAB, "spatial", rand_info);
% [hall_gray_decode, decode_info] = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB, "spatial");
% disp("Accuracy: " + sum(decode_info == rand_info, 'all') / (rows * cols));
% subplots(1, 2, {hall_gray, hall_gray_decode}, {'Original', 'Decoded'});
% save_or_wait(gcf);
% % save_or_wait(gcf, true, './report/asserts/3_1_decode');
% rand_info = logical(repmat(1, size(hall_gray)));
% [DC_stream, AC_stream, rows, cols] = jpeg_encode(hall_gray, QTAB, DCTAB, ACTAB, "spatial", rand_info);
% [hall_gray_decode, decode_info] = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB, "spatial");
% disp("Accuracy: " + sum(decode_info == rand_info, 'all') / (rows * cols));
% rand_info = logical(repmat(0, size(hall_gray)));
% [DC_stream, AC_stream, rows, cols] = jpeg_encode(hall_gray, QTAB, DCTAB, ACTAB, "spatial", rand_info);
% [hall_gray_decode, decode_info] = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB, "spatial");
% disp("Accuracy: " + sum(decode_info == rand_info, 'all') / (rows * cols));


% % 3.2
% avg_compression = [];
% avg_PSNR = [];
% avg_accuracy = [];
% decode_img = {};
% methods = {'spatial', 'dct_all', 'dct_partial', 'dct_zigzag'};
% info_length = ceil(size(hall_gray, 1) / 8) * ceil(size(hall_gray, 2) / 8);
% for method = methods
%     compression = [];
%     PSNR = [];
%     accuracy = [];
%     for i = [1:10]
%         if method == "spatial" || method == "dct_all"
%             rand_info = logical(randi([0, 1], size(hall_gray)));
%         else
%             rand_info = logical(randi([0, 1], [1, info_length]));
%         end
%         [DC_stream, AC_stream, rows, cols] = jpeg_encode(hall_gray, QTAB, DCTAB, ACTAB, method, rand_info);
%         compression = [compression, (8 * rows * cols) / (length(DC_stream) + length(AC_stream))];
%         [hall_gray_decode, decode_info] = jpeg_decode(DC_stream, AC_stream, rows, cols, QTAB, DCTAB, ACTAB, method);
%         PSNR = [PSNR, cal_PSNR(hall_gray, hall_gray_decode)];
%         accuracy = [accuracy, mean(decode_info == rand_info)];
%         if i == 1
%             decode_img = {decode_img{:}, hall_gray_decode};
%         end
%     end
%     avg_compression = [avg_compression, mean(compression)];
%     avg_PSNR = [avg_PSNR, mean(PSNR)];
%     avg_accuracy = [avg_accuracy, mean(accuracy)];
% end
% disp('Average compression ratio: ');
% disp(avg_compression);
% disp('Average PSNR: ');
% disp(avg_PSNR);
% disp('Average accuracy: ');
% disp(avg_accuracy);
% subplots(2, 3, {decode_img{:}, hall_gray}, {'Spatial', 'DCT All', 'DCT Partial', 'DCT Zigzag', 'Original'});
% % save_or_wait(gcf);
% save_or_wait(gcf, true, './report/asserts/3_2_decode');


% 4.1
faces = {};
for i = 1:33
    faces = [faces(:)', imread(['./resource/Faces/' num2str(i) '.bmp'])];
end
% Vs = {};
% titles = {"L = 3", "L = 4", "L = 5"};
% figure;
% for L = 3:5
%     v = train(faces, L);
%     subplot(3, 1, L - 2);
%     plot(1:2^(3 * L), v);
%     title(titles{L - 2});
%     % bar(v);
%     Vs = [Vs(:)', v];
% end
% % save_or_wait(gcf);
% save_or_wait(gcf, false, './report/asserts/4_1_bar');


% 4.2
% eesast = imread('./resource/eesast-group-photo-2023.jpg');
% tabletennis = imread('./resource/tabletennis.png');
% eesast_ratio = [0.475, 0.735, 0.86];
% tabletennis_ratio = [0.475, 0.625, 0.795];
% for L = 3:5
%     v = train(faces, L);
%     face_recognition(eesast, 16, 16, 4, 4, L, v, eesast_ratio(L - 2));
%     % save_or_wait(gcf);
%     save_or_wait(gcf, true, ['./report/asserts/4_2_eesast_L' num2str(L)]);
%     face_recognition(tabletennis, 16, 16, 4, 4, L, v, tabletennis_ratio(L - 2));
%     % save_or_wait(gcf);
%     save_or_wait(gcf, true, ['./report/asserts/4_2_tabletennis_L' num2str(L)]);
% end


% % 4.3
% eesast = imread('./resource/eesast-group-photo-2023.jpg');
% eesast_90 = rot90(eesast, 1);
% eesast_stretch = imresize(eesast, [size(eesast, 1), size(eesast, 2) * 2]);
% eesast_light = eesast + 50;
% eesast_dark = eesast - 50;
% eesasts = {eesast, eesast_90, eesast_stretch, eesast_light, eesast_dark};
% L = 3;
% v = train(faces, L);
% ratio = 0.475;
% for i = 1:5
%     face_recognition(eesasts{i}, 16, 16, 4, 4, L, v, ratio);
%     % save_or_wait(gcf);
%     save_or_wait(gcf, true, ['./report/asserts/4_3_eesast_' num2str(i) '_L' num2str(L)]);
% end
