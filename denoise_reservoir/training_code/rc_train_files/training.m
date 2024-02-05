function [Reservoir,W_out,reservoir_num]=training(b,N,K,Reservoir_num,intensity,alpha,beta,gauss_mat,...
        unsh_mat,window_num,Train_input_collection,Train_target_collection,Noise,Noise1,Noise2,Res_L,Imgsize,l,sigma,rho)
window_size = 24; 
R_collection = zeros([Res_L,N*K,window_num]); 
W_out = zeros([N*K*(Reservoir_num*(Reservoir_num+1)/2),3]); 
file_name = append(num2str(intensity),'_',num2str(alpha),'_',num2str(beta),'_',num2str(sigma),'_',num2str(rho));
Train_error_collection = [];

load(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightA.mat")
load(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightB.mat")

t_tictoc = [];
tc_tictoc = [];

for reservoir_num = 1:Reservoir_num
    if reservoir_num > 1
        R_concatenate=R_concatenate_new;
    end
    AA = A(:,:,reservoir_num); 
    BB = B(:,:,reservoir_num); 
    
    t_start=tic;

    parfor (window = 1:window_num) 

        
        [reservoir] = generate_reservoir7(Train_input_collection(:,:,:,window), Noise2, b, N, Imgsize, Imgsize, K, AA, alpha, gauss_mat, unsh_mat, reservoir_num, l);
        %save("0105_1/"+num2str(K)+"/R"+num2str(reservoir_num)+"/"+num2str(window)+".mat","reservoir")
        R_collection(:,:,window) = beta*reservoir ...
            +(1-beta)*tanh(0.5/tanh(0.5)*(reservoir*BB));
        
        
    end 

    if reservoir_num == 1
        Reservoir = 0;
        Target_R = 0;
        Target_G = 0;
        Target_B = 0;
    else
        RCtR = 0;RtR = 0;New_Target_R = 0;New_Target_G = 0;New_Target_B = 0;
    end
    
    R_concatenate_new = zeros([Res_L,N*K*reservoir_num,window_num]);
    
    for window = 1 : window_num

        train_target_imgR = zeros(Imgsize*Imgsize, 1); %400*1
        train_target_imgG = zeros(Imgsize*Imgsize, 1);
        train_target_imgB = zeros(Imgsize*Imgsize, 1);

        count = 0;

        for j = 1+l:Imgsize+l  %==3:22
            for i = 1+l:Imgsize+l
    
                count = count + 1;
                train_target_imgR(count,:) = Train_target_collection(i,j,1,window);
                train_target_imgG(count,:) = Train_target_collection(i,j,2,window);
                train_target_imgB(count,:) = Train_target_collection(i,j,3,window);
    
            end
        end

        if reservoir_num==1
            Reservoir = Reservoir + R_collection(:,:,window)'*R_collection(:,:,window);

            Target_R = Target_R + R_collection(:,:,window)'*train_target_imgR; %40*1
            Target_G = Target_G + R_collection(:,:,window)'*train_target_imgG;
            Target_B = Target_B + R_collection(:,:,window)'*train_target_imgB;

            R_concatenate_new(:,:,window) = R_collection(:,:,window);
        else
            RCtR = RCtR + R_concatenate(:,:,window)'*R_collection(:,:,window);
            RtR = RtR + R_collection(:,:,window)'*R_collection(:,:,window);

            New_Target_R = New_Target_R + R_collection(:,:,window)'*train_target_imgR;
            New_Target_G = New_Target_G + R_collection(:,:,window)'*train_target_imgG;
            New_Target_B = New_Target_B + R_collection(:,:,window)'*train_target_imgB;

            R_concatenate_new(:,:,window) = [R_concatenate(:,:,window) R_collection(:,:,window)]; % R_concatenate(:,:,window): 기존 것,  R_collection(:,:,window):새롭게 만들어진 것
        end
    end

    if reservoir_num > 1
        Reservoir = [Reservoir RCtR;RCtR' RtR];
        Target_R = [Target_R; New_Target_R];
        Target_G = [Target_G; New_Target_G];
        Target_B = [Target_B; New_Target_B];
    end

    R_inv = pinv(Reservoir); 
    Wout1 = R_inv*Target_R;  %40*1
    Wout2 = R_inv*Target_G;
    Wout3 = R_inv*Target_B;
    Wout = [Wout1,Wout2,Wout3];  %40*3
    
    W_out(N*K*reservoir_num*(reservoir_num-1)/2+1:N*K*reservoir_num*(reservoir_num+1)/2,:) = Wout;
    Train_error = 0;

    t_end = toc(t_start);
    t_tictoc = [t_tictoc, t_end];

    for i = 1:window_num
                
        pred = R_concatenate_new(:,:,i) * Wout; % (400x80n) * (80nx3) = 400*3
        count = 0;
                
        for j1 = 1:Imgsize                
            for i1 = 1:Imgsize
                        
                count = count + 1;
                if reservoir_num == 1 
                    a = squeeze((1-Noise1(l+i1,l+j1,:,i)).*Train_input_collection(l+i1,l+j1,:,i))...
                        +squeeze(Noise1(l+i1,l+j1,:,i)).*(pred(count,:))';
                elseif reservoir_num == 2 
                    a = squeeze((1-Noise2(l+i1,l+j1,:,i)).*Train_input_collection(l+i1,l+j1,:,i))...
                        +squeeze(Noise2(l+i1,l+j1,:,i)).*(pred(count,:))';
                else 
                    a = squeeze((1-Noise(l+i1,l+j1,:,i)).*Train_input_collection(l+i1,l+j1,:,i))...
                        +squeeze(Noise(l+i1,l+j1,:,i)).*(pred(count,:))';
                end
                Train_input_collection(l+i1,l+j1,:,i) = a';
                
                for k = 1 : 3 % channel (R, G, B)
                    if Train_input_collection(l+i1,l+j1,k,i) < 0
                        Train_input_collection(l+i1,l+j1,k,i) = 0;
                    elseif Train_input_collection(l+i1,l+j1,k,i) > 1
                        Train_input_collection(l+i1,l+j1,k,i) = 1;
                    end
                end
            end
        end

        Train_error=Train_error+...
            immse(Train_input_collection(l+1:window_size-l,l+1:window_size-l,:,i),...
            Train_target_collection(l+1:window_size-l,l+1:window_size-l,:,i));
    end
    Train_error=Train_error/window_num;
    fprintf('Reservoir %d MSE = %5.8f\n', reservoir_num, Train_error);
    Train_error_collection=[Train_error_collection Train_error];
    
end

tc_cum = 0;
for ele = t_tictoc
    tc_cum = tc_cum + ele;
    tc_tictoc = [tc_tictoc, tc_cum];
end

save(num2str(window_num)+"_"+num2str(intensity)+".mat","Train_error_collection")

figure(1);
% title('Training time')
xlabel('Recursion iteration')
ylabel('Training time (seconds)')

str_legend_t = ['Train=', num2str(window_num), ', intensity=', num2str(intensity)];
plot(1:Reservoir_num, t_tictoc, LineStyle="-", Marker="o", DisplayName=str_legend_t)
legend(Location = "northwest")
hold on

figure(2);
% title('Cumulative Training time')
xlabel('Recursion iteration')
ylabel('Cumulative Training time (seconds)')

str_legend_tc = ['Train=', num2str(window_num), ', intensity=', num2str(intensity)];
plot(1:Reservoir_num, tc_tictoc, LineStyle="--", Marker="*", DisplayName=str_legend_t)
legend(Location = "northwest")
hold on

end