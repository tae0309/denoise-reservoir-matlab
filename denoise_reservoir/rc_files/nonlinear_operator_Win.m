function [Win] = nonlinear_operator_Win(N,input,gauss_mat,unsh_mat)
% N=10
% input : 75dim vector -> 1~25:r, 26~50:g, 51~75:b

    Node_in = size(input,2);         % ==75
    Win = zeros([Node_in,N]);        % 75*10    
    patch_pixels = Node_in/3;        % ==25
    
    column_count=0;
    
%% Using Adaptive Mean, make input Weight(Win)
    for rgb = 0:2
        
        column_count = column_count + 1;
        RGB = patch_pixels * rgb;  % red->RGB==0, green->RGB==25, blue->RGB==50
        num = 0;
        
        for i=1:patch_pixels  %i==1:25
            if input(RGB + i) > 0 && input(RGB + i) < 1 % find pixels: not salt or pepper
                num = num+1;
                Win(RGB + i, column_count) = 1; % not salt or pepper -> the value of Win -> 1
            end
        end
        
        if num > 0 % not salt or pepper
            Win(:,column_count) = Win(:,column_count) / num; % divide by the number of pixels
        else % all noise 
            if sum(input(RGB + 1 : RGB + patch_pixels) == 0) > sum(input(RGB + 1 : RGB + patch_pixels) == 1)
                % sum(input(RGB + 1 : RGB + patch_pixels) == 0) : for one patch, the number of pepper pixels
                % if pepper pixels more than salt pixels, the value of pixel of Win is 1
                for i = 1:patch_pixels
                    if input(RGB + i) == 0
                        num = num + 1; 
                        Win(RGB + i,column_count) = 1; 
                    end    
                end
            else
                % if salt pixels more than pepper pixels, the value of salt of Win is 1 
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
    
%% Using Adaptive Gaussian, make input Weight(Win)
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
        Win(RGB + 1:RGB + patch_pixels, column_count)=gauss_mat.*Win(RGB + 1:RGB + patch_pixels, column_count);
        
        total=0; 
        
        for i=1:patch_pixels
            if input(patch_pixels*rgb+i)>0 && input(patch_pixels*rgb+i)<1
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

%% Using Unsharp masking, make input Weight(Win)
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
    
    

    
