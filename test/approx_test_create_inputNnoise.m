function [Noise,Noise1,Noise2,input] = approx_test_create_inputNnoise(target,intensity,c,d,e)

input = imnoise(target,'salt & pepper',intensity);
NoiseBlack = input == 0;
NoiseWhite = input == 1;
Noise = NoiseBlack + NoiseWhite;

Noise1 = zeros([c,d,e]);
s = RandStream('mlfg6331_64');
for k = 1 : 3
    NoiseSum = sum(sum(Noise(:,:,k)));
    pixel_position=zeros(1,NoiseSum);
    count = 0;
    for j = 1 : d
        for i = 1 : c
            if Noise(i,j,k) == 1
                count = count + 1;
                pixel_position(1,count)=i+c*(j-1);
            end
        end
    end
            
    y = datasample(s,pixel_position,ceil(length(pixel_position)/2),'Replace',false);
    for yy=y
        if rem(yy,c)==0
            jj = c;
        else
            jj = rem(yy,c);
        end
            Noise1(jj,ceil(yy/c),k) = 1;
    end
end
Noise2=Noise-Noise1;

end