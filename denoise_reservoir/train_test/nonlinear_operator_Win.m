function [Win] = nonlinear_operator_Win(N,input,gauss_mat,unsh_mat)
%N=10
%input : 75차원 벡터. 1~25성분은 r,26~50성분은 g,51~75성분은 b

    Node_in = size(input,2);         %==75
    Win = zeros([Node_in,N]);        %75*10    
    patch_pixels = Node_in/3;        %==25
    patch_size = sqrt(patch_pixels); %==5
    
    column_count=0;
    
%% Adaptive Mean을 이용하여 inpu Weight(Win)을 만드는 과정
    for rgb = 0:2
        
        column_count = column_count + 1;
        RGB = patch_pixels * rgb;  %red이면 RGB==0,green이면 RGB==25,blue이면 RGB==50
        num = 0;
        
        for i=1:patch_pixels  %i==1:25
            if input(RGB + i) > 0 && input(RGB + i) < 1   %소금후추가 아닌 pixel들 분류      
                num = num+1;
                Win(RGB + i, column_count) = 1;          %소금후추가 아닌 pixel의 Win값은 1로 설정
            end
        end
        
        if num > 0 %    %소금후추가 아닌 pixel의 갯수 만큼 나눔
            Win(:,column_count) = Win(:,column_count) / num;
        else % patch로 받은 pixel들이 전부 noise인 경우
            if sum(input(RGB + 1 : RGB + patch_pixels) == 0) > sum(input(RGB + 1 : RGB + patch_pixels) == 1)
                % sum(input(RGB + 1 : RGB + patch_pixels) == 0) : 하나의 patch 전체중 후추의 값의 합을 나타낸다.
                %후추가 많은 경우, 후추pixel의 Win값을 1로 설정
                for i = 1:patch_pixels
                    if input(RGB + i) == 0
                        num = num + 1; 
                        Win(RGB + i,column_count) = 1; 
                    end    
                end
            else
                %소금이 많은 경우, 소금pixel의 Win값을 1로 설정
                for i=1:patch_pixels
                    if input(RGB + i) == 1
                        num = num + 1;
                        Win(RGB + i,column_count) = 1;
                    end 
                end
            end
            Win(:,column_count) = Win(:,column_count)/num;
        end
   
    end
    %column_count==3
    
%% Adaptive Gaussian을 이용하여 inpu Weight(Win)을 만드는 과정
    for rgb = 0:2
        column_count  = column_count+1;
        RGB = patch_pixels*rgb;
        num=0;
        for i=1:patch_pixels
            if input(RGB + i)>0 && input(RGB + i)<1
                num=num+1;
                Win(RGB + i, column_count)=1; 
            end
        end
        %gauss matrix랑 pointwise 곱셈
        Win(RGB + 1:RGB + patch_pixels, column_count)=gauss_mat.*Win(RGB + 1:RGB + patch_pixels, column_count);
        
        total=0;%소금후추가 아닌 pixel에 관한 값들은 다 더하고자 함
        
        for i=1:patch_pixels
            if input(patch_pixels*rgb+i)>0 && input(patch_pixels*rgb+i)<1
                total = total + Win(RGB + i,column_count);
            end
        end
       
       if total>0 %나눠서 평균을 냄
            Win(:,column_count) = Win(:,column_count)/total;
        else
            if sum(input(RGB + 1:RGB + patch_pixels)==0)>sum(input(RGB + 1:RGB + patch_pixels)==1)
                for i=1:patch_pixels
                    if input(RGB + i)==0
                        num = num+1;
                        Win(RGB + i,column_count)=1;
                    end    
                end
            else
                for i=1:patch_pixels
                    if input(RGB + i)==1
                        num=num+1;
                        Win(RGB + i,column_count)=1;
                   end 
                end
            end
            Win(:,column_count)=Win(:,column_count)/num;
       end
    end

%% Unsharp masking을 이용하여 inpu Weight(Win)을 만드는 과정
%gauss_mat대신 unsh_mat대입    
    for rgb = 0:2
        
        column_count = column_count + 1;
        RGB = patch_pixels*rgb;
        num=0;
        for i=1:patch_pixels
            if input(RGB + i)>0 && input(RGB + i)<1
                num=num+1;
                Win(RGB + i,column_count)=1; 
            end
        end
        
        Win(RGB + 1:RGB + patch_pixels,column_count)=unsh_mat.*Win(RGB + 1:RGB + patch_pixels, column_count);
        
        total = 0;
        
        for i=1:patch_pixels
            if input(RGB + i)>0 && input(RGB + i)<1
                total = total + Win(RGB + i,column_count);
            end
        end
       
        if total ~= 0
            Win(:,column_count) = Win(:,column_count)/total;
        else
            if sum(input(RGB + 1:RGB + patch_pixels) == 0) > sum(input(RGB + 1:RGB + patch_pixels) == 1)
                for i = 1:patch_pixels
                    if input(RGB + i) == 0
                        num = num+1;
                        Win(RGB + i,column_count)=1;
                    end    
                end
            else
                for i = 1:patch_pixels
                    if input(RGB + i) == 1
                        num = num+1;
                        Win(RGB + i, column_count)=1;
                   end 
                end
            end
            Win(:, column_count) = Win(:, column_count) / num;
        end
    end
    
    

    
