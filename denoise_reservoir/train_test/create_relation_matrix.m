function A=create_relation_matrix(N,rho,sparse)
% spectral radius가 1 미만인 sparse matrix를 생성하기 위한 함수

A=rand(N,N);
%B=A';A=(A+B)/2;
%A=double((A>0.5)).*A;

%A=zeros(N);
%while 1
%    r = rand(N,N);
%    A = (r>0.5);
    %{
    for i=1:N
        for j=i+1:N
            A(i,j)=A(j,i);
        end
    end
    if max(abs(eig(double(A))))<1
        break
    end
    %}
%end

A=reshape(A,[1,N*N]);

if sparse ~=1
    J=1:N*N;
    Sparse=ceil(N*N*(1-sparse));
    for i=1:Sparse
        j=randi([1 N*N-i+1]);
        A(J(j))=0;
        J(j)=[];
    end
end
A=reshape(A,[N,N]);

%A=random('Normal',0,1,[N,N]);
%r=rand(N,N);theta=2*pi*rand(N,N);A=r.*exp(1i*theta);



A=rho*A/max(abs(eig(A)));  %절댓값의 최댓값이 spectral radius이 rho가 된다.

end