function [gauss_mat,unsh_mat]=create_gauss_mat(sigma,patch_size,patch_pixels)
% =====
% gaussian filter를 만드는 과정
%sigma : 표준편차
gauss_mat = gauss2d(zeros(patch_size), sigma, [(patch_size+1)/2,(patch_size+1)/2]);%gaussian filter를 만드는 함수
gauss_mat = reshape(gauss_mat,[],1); % 윗줄에서 만든 행렬을 벡터화 - 2열을 1열 밑으로, 3열을 2열 밑으로...반복

% =====
%unsharp masking filter를 만드는 과정
unsh_mat = gauss_mat; unsh_mat((patch_pixels+1)/2) = 0;
unsh_mat((patch_pixels+1)/2) = - sum(unsh_mat(:)) - sum(gauss_mat(:));
unsh_mat = - unsh_mat;
end