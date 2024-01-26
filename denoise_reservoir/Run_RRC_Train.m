%
%       Pre-set parameters::
%
%       % windows_num: the number of images to train
%       Choose from {50, 100, 200, 500, 1000}
%       default = 200
%       ex) windows_num = 500; windows_num = [50, 100]; 
%       
%       % intensity: the ratio of the noise in the image
%       Choose from {0.6, 0.8}
%       default = 0.8
%       ex) intensity = 0.6; intensity = [0.6, 0.8] 
%       
%       With wrong inputs, it runs with default arguments
%
%


function Run_RRC_Train(set_window_num, set_intensity)

    if nargin == 0
        set_window_num = 200;
        set_intensity = 0.8;
    elseif nargin == 1
        if ~prod( ismember(set_window_num, [50, 100, 200, 500, 1000]) )
            set_window_num = 200;
            disp(['The selected windows_num is invalid. We select Intensity=' num2str(set_window_num)])
        end

        if ~prod( ismember(set_intensity, [0.6, 0.8]) )
            set_intensity = 0.8;
            disp(['The selected Intensity is invalid. We select Intensity=' num2str(set_intensity)])
        end

    else
        if prod(ismember(set_window_num, [50, 100, 200, 500, 1000])) || prod(ismember(set_intensity, [0.6, 0.8]))
            set_window_num = 200;
            set_intensity = 0.8;
            disp(['The selected windows_num and Intensity are invalid. We select windows_num=' num2str(set_window_num) ' and Intensity=' num2str(set_intensity)])
        end
    end
    
    cd rc_train_files/
    tic
    training_module(set_window_num, set_intensity);
    toc
    cd ../
end