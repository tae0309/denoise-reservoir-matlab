function input = pixeltransform(input)

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