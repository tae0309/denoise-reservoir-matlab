function mat = gauss2d(mat, sigma, center)
% create matrix from gaussian distribution made by gaussC
% 5 by 5 patch
% mat==zeros(5)
% sigma==1
% center==[3,3]

gsize = size(mat); %==(5,5)

for r=1:gsize(1)
    for c=1:gsize(2)
        mat(r,c) = gaussC(r,c, sigma, center); 
    end
end
