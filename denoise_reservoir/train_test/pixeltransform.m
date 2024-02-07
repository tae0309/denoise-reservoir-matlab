function input = pixeltransform(input)
% pixeltransform 함수는 후추:0 -> 1, 소금:255 -> 254으로 살짝 변경
% noise가 부여된 image에서 noise의 위치를 찾기 전에 
% ground truth에서 이 함수를 실행
[A,B,C]=size(input);
for a=1:A
    for b=1:B
        for c=1:C
            if input(a,b,c)==0
                input(a,b,c)=1;
            elseif input(a,b,c)==255
                input(a,b,c)=254;
            end
        end
    end
end