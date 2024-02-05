function [Train_target_collection,Train_input_collection,Imgsize,Noise,Noise1,Noise2,patch_pixels,Res_L,l]=...
    create_noise(Reservoir_num,N,K,rho,sparse,patch_size,window_num,intensity,alpha,beta,sigma)
train_windows_path = 'train_windows/'; 
l = (patch_size - 1)/2;     
patch_pixels = patch_size^2;
window_size = 24; 
Imgsize = window_size - 2*l; 
Res_L = (window_size -2*l)^2; 
Train_target_collection = zeros([window_size,window_size,3,window_num]); 
Train_input_collection = zeros([window_size,window_size,3,window_num]);  
Noise = zeros([window_size,window_size,3,window_num]); 
Noise1 = zeros([window_size,window_size,3,window_num]); 
file_name=append(num2str(intensity),'_',num2str(alpha),'_',num2str(beta),'_',num2str(sigma),'_',num2str(rho));
s = RandStream('mlfg6331_64'); 
for window = 1:window_num 

    Train_target_Batch = im2double(pixeltransform(imread([train_windows_path, num2str(window), '.png']))); 
    Train_target_collection(:,:,:,window) = Train_target_Batch; 
    Train_input_collection(:,:,:,window) = imnoise(Train_target_Batch,'salt & pepper',intensity);
    for k = 1 : 3 % channel 
        pixel_position=[]; 
        for j = 1 : window_size
            for i = 1 : window_size
                Noise(i,j,k,window) = (Train_input_collection(i,j,k,window) == 0 || Train_input_collection(i,j,k,window) == 1); 
                if Noise(i,j,k,window) == 1 
                    pixel_position=[pixel_position i+window_size*(j-1)]; 
                end
            end
        end

        y = datasample(s,pixel_position,ceil(length(pixel_position)/2),'Replace',false); 
        ii=[];jj=[]; 
        
        for yy=y
            if rem(yy,window_size)==0
                ii = [ii window_size];
            else
                ii = [ii rem(yy,window_size)];
            end
            jj = [jj ceil(yy/window_size)];
        end
                
        for i=1:length(ii)
            Noise1(ii(i),jj(i),k,window) = 1; 
        end
    end
    Noise2=Noise-Noise1; 
end

A = zeros(N,N,Reservoir_num);B = zeros(N*K,N*K,Reservoir_num);
for i = 1 : Reservoir_num
    A(:,:,i)=create_relation_matrix(N,rho,sparse);
    B(:,:,i)=create_relation_matrix(N*K,rho,sparse);
end

save(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightA.mat","A")
save(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightB.mat","B")

end