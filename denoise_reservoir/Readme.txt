Execute the file 'Run_RRC.m'

Notes) 
1. This is the test code for the proposed method, R-RC (Recursive Reservoir Computing).
   We trained the network with 50, 100, 200, 500, 1000 training color images of size 24x24x3.

2. There are 4 parameters to select: testImage, Intensity,NumTrainingImages,NumReservoirs.
   testImage = an integer from 1 to 80,
   Intensity         from {0.6, 0.8},
   NumTrainingImages from {50, 100, 200, 500, 1000},
   NumReservoirs     between 3 and 20.

3. Results are saved in the folder 'rc_files/500/0.6/53/' for NumTrainingImages = 500, Intensity = 0.6, testImage = 53.
4. filename extension for images : .png, .jpg, .jpeg

5. Run_RRC with No arguments                      =>   The pre-set parameters will be used:
                                                       testImage         = 53,  
                                                       Intensity         = 0.6,
                                                       NumTrainingImages = 500,
                                                       NumReservoirs     = 15.

   Run_RRC(testImage)                             =>   Intensity = 0.6, NumTrainingImages = 500, NumReservoirs = 15 are used.

   Run_RRC(testImage,Intensity)                   =>   NumTrainingImages = 500, NumReservoirs = 15 are used.

   Run_RRC(testImage,Intensity,NumTrainingImages) =>   NumReservoirs = 15 are used.

   Run_RRC(testImage,Intensity,NumTrainingImages,NumReservoirs) to use user's choice of parameters.