function mat = gauss2d(mat, sigma, center)
% gaussC에서 구해진 gaussian distribution으로부터
% 행렬을 만든다.
%5by5 patch 기준
%mat==zeros(5)
%sigma==1
%center==[3,3]

gsize = size(mat); %==(5,5)

for r=1:gsize(1)
    for c=1:gsize(2)
        mat(r,c) = gaussC(r,c, sigma, center); %각 filter의 성분의 값을 구하는 함수
    end
end
