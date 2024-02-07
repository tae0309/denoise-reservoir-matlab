function [Denoising_img,test_clean_img,test_noisy_img,PSNR,RMSE,SSIM] = plot_and_err_(noise_num,input,predictR,predictG,predictB,patch_size)

path = 'test_set/';
test_clean_img = imread([path, num2str(noise_num), '.png']);
test_clean_img = im2double(test_clean_img);
test_noisy_img = input; %복원 전의 image

Imgsize = size(test_clean_img);
l = (patch_size-1)/2;

%실제로 복원할 때, 가장자리는 복원할 수 없기 때문에 가장자리만 빼고 오차계산 및 복원된 그림 출력
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

fprintf('PSNR = %f\n', PSNR);
fprintf('RMSE = %f\n', RMSE);
fprintf('SSIM = %f\n', SSIM);

