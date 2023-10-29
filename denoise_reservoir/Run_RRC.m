%
%       Pre-set parameters::
%
%       % Choose a test image number from 1 to 80
%       % A new clean image can be added to the folder 'rc_files/test_set/'
%       in which case one needs to set the image name as a specific number.
%
%       testImage = 53;
%
%
%       % This is the percentage of the salt-and-pepper noise: 
%       Choose from {0.6, 0.8}
%
%       intensity     = 0.6;    
%
%
%       % This is the number of training images to use. 
%       Choose from {50, 100, 200, 500, 1000}
%
%       window_num    = 500;    
%
%
%       % The number of reservoirs uses for the recursive reservoir
%       computing <= 20
%
%       reservoir_num = 10;  
%


function Run_RRC(testImage,intensity,window_num,Reservoir_num)
    if nargin == 0
        testImage = 53; 
        intensity     = 0.6;    
        window_num    = 500;    
        Reservoir_num = 10; 
        disp('Preset parameters are used.')
    else
        if nargin == 1
            intensity     = 0.6;    
            window_num    = 500;    
            Reservoir_num = 10;     
        else
            if nargin == 2
                if min(abs([0.6, 0.8] - intensity*[1,1]))~= 0
                    intensity = 0.6;
                    disp(['The selected Intensity is invalid. We select Intensity=' num2str(intensity)])
                end
                window_num   = 500;
                Reservoir_num = 10;
            else
                if nargin == 3
                    if min(abs([0.6, 0.8] - intensity*[1,1]))~= 0
                        intensity = 0.6;
                        disp(['The selected Intensity is invalid. We select Intensity=' num2str(intensity)])
                    end
                    if min(abs([50 100 200 500 1000] - window_num*[1,1,1,1,1]))~= 0
                        window_num   = 500;
                        disp(['The chosen number of training images is invalid. We select NumOfTrainingImages=' num2str(window_num)])
                    end
                    Reservoir_num = 10;
                else
                    if nargin == 4
                        if min(abs([0.6, 0.8] - intensity*[1,1]))~= 0
                            intensity = 0.6;
                            disp(['The selected Intensity is invalid. We select Intensity=' num2str(intensity)])
                        end
                        if min(abs([50 100 200 500 1000] - window_num*[1,1,1,1,1]))~= 0
                            window_num   = 500;
                            disp(['The chosen number of training images is invalid. We select NumOfTrainingImages=' num2str(window_num)])
                        end
                        if floor(Reservoir_num)<1 || floor(Reservoir_num)>20
                            Reservoir_num = 10;
                            disp(['The chosen number of reservoirs is invalid. We select NumOfReservoirs=' num2str(window_num)])
                        end
                    end
                end
            end
        end
    end
    
    cd rc_files/
    tic
    main_module(testImage,intensity,window_num,Reservoir_num);
    toc
    cd ../
end