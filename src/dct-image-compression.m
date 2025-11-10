clear; clc; close all;

% Define image paths (Modify paths as needed and use whichever image you want)
image_paths = {'C:\Users\PoojaPallu\OneDrive\Desktop\Matlab project\flower.jpeg', ...
               'H:\lenna_thumb[3].jpg', ...
               'C:\Users\PoojaPallu\OneDrive\Desktop\Matlab project\lion.jpeg', ...
               'C:\Users\PoojaPallu\OneDrive\Desktop\Matlab project\tree.jpeg'};
num_images = length(image_paths);

% Define Quantization Matrices
Q50 = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];

Q30 = round(Q50 * (50/30)); % Adjusted scaling for Q30
blockSize = 8; % Block size for DCT

% User Selection
choice = input('Enter 1 for Q50 ? Q30 or 2 for Q30 only: ');

% Initialize result storage
metrics = zeros(num_images, 5); % [MSE Q50, PSNR Q50, MSE Q30, PSNR Q30, Compression Ratio Q30]

% Create a figure for displaying all images together
figure('Name', 'Image Processing Results', 'NumberTitle', 'off');

for img_idx = 1:num_images
    % Read image
    img = imread(image_paths{img_idx});
    
    % Convert to YCbCr color space
    img_YCbCr = rgb2ycbcr(img);
    Y = double(img_YCbCr(:,:,1)); % Only the Y channel for processing
    Cb = img_YCbCr(:,:,2); % Cb channel (chrominance)
    Cr = img_YCbCr(:,:,3); % Cr channel (chrominance)

    % Normalize pixel values
    image_normalized = Y - 128;

    % Get image size
    [m, n] = size(image_normalized);

    % Initialize matrices
    dct_image = zeros(m, n);
    quantized_dct = zeros(m, n);

    % If Q50 ? Q30 is selected
    if choice == 1
        % Perform Q50 Compression
        for i = 1:blockSize:m-blockSize+1
            for j = 1:blockSize:n-blockSize+1
                block = image_normalized(i:i+blockSize-1, j:j+blockSize-1);
                dct_block = dct2(block);
                dct_image(i:i+blockSize-1, j:j+blockSize-1) = dct_block;
                quantized_dct(i:i+blockSize-1, j:j+blockSize-1) = round(dct_block ./ Q50);
            end
        end

        % Dequantize & Apply IDCT (Q50)
        reconstructed_Y_Q50 = zeros(m, n);
        for i = 1:blockSize:m-blockSize+1
            for j = 1:blockSize:n-blockSize+1
                dequantized_block = quantized_dct(i:i+blockSize-1, j:j+blockSize-1) .* Q50;
                reconstructed_block = idct2(dequantized_block);
                reconstructed_Y_Q50(i:i+blockSize-1, j:j+blockSize-1) = reconstructed_block;
            end
        end

        % Clip values
        reconstructed_Y_Q50 = max(min(reconstructed_Y_Q50 + 128, 255), 0);

        % Compute MSE & PSNR for Q50
        mse_Q50 = mean((Y(:) - reconstructed_Y_Q50(:)).^2);
        psnr_Q50 = 10 * log10((255^2) / mse_Q50);

        % Now apply Q30 on Reconstructed Q50 Image
        image_normalized = reconstructed_Y_Q50 - 128;
    end

    % Perform Q30 Compression
    dct_image = zeros(m, n);
    quantized_dct = zeros(m, n);

    for i = 1:blockSize:m-blockSize+1
        for j = 1:blockSize:n-blockSize+1
            block = image_normalized(i:i+blockSize-1, j:j+blockSize-1);
            dct_block = dct2(block);
            dct_image(i:i+blockSize-1, j:j+blockSize-1) = dct_block;
            quantized_dct(i:i+blockSize-1, j:j+blockSize-1) = round(dct_block ./ Q30);
        end
    end

    % Dequantize & Apply IDCT (Q30)
    reconstructed_Y_Q30 = zeros(m, n);
    for i = 1:blockSize:m-blockSize+1
        for j = 1:blockSize:n-blockSize+1
            dequantized_block = quantized_dct(i:i+blockSize-1, j:j+blockSize-1) .* Q30;
            reconstructed_block = idct2(dequantized_block);
            reconstructed_Y_Q30(i:i+blockSize-1, j:j+blockSize-1) = reconstructed_block;
        end
    end

    % Clip values
    reconstructed_Y_Q30 = uint8(max(min(reconstructed_Y_Q30 + 128, 255), 0));

    % Reconstruct final color image by combining Y, Cb, Cr
    reconstructed_YCbCr = cat(3, reconstructed_Y_Q30, Cb, Cr);
    reconstructed_rgb = ycbcr2rgb(reconstructed_YCbCr);

    % Compute Metrics for Q30
    mse_Q30 = mean((Y(:) - double(reconstructed_Y_Q30(:))).^2);
    psnr_Q30 = 10 * log10((255^2) / mse_Q30);

    % Store results
    if choice == 1
        metrics(img_idx, :) = [mse_Q50, psnr_Q50, mse_Q30, psnr_Q30, numel(Y) / nnz(quantized_dct)];
    else
        metrics(img_idx, :) = [NaN, NaN, mse_Q30, psnr_Q30, numel(Y) / nnz(quantized_dct)];
    end

    % --------- Display the four images in one figure ------------
    subplot(num_images, 4, (img_idx-1)*4 + 1);
    imshow(img);
    title(sprintf('Original Image %d', img_idx));

    subplot(num_images, 4, (img_idx-1)*4 + 2);
    imshow(uint8(Y));
    title(sprintf('Grayscale Y %d', img_idx));

    subplot(num_images, 4, (img_idx-1)*4 + 3);
    imshow(reconstructed_Y_Q30);
    title(sprintf('Reconstructed Y %d', img_idx));

    subplot(num_images, 4, (img_idx-1)*4 + 4);
    imshow(reconstructed_rgb);
    title(sprintf('Restored Color %d', img_idx));
end

% --------- Display final comparison table ----------
fprintf('\nComparison Table:\n');
fprintf('---------------------------------------------------------------\n');
fprintf('| Image | MSE Q50 | PSNR Q50 (dB) | MSE Q30 | PSNR Q30 (dB) | Compression Ratio |\n');
fprintf('---------------------------------------------------------------\n');

for img_idx = 1:num_images
    if choice == 1
        fprintf('| %d | %.2f | %.2f | %.2f | %.2f | %.2f |\n', ...
            img_idx, metrics(img_idx, 1), metrics(img_idx, 2), metrics(img_idx, 3), metrics(img_idx, 4), metrics(img_idx, 5));
    else
        fprintf('| %d | - | - | %.2f | %.2f | %.2f |\n', ...
            img_idx, metrics(img_idx, 3), metrics(img_idx, 4), metrics(img_idx, 5));
    end
end

fprintf('---------------------------------------------------------------\n');