function main_module(testImage,intensity,window_num,Reservoir_num)
    p = gcp('nocreate');
    if p == 0
    %delete(gcp('nocreate')); % if there is the parpool session, finish parpool idle time immediately
        numcores = feature('numcores'); 
        parpool(numcores) % the number of physical cores(not logical cores)
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    %   Pre-set parameters
    
        N = 10;   % The size of a reservoir state vector : 1 x N
        b = -0.5 * ones([1,N]);    % Bias vector b 
%         Reservoir_num = 15;        % Reservoir_num <= 20;     
%         if Reservoir_num > 20
%             disp('The current trained network used at most 20 reservoirs. So, we will set it to be 20');
%             Reservoir_num  = 20;
%         end
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

    % make Gaussain filter & Unsharp masking filter, output : vector
    [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_size^2);

    folderName = strcat(num2str(window_num),'/',num2str(intensity),'/',num2str(testImage));
    if ~exist(folderName,"dir")
        mkdir(folderName);
    end
    %         mkdir(num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(testImage))
    
    % start test
    [predictR,predictG,predictB] = test(testImage, N, K, b, Reservoir_num, intensity, patch_size, ...
        alpha, beta, sigma, rho, gauss_mat, unsh_mat, window_num);
    % end test
end
% test done

%delete(gcp('nocreate')); % if there is the parpool session, finish parpool idle time immediately