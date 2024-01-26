Execute the file 'Run_RRC_Train.m'


Notes) 
1. This is the train code used for our proposed method, R-RC (Recursive Reservoir Concatenation).
   We trained the network with 50, 100, 200, 500, 1000 training color images of size 24x24x3 so that one can check our claim with these trained networks. 

2. This code opens a parpool session. In the recursive reservoir concatenation, the reconstruction at each reservoir is fully parallel in the sense that every noisy pixel does not communicate with any other noisy pixels.

3. There are 2 parameters to select: set_windows_num, set_intensity.
   a) the number of testImage is a value in {50, 100, 200, 500, 1000}.
   b) Intensity is a value in {0.6, 0.8}.
   
4. Results are saved in the folder 'rc_files/500/0.6/53/' for NumTrainingImages = 500, Intensity = 0.6.

5. Run_RRC with No arguments                      		=>   The pre-set parameters will be used:
															 set_windows_num       = 200,  
															 set_intensity         = 0.8.
   
   Run_RRC_Train(set_windows_num, set_intensity) to use user's choice of parameters.