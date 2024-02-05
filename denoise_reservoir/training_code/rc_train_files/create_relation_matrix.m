function A=create_relation_matrix(N,rho,sparse)

A=rand(N,N);

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

A=rho*A/max(abs(eig(A)));  
end