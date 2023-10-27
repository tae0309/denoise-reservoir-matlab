function DenoisingResult(Input,Denoising_img,window_num,intensity,noise_num,file_name,reservoir_num)
f=figure(1);
subplot(1,2,1)
imshow(Input)
subplot(1,2,2)
imshow(Denoising_img);
exportgraphics(f,num2str(window_num)+"/"+num2str(intensity)+"/"+num2str(noise_num)+"/"...
    +file_name+"_R"+num2str(reservoir_num)+".jpg")
end