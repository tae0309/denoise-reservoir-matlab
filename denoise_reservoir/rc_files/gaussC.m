function val = gaussC(x, y, sigma, center)
% convolution by gaussian distribution
% 5 by 5 patch
% x,y : index(coordinates)
% sigma==1
% center==[3,3]

xc = center(1);  %==3
yc = center(2);  %==3
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma^2);
val      = (exp(-exponent))/(sigma*sqrt(2*pi));