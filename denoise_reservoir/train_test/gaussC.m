function val = gaussC(x, y, sigma, center)
% convolution 곱을 하기 위한 행렬의 각 위치에 해당하는 gaussian distribution값 1개를 생성
%5by5 patch 기준
%x,y : 좌표
%sigma==1
%center==[3,3]

xc = center(1);  %==3
yc = center(2);  %==3
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma^2);
val      = (exp(-exponent))/(sigma*sqrt(2*pi));