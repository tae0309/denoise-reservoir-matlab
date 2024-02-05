function [reservoir2] = generate_reservoir7(xi1, xi2, b, N, c, d, K, A, alpha, gauss_mat, unsh_mat, Reservoir_num, l)


reservoir = zeros(c*d, N); 
reservoir2 = zeros(c*d, N*K);
for k = 1 : K
    if k == 1
        parfor (count = 1 : c*d)
            i = count - c*(ceil(count/c)-1) + l;j = ceil(count/c) + l; 
            input = reshape(xi1(i-l:i+l,j-l:j+l,:),1,[]); 
            noise = reshape(xi2(i-l:i+l,j-l:j+l,:),1,[]); 
            if Reservoir_num==2
                
                Win = nonlinear_operator_Win3(N,input,gauss_mat,unsh_mat,noise);
            else
                Win = nonlinear_operator_Win(N,input,gauss_mat,unsh_mat);
            end
           
            reservoir(count,:) = tanh(b+(input*Win)); 
        end
        reservoir2(:,1:N) = reservoir;
    else
        
        reservoir2(:,N*(k-1)+1:N*k) = alpha*reservoir2(:,N*(k-2)+1:N*(k-1)) ...
            +(1-alpha)*tanh(0.5/tanh(0.5)*reservoir2(:,N*(k-2)+1:N*(k-1))*A);
    end
end
 
end