function [reservoir2] = generate_reservoir7(xi1, xi2, b, N, c, d, K, A, alpha, gauss_mat, unsh_mat, Reservoir_num, l)
% xi1: flattened input vector (==train_input_img)
% xi2: flattened noise vector (==train_noise_img)
% b: bias (==-0.5 * ones([1,N]))
% Res_L: the number of reservoir state vectors (==size(train_input_img,1)==400)
% N=10
% c : 세로 pixel의 갯수, d : 가로 pixel의 갯수

% reservoir state vector를 모아놓기 위한 matrix를 reservoir라고 선언해주었다.
reservoir = zeros(c*d, N); % 초기에 뽑은 state vector들의 모음, parfor 문을 시행하기 위해 일부러 이렇게 설정했습니다.
reservoir2 = zeros(c*d, N*K); % reservoir2가 reservoir state matrix(400 x (1x10) x 4(=K)) = (400 x 40)를 의미한다.
for k = 1 : K
    if k == 1
        parfor (count = 1 : c*d)
            i = count - c*(ceil(count/c)-1) + l;j = ceil(count/c) + l; % 각 patch의 중심 (i, j) -> parfor를 위함
            input = reshape(xi1(i-l:i+l,j-l:j+l,:),1,[]); % 1,[] 인자: vectorize (열벡터만든다.)
            noise = reshape(xi2(i-l:i+l,j-l:j+l,:),1,[]); 
            if Reservoir_num==2
                %변수 Noise2에서 잡은 noise만 noise로 취급합니다.
                Win = nonlinear_operator_Win3(N,input,gauss_mat,unsh_mat,noise);
            else
                Win = nonlinear_operator_Win(N,input,gauss_mat,unsh_mat);
            end
            %iiiii=reshape(sum(sum(cat(4,input,input,input).*Win)),[1,N-1]);
            %reservoir(count,:) = tanh(b+[iiiii,0]);
            reservoir(count,:) = tanh(b+(input*Win)); % input: 1x75, Win:75x10
        end
        reservoir2(:,1:N) = reservoir;
    else
        %reservoir state vector를 더 뽑는 과정.
        %코드에서는 concatenate를 먼저 해서 행렬화를 하고 state vector를 뽑았는데, 
        %state vector를 먼저 뽑고, 나중에 concatenate를 해도 상관없습니다.
        reservoir2(:,N*(k-1)+1:N*k) = alpha*reservoir2(:,N*(k-2)+1:N*(k-1)) ...
            +(1-alpha)*tanh(0.5/tanh(0.5)*reservoir2(:,N*(k-2)+1:N*(k-1))*A);
    end
    
end
% display("size(reservoir) = " + size(reservoir))
% display("size(reservoir2) = " + size(reservoir2))
 
end