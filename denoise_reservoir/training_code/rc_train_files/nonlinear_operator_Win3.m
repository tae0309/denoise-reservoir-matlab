function [Win] = nonlinear_operator_Win3(N,input,gauss_mat,unsh_mat,noise)


    Node_in = size(input,2);         %==75
    Win = zeros([Node_in,N]);        %75*10 : Ada_mean(RGB:3), Ada_gau(RGB:3), unsharp(RGB:3), zero_column(1) 
    patch_pixels = Node_in/3;        %==25 
    %patch_size = sqrt(patch_pixels); %==5
    
    column_count=0;
    
%% Mean 
    for rgb = 0:2 

        column_count = column_count + 1;
        RGB = patch_pixels * rgb;  
        num = 0;
        
        for i=1:patch_pixels  %i==1:25
            
            if noise(RGB + i) == 0   
                num = num+1;
                Win(RGB + i, column_count) = 1; 
            end
        end
        
        if num > 0  
            Win(:,column_count) = Win(:,column_count) / num;
        else           
            if sum(input(RGB + 1 : RGB + patch_pixels) == 0) > sum(input(RGB + 1 : RGB + patch_pixels) == 1)
                for i = 1:patch_pixels
                    if input(RGB + i) == 0
                        num = num + 1; 
                        Win(RGB + i,column_count) = 1; 
                    end    
                end
            else
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
    
%% Gaussian
    for rgb = 0:2
        column_count  = column_count+1;
        RGB = patch_pixels*rgb;
        num=0;
        for i=1:patch_pixels
            if noise(RGB + i) == 0
                num=num+1;
                Win(RGB + i, column_count)=1; 
            end
        end

        Win(RGB + 1:RGB + patch_pixels, column_count)=gauss_mat.*Win(RGB + 1:RGB + patch_pixels, column_count);
        
        total=0; 
        
        for i=1:patch_pixels
            if noise(RGB + i) == 0
                total = total + Win(RGB + i,column_count);
            end
        end
       
       if total>0 
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

%% Unsharp    
    for rgb = 0:2
        
        column_count = column_count + 1;
        RGB = patch_pixels*rgb;
        num=0;
        for i=1:patch_pixels
            if noise(RGB + i) == 0
                num=num+1;
                Win(RGB + i,column_count)=1; 
            end
        end
        
        Win(RGB + 1:RGB + patch_pixels,column_count)=unsh_mat.*Win(RGB + 1:RGB + patch_pixels, column_count);
        
        total = 0;
        
        for i=1:patch_pixels
            if noise(RGB + i) == 0
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
