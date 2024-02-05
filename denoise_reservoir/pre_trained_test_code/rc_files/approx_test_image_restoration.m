function [predictR,predictG,predictB] = approx_test_image_restoration(R_concatenate,W_out,Noise,c,d,l,input,reservoir_num,N,K)

predictR = R_concatenate * W_out(N*K*reservoir_num*(reservoir_num-1)/2+1:N*K*reservoir_num*(reservoir_num+1)/2,1);
predictG = R_concatenate * W_out(N*K*reservoir_num*(reservoir_num-1)/2+1:N*K*reservoir_num*(reservoir_num+1)/2,2);
predictB = R_concatenate * W_out(N*K*reservoir_num*(reservoir_num-1)/2+1:N*K*reservoir_num*(reservoir_num+1)/2,3);

for j1 = 1+l:d-l                
    for i1 = 1+l:c-l
        predictR(i1-l+(c-2*l)*(j1-l-1)) = (1-Noise(i1,j1,1))*input(i1,j1,1)...
            +Noise(i1,j1,1)*predictR(i1-l+(c-2*l)*(j1-l-1));
        predictG(i1-l+(c-2*l)*(j1-l-1)) = (1-Noise(i1,j1,2))*input(i1,j1,2)...
            +Noise(i1,j1,2)*predictG(i1-l+(c-2*l)*(j1-l-1));
        predictB(i1-l+(c-2*l)*(j1-l-1)) = (1-Noise(i1,j1,3))*input(i1,j1,3)...
            +Noise(i1,j1,3)*predictB(i1-l+(c-2*l)*(j1-l-1));
        if predictR(i1-l+(c-2*l)*(j1-l-1)) < 0
            predictR(i1-l+(c-2*l)*(j1-l-1)) = 0;
        elseif predictR(i1-l+(c-2*l)*(j1-l-1)) > 1
            predictR(i1-l+(c-2*l)*(j1-l-1)) = 1;
        end
        if predictG(i1-l+(c-2*l)*(j1-l-1)) < 0
            predictG(i1-l+(c-2*l)*(j1-l-1)) = 0;
        elseif predictG(i1-l+(c-2*l)*(j1-l-1)) > 1
            predictG(i1-l+(c-2*l)*(j1-l-1)) = 1;
        end
        if predictB(i1-l+(c-2*l)*(j1-l-1)) < 0
            predictB(i1-l+(c-2*l)*(j1-l-1)) = 0;
        elseif predictB(i1-l+(c-2*l)*(j1-l-1)) > 1
            predictB(i1-l+(c-2*l)*(j1-l-1)) = 1;
        end
    end
end

end