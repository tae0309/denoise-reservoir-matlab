clear all;clc;
delete(gcp('nocreate')); % if there is the parpool session, finish parpool idle time immediately
numcores = feature('numcores'); 
parpool(numcores) % the number of physical cores(not logical cores)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% No need to change

    N = 10;  %mean : 3, gaussian : 3, unsharp : 3, zero column : 1
    b = -0.5 * ones([1,N]);    %input*Win의 범위가 0이상 1이하
    Reservoir_num = 6; % Reservoir_num = 20;     
    alpha = 0.5;
    beta = 0.9;
    sigma = 1; %standard deviation of gaussian distribution
    rho = 0.9; %spectral radius of matrix
    sparse = 1;
    M = 10;
    K = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

% test start
for window_num = [50] % [50 100 200 500 1000] % the number of training images
    for intensity = [0.8] % [0.6 0.8]
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

        for noise_num=[3] % [1 3 13 25 26 39 53 66 69 74] : names of images in the "test_set" folder
            mkdir(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(noise_num))
            
            % start test
            [predictR,predictG,predictB] = test(noise_num, N, K, b, Reservoir_num, intensity, patch_size, ...
                alpha, beta, sigma, rho, gauss_mat, unsh_mat, window_num);
            % end test
        end
    end
end
% test done

delete(gcp('nocreate')); % if there is the parpool session, finish parpool idle time immediately