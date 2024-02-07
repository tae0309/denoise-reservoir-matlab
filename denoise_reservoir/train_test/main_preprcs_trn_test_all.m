clear;clc;


p = gcp('nocreate');
if p == 0
    numcores = feature('numcores'); 
    parpool(numcores) 
end


[flnm, pathname] = uigetfile({'*.mat'}, 'File Selector');

filename = strcat(pathname, flnm);
load(filename);


% data preprocess & training start
for window_num = win_num 
    mkdir(num2str(window_num))
    for intensity = intnsty 
        mkdir(num2str(window_num)+"/"+num2str(intensity))
        if intensity == 0.2
            patch_size = 3;
        elseif intensity == 0.4 || intensity == 0.6
            patch_size = 5;
        else
            patch_size = 7;
        end
    
        Node_in = 3*patch_size^2;
        [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_size^2);
        [Train_target_collection,Train_input_collection,Imgsize,Noise,Noise1,Noise2,patch_pixels,Res_L,l]=...
            create_noise(Reservoir_num,N,K,rho,sparse,patch_size,window_num,intensity,alpha,beta,sigma);
        [Reservoir,W_out] = training(b,N,K,Reservoir_num,intensity,alpha,beta,gauss_mat,...
            unsh_mat,window_num,Train_input_collection,Train_target_collection,Noise,Noise1,Noise2,Res_L,Imgsize,l,sigma,rho); 
    
        save(num2str(window_num)+"/"+num2str(intensity)+"/Wout.mat","W_out")
    end
end
% data preprocess & training done


for window_num = win_num 
    for intensity = intnsty 
        
        if intensity == 0.2
            patch_size = 3;
        elseif intensity == 0.4 || intensity == 0.6
            patch_size = 5;
        else
            patch_size = 7;
        end

        [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_size^2);

        for noise_num=[25] % choose the image number
            mkdir(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(noise_num))
            

            [predictR,predictG,predictB] = test(noise_num, N, K, b, Reservoir_num, intensity, patch_size, ...
                alpha, beta, sigma, rho, gauss_mat, unsh_mat, window_num);
        end
    end
end