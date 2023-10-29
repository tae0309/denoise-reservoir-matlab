function DenoisingResult(Input,Denoising_img,test_clean_img,window_num,intensity,noise_num,file_name,reservoir_num)
f=figure(1);
set(f,'Position',[200,200,1600,500])
subplot(1,3,1)
imshow(Input);title(['Noisy image with ' num2str(intensity*100) '% noise'],'FontSize',16)
subplot(1,3,2)
imshow(Denoising_img);title(['Denoised image by R-RC with ' num2str(reservoir_num) ' reservoirs'],'FontSize',16)
subplot(1,3,3)
imshow(test_clean_img);title('Noise-free original','FontSize',16)
exportgraphics(f,num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(noise_num)+"/"...
    +file_name+"_R"+num2str(reservoir_num)+".jpg")
end