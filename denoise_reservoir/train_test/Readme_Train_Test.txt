Execute the file 'main_preprcs_trn_test_all.m'


Notes) 
1. This is the train code used for our proposed method, R-RC (Recursive Reservoir Concatenation).
   We trained the network with 50, 100, 200, 500, 1000 training color images of size 24x24x3 so that one can check our claim with these trained networks. 

2. This code opens a parpool session. In the recursive reservoir concatenation, the reconstruction at each reservoir is fully parallel in the sense that every noisy pixel does not communicate with any other noisy pixels.

3. The user need to select ".mat" file to get parameters.

4. Results are saved in the folder 'rc_files/500/0.6/53/' for NumTrainingImages = 500, Intensity = 0.6.
   
   Run_RRC_Train(set_windows_num, set_intensity) to use user's choice of parameters.