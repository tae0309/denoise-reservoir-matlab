function training_module(set_window_num, set_intensity)

    p = gcp('nocreate');
    if p == 0
        numcores = feature('numcores');
        parpool(numcores)
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre-set parameters

    N = 10; % The size of a reservoir state vector : 1 x N
    b = -0.5 * ones([1,N]); % Bias vector b
    Reservoir_num = 20; % Reservoir number
    alpha = 0.5;
    beta = 0.9;
    sigma = 1; % standard deviation of gaussian distribution
    rho = 0.9; % spectral radius of matrix
    sparse = 1;
    % M = 10;
    K = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

% data preprocess & training start
for window_num = [set_window_num] % [50] % [50 100 200 500 1000] % the number of training images
    mkdir(num2str(window_num))
    for intensity = [set_intensity] % [0.8] % [0.6 0.8]
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
        [gauss_mat,unsh_mat] = create_gauss_mat(sigma,patch_size,patch_size^2);
        %Training에 쓰일 input을 만드는 함수입니다.
        [Train_target_collection,Train_input_collection,Imgsize,Noise,Noise1,Noise2,patch_pixels,Res_L,l] = ...
            create_noise(Reservoir_num,N,K,rho,sparse,patch_size,window_num,intensity,alpha,beta,sigma);
        %Training을 시행하는 함수입니다.
        [Reservoir,W_out] = training(b,N,K,Reservoir_num,intensity,alpha,beta,gauss_mat,...
            unsh_mat,window_num,Train_input_collection,Train_target_collection,Noise,Noise1,Noise2,Res_L,Imgsize,l,sigma,rho); 
    
        save(num2str(window_num)+"/"+num2str(intensity)+"/Wout.mat","W_out")
    end
end
% data preprocess & training done
end