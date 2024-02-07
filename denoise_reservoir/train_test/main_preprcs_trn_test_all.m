clear;clc;

%%

p = gcp('nocreate');
if p == 0
    numcores = feature('numcores'); 
    parpool(numcores) % the number of physical cores(not logical cores)
end

%%

% select mat file to load parameters
[flnm, pathname] = uigetfile({'*.mat'}, 'File Selector');

filename = strcat(pathname, flnm);
load(filename);

%%

% data preprocess & training start
for window_num = win_num % [50 100 200 500 1000] % the number of training images
    mkdir(num2str(window_num))
    for intensity = intnsty % [0.6 0.8]
        %noise를 얼마나 부여하느냐에 따라 patch size를 지정했습니다.
        mkdir(num2str(window_num)+"/"+num2str(intensity))
        if intensity == 0.2
            patch_size = 3;
        elseif intensity == 0.4 || intensity == 0.6
            patch_size = 5;
        else
            patch_size = 7;
        end
    
        Node_in = 3*patch_size^2;
        %Gaussain filter와 Unsharp masking filter를 만드는 함수입니다. output은 벡터화해서 나타냅니다.
        [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_size^2);
        %Training에 쓰일 input을 만드는 함수입니다.
        [Train_target_collection,Train_input_collection,Imgsize,Noise,Noise1,Noise2,patch_pixels,Res_L,l]=...
            create_noise(Reservoir_num,N,K,rho,sparse,patch_size,window_num,intensity,alpha,beta,sigma);
        %Training을 시행하는 함수입니다.
        [Reservoir,W_out] = training(b,N,K,Reservoir_num,intensity,alpha,beta,gauss_mat,...
            unsh_mat,window_num,Train_input_collection,Train_target_collection,Noise,Noise1,Noise2,Res_L,Imgsize,l,sigma,rho); 
    
        save(num2str(window_num)+"/"+num2str(intensity)+"/Wout.mat","W_out")
    end
end
% data preprocess & training done

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%



% test start
for window_num = win_num % [50 100 200 500 1000] % the number of training images
    for intensity = intnsty % [0.6 0.8]
        %intensity2 = 0.6; 
        %patch_size = 5;
        %[gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_size^2);
        
        % below setting for the intensity following the training setting
        if intensity == 0.2
            patch_size = 3;
        elseif intensity == 0.4 || intensity == 0.6
            patch_size = 5;
        else
            patch_size = 7;
        end

        %Gaussain filter와 Unsharp masking filter를 만드는 함수입니다. output은 벡터화해서 나타냅니다.
        [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_size^2);

        for noise_num=[25] % choose the image number
            mkdir(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(noise_num))
            
            % start test
            % display("patchsize : " + patch_size) % temporary to check
            [predictR,predictG,predictB] = test(noise_num, N, K, b, Reservoir_num, intensity, patch_size, ...
                alpha, beta, sigma, rho, gauss_mat, unsh_mat, window_num);
            % end test
        end
    end
end
% test done