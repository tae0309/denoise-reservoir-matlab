function [Denoising_img,test_clean_img,test_noisy_img,PSNR,RMSE,SSIM] = plot_and_err_(test_clean_img,input,predictR,predictG,predictB,patch_size,reservoir_num)

test_noisy_img = input; % noisy image

Imgsize = size(test_clean_img);
l = (patch_size-1)/2;

% calculate differences and show the restored image except edges
test_clean_img = test_clean_img(l + 1:Imgsize(1,1) - l,l+1:Imgsize(1,2)-l,:);
test_noisy_img = test_noisy_img(l+1:Imgsize(1,1)-l,l+1:Imgsize(1,2)-l,:);
Denoising_img = zeros(Imgsize(1,1) - 2*l,Imgsize(1,2) - 2*l,3);

Denoising_img(:,:,1) = reshape(predictR, size(test_clean_img,1), []);
Denoising_img(:,:,2) = reshape(predictG, size(test_clean_img,1), []);
Denoising_img(:,:,3) = reshape(predictB, size(test_clean_img,1), []);

clean_pixels = (test_noisy_img > 0 & test_noisy_img < 1);
Denoising_img = clean_pixels.*test_noisy_img + (~clean_pixels).*Denoising_img;

PSNR = psnr(test_clean_img,Denoising_img);
RMSE = sqrt(immse(test_clean_img,Denoising_img));
SSIM = ssim(test_clean_img,Denoising_img);

fprintf('%d^{th} Reservoir: PSNR = %f, RMSE = %f, SSIM = %f\n', reservoir_num,PSNR,RMSE,SSIM);

