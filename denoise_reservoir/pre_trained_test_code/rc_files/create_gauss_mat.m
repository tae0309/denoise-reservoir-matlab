function [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_pixels)
% =====
% sigma : standard deviation
gauss_mat = gauss2d(zeros(patch_size), sigma, [(patch_size+1)/2,(patch_size+1)/2]); % make gaussian filter
gauss_mat = reshape(gauss_mat,[],1); % vectorize and concatenate (i+1)-th column below (i)-th column 

% =====
% create unsharp masking filter
unsh_mat = gauss_mat; unsh_mat((patch_pixels+1)/2) = 0;
unsh_mat((patch_pixels+1)/2) = - sum(unsh_mat(:)) - sum(gauss_mat(:));
unsh_mat = - unsh_mat;
end