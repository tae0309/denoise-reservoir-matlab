function [predictR, predictG, predictB] = test(noise_num, N, K, b, Reservoir_num,intensity, patch_size, ...
     alpha, beta, sigma, rho, gauss_mat, unsh_mat, window_num)

path = 'test_set/'; %test image data 경로
target = pixeltransform(imread([path, num2str(noise_num),'.png'])); 
target = im2double(target);
l = (patch_size - 1)/2; %==2
[c, d, e] = size(target);
P_R_S = zeros(3,Reservoir_num); %PSNR,RMSE,SSIM을 저장하는 변수

Noise = zeros([c,d,e]);

Res_L = (c - 2*l) * (d - 2*l);
patch_pixels = patch_size^2; %==25

file_name=append(num2str(intensity),'_',num2str(alpha),'_',num2str(beta),'_',num2str(sigma),'_',num2str(rho));

%훈련 시 사용한 weight matrix 두 개(A,B)와 훈련 시 구한 output weight(W_out)를 불러옵니다.
load(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightA.mat")
load(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightB.mat")
load(num2str(window_num)+"/"+num2str(intensity)+"/Wout.mat")

for reservoir_num = 1:Reservoir_num
    
    if reservoir_num == 1 %test image를 불러오는 과정입니다. 

        [Noise,Noise1,Noise2,input] = approx_test_create_inputNnoise(target,intensity,c,d,e);
        Input = input;
    
    elseif reservoir_num > 1
    
        input(1+l:end-l, 1+l:end-l, 1) = reshape(predictR, c - 2*l, []);
        input(1+l:end-l, 1+l:end-l, 2) = reshape(predictG, c - 2*l, []);
        input(1+l:end-l, 1+l:end-l, 3) = reshape(predictB, c - 2*l, []);

    end
    
    AA = A(:,:,reservoir_num);
    BB = B(:,:,reservoir_num);

    %논문의 genR을 만드는 함수입니다.
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

    %복원된 그림 및 오차를 뽑는 함수
        [Denoising_img,test_clean_img,test_noisy_img,PSNR,RMSE,SSIM] = plot_and_err_(noise_num, input, predictR, predictG, predictB, patch_size);
    
    %복원된 그림 출력
    
    save(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(noise_num)+"/"...
        +file_name+"_R"+num2str(reservoir_num)+".mat","Denoising_img")
    if reservoir_num == Reservoir_num
        
    end
    P_R_S(1,reservoir_num) = PSNR;P_R_S(2,reservoir_num) = RMSE;P_R_S(3,reservoir_num) = SSIM;
    if reservoir_num > 1
        %%%%% fixed reservoir number by experiments %%%%%
        if reservoir_num == Reservoir_num
            DenoisingResult(Input,Denoising_img,window_num,intensity,noise_num,file_name,reservoir_num)
            break
        end
    end
    R_prev = R_concatenate; %concatenate한 state matrix를 다음 reservoir에서 사용하므로, 다른 변수로 설정해서 저장
end

save(num2str(window_num)+"/"+num2str(intensity)+"_"+num2str(noise_num)+"_P_R_S_2.mat","P_R_S");
end