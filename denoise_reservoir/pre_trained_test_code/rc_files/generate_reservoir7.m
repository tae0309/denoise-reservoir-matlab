function [reservoir2] = generate_reservoir7(xi1, xi2, b, N, c, d, K, A, alpha, gauss_mat, unsh_mat, Reservoir_num, l)
% xi1: flattened input vector (==train_input_img)
% xi2: flattened noise vector (==train_noise_img)
% b: bias (==-0.5 * ones([1,N]))
% Res_L: the number of reservoir state vectors (==size(train_input_img,1)==400)
% N=10
% c : num of the height pixels, d : num of width pixel

% reservoir : the matrix by cumulative reservoir state vector
reservoir = zeros(c*d, N); % initial state vectors, to employ parfor
reservoir2 = zeros(c*d, N*K); % reservoir2: reservoir state matrix(400 x (1x10) x 4(=K)) = (400 x 40)
for k = 1 : K
    if k == 1
        parfor (count = 1 : c*d)
            i = count - c*(ceil(count/c)-1) + l;j = ceil(count/c) + l; % center of the each patch (i, j) -> to emply parfor
            input = reshape(xi1(i-l:i+l,j-l:j+l,:),1,[]); % to vectorize : input as 1,[] 
            noise = reshape(xi2(i-l:i+l,j-l:j+l,:),1,[]); 
            if Reservoir_num==2
                Win = nonlinear_operator_Win3(N,input,gauss_mat,unsh_mat,noise);
            else
                Win = nonlinear_operator_Win(N,input,gauss_mat,unsh_mat);
            end
            reservoir(count,:) = tanh(b+(input*Win)); % input: 1x75, Win:75x10
        end
        reservoir2(:,1:N) = reservoir;
    else
        % get more reservoir state vector
        reservoir2(:,N*(k-1)+1:N*k) = alpha*reservoir2(:,N*(k-2)+1:N*(k-1)) ...
            +(1-alpha)*tanh(0.5/tanh(0.5)*reservoir2(:,N*(k-2)+1:N*(k-1))*A);
    end
end
 
end