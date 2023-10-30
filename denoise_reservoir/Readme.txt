Execute the file 'Run_RRC.m'


Notes) 
1. This is the test code used for our proposed method, R-RC (Recursive Reservoir Concatenation).
   We trained the network with 50, 100, 200, 500, 1000 training color images of size 24x24x3 so that one can check our claim with these trained networks. 

2. This code opens a parpool session. In the recursive reservoir concatenation, the reconstruction at each reservoir is fully parallel in the sense that every noisy pixel does not communicate with any other noisy pixels.

3. There are 4 parameters to select: testImage, Intensity,NumTrainingImages,NumReservoirs.
   a) testImage is an integer between 1 and 80.
   b) Intensity is a value in {0.6, 0.8}.
   c) NumTrainingImages is a value in {50, 100, 200, 500, 1000},
   d) NumReservoirs is an integer between 3 and 20.

4. Results are saved in the folder 'rc_files/500/0.6/53/' for NumTrainingImages = 500, Intensity = 0.6, testImage = 53.

5. filename extension for test images : .png, .jpg, .jpeg

6. Run_RRC with No arguments                      =>   The pre-set parameters will be used:
                                                       testImage         = 53,  
                                                       Intensity         = 0.6,
                                                       NumTrainingImages = 500,
                                                       NumReservoirs     = 15.

   Run_RRC(testImage)                             =>   Intensity = 0.6, NumTrainingImages = 500, NumReservoirs = 15 are used.

   Run_RRC(testImage,Intensity)                   =>   NumTrainingImages = 500, NumReservoirs = 15 are used.

   Run_RRC(testImage,Intensity,NumTrainingImages) =>   NumReservoirs = 15 are used.

   Run_RRC(testImage,Intensity,NumTrainingImages,NumReservoirs) to use user's choice of parameters.