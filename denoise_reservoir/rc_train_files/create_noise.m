function [Train_target_collection,Train_input_collection,Imgsize,Noise,Noise1,Noise2,patch_pixels,Res_L,l]=...
    create_noise(Reservoir_num,N,K,rho,sparse,patch_size,window_num,intensity,alpha,beta,sigma)
train_windows_path = 'train_windows/'; % training data의 경로
l = (patch_size - 1)/2;     %==2 % patch matrix의 center를 제외한 왼쪽 column수
patch_pixels = patch_size^2;%==25 % patch의 pixel의 수, 정방행렬이니까 제곱
window_size = 24; % training data image의 size(여기서는 24x24)
Imgsize = window_size - 2*l; %==20 % 5x5 patch인 경우에 위 아래로 2행 왼 오로 2열 제외한 training 이미지를 복원할 예정
Res_L = (window_size -2*l)^2; % 복원되는 training image(20x20)의 pixel의 개수
Train_target_collection = zeros([window_size,window_size,3,window_num]); % training image들의 ground truth이미지 모음을 만들기 위하여 선언
Train_input_collection = zeros([window_size,window_size,3,window_num]); % training image들의 noise 이미지 모음을 만들기 위하여 선언 
Noise = zeros([window_size,window_size,3,window_num]); %  noise의 위치를 나타내기 위하여 선언
Noise1 = zeros([window_size,window_size,3,window_num]); % noise의 위치 partition- 나눠주기 위해여 선언
file_name=append(num2str(intensity),'_',num2str(alpha),'_',num2str(beta),'_',num2str(sigma),'_',num2str(rho));
s = RandStream('mlfg6331_64'); 
for window = 1:window_num % traing data(image) 수  

    Train_target_Batch = im2double(pixeltransform(imread([train_windows_path, num2str(window), '.png']))); 
    Train_target_collection(:,:,:,window) = Train_target_Batch;    %(ground truth)
    Train_input_collection(:,:,:,window) = imnoise(Train_target_Batch,'salt & pepper',intensity);
    for k = 1 : 3 % channel 
        pixel_position=[]; % noise의 위치를 나타내주는 변수(scalar 값이 들어간다. - vector 아님 ex=[4, 100, 270, 290...])
        for j = 1 : window_size
            for i = 1 : window_size
                Noise(i,j,k,window) = (Train_input_collection(i,j,k,window) == 0 || Train_input_collection(i,j,k,window) == 1); % 0: peeper, 1: salt noise
                if Noise(i,j,k,window) == 1 %해당 pixel의 위치가 noise인 경우, 변수 pixel_position에 저장
                    pixel_position=[pixel_position i+window_size*(j-1)]; %이 변수는 noise partition할 때 사용됩니다.
                end
            end
        end

        y = datasample(s,pixel_position,ceil(length(pixel_position)/2),'Replace',false); % noise의 위치를 임의의 갯수를 뽑아서 저장
        ii=[];jj=[]; % noise가 있는 i - 행위치, j - 열위치
        
        % scalar로 계산된 noise위치를 역연산하여 ii(행), jj(열)를 구하기 위함 :
        % pixel_position=[pixel_position i+window_size*(j-1) 와 비교
        for yy=y
            if rem(yy,window_size)==0
                ii = [ii window_size];
            else
                ii = [ii rem(yy,window_size)];
            end
            jj = [jj ceil(yy/window_size)];
        end
                
        for i=1:length(ii)
            Noise1(ii(i),jj(i),k,window) = 1; %그 위치를 변수 Noise1에 저장
        end
    end
    Noise2=Noise-Noise1; %나머지 위치는 변수 Noise2에 저장
end

%훈련 및 test에 쓰일 weight matrix를 만드는 과정입니다.
A = zeros(N,N,Reservoir_num);B = zeros(N*K,N*K,Reservoir_num);
for i = 1 : Reservoir_num
    A(:,:,i)=create_relation_matrix(N,rho,sparse);
    B(:,:,i)=create_relation_matrix(N*K,rho,sparse);
end
%이렇게 만들어진 matrix는 저장해서 훈련 및 test에 쓰입니다.
save(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightA.mat","A")
save(num2str(window_num)+"/"+num2str(intensity)+"/"...
    +file_name+"_WeightB.mat","B")

end