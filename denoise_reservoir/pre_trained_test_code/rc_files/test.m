function [predictR, predictG, predictB] = test(testImage, N, K, b, Reservoir_num,intensity, patch_size, ...
     alpha, beta, sigma, rho, gauss_mat, unsh_mat, window_num)

path = 'test_images/'; % test image data path
filepthpng = strcat(path, num2str(testImage),'.png');
filepthjpg = strcat(path, num2str(testImage),'.jpg');
filepthjpeg = strcat(path, num2str(testImage),'.jpeg');
if exist(filepthpng,"file")
    target = pixeltransform(imread(filepthpng));
else
    if exist(filepthjpg,"file")
        target = pixeltransform(imread(filepthjpg));
    else
        if exist(filepthjpeg,"file")
            target = pixeltransform(imread(filepthjpeg));
        end
    end
end
target = im2double(target);
l = (patch_size - 1)/2; %==2
[c, d, e] = size(target);
PSNRs = zeros(1,Reservoir_num); %PSNR values
RMSEs = zeros(1,Reservoir_num); %RMSE values
SSIMs = zeros(1,Reservoir_num); %SSIM values

Noise = zeros([c,d,e]);

Res_L = (c - 2*l) * (d - 2*l);
patch_pixels = patch_size^2; %==25

file_name=append(num2str(intensity),'_',num2str(alpha),'_',num2str(beta),'_',num2str(sigma),'_',num2str(rho));

% load weight matrices(A, B) when used for training, load output matrices(W_out) after trainingweight
load(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightA.mat") % A
load(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightB.mat") % B
load(num2str(window_num)+"/"+num2str(intensity)+"/Wout.mat") % W_out

for reservoir_num = 1:Reservoir_num
    
    if reservoir_num == 1 % load test image

        [Noise,Noise1,Noise2,input] = approx_test_create_inputNnoise(target,intensity,c,d,e);
        Input = input;
    
    elseif reservoir_num > 1
    
        input(1+l:end-l, 1+l:end-l, 1) = reshape(predictR, c - 2*l, []);
        input(1+l:end-l, 1+l:end-l, 2) = reshape(predictG, c - 2*l, []);
        input(1+l:end-l, 1+l:end-l, 3) = reshape(predictB, c - 2*l, []);

    end
    
    AA = A(:,:,reservoir_num);
    BB = B(:,:,reservoir_num);

    % genR
    [reservoir] = generate_reservoir7(input, Noise2, b, N, c - 2*l, d - 2*l, K, AA, alpha, gauss_mat, unsh_mat, reservoir_num, l);

    Reservoir = beta*reservoir ...
        +(1-beta)*tanh(0.5/tanh(0.5)*(reservoir*BB));
    R_concatenate = zeros(Res_L,N*K*reservoir_num);
    if reservoir_num==1
        R_concatenate = Reservoir;
    else 
        R_concatenate = [R_prev Reservoir];
    end
    
    if reservoir_num == 1
        [predictR,predictG,predictB] = approx_test_image_restoration(R_concatenate,W_out,Noise1,c,d,l,input,reservoir_num,N,K);
    elseif reservoir_num == 2
        [predictR,predictG,predictB] = approx_test_image_restoration(R_concatenate,W_out,Noise2,c,d,l,input,reservoir_num,N,K);
    else
        [predictR,predictG,predictB] = approx_test_image_restoration(R_concatenate,W_out,Noise,c,d,l,input,reservoir_num,N,K);
    end

    % restored image and differences
        [Denoising_img,test_clean_img,test_noisy_img,PSNR,RMSE,SSIM] = plot_and_err_(target, input, predictR, predictG, predictB, patch_size, reservoir_num);
    
    % save restored image
    save(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(testImage)+"/"...
        +file_name+"_R"+num2str(reservoir_num)+"_denoised.mat","Denoising_img")
    if reservoir_num == Reservoir_num
        
    end
    PSNRs(1,reservoir_num) = PSNR;RMSEs(1,reservoir_num) = RMSE;SSIMs(1,reservoir_num) = SSIM;
    if reservoir_num > 1
        %%%%% fixed reservoir number by experiments %%%%%
        if reservoir_num == Reservoir_num
            DenoisingResult(Input,Denoising_img,test_clean_img,window_num,intensity,testImage,file_name,reservoir_num)
            break
        end
    end
    R_prev = R_concatenate; % to use the concatenated state matrix, stored it
end
sent_disp = strcat('The test image size:',num2str(size(Input,1)),'x',num2str(size(Input,2)),'x',num2str(size(Input,3)));
disp(sent_disp);
save(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(testImage)+"/PSNRs.mat","PSNRs");
save(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(testImage)+"/RMSEs.mat","RMSEs");
save(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(testImage)+"/SSIMs.mat","SSIMs");
end