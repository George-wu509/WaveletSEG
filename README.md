# WaveletSEG 
We develop novel wavelet-based segmentation algorithm which can do robust nuclei segmentation or single-molecule RNA segmentation without any prepossessing or thresholding steps, and separate overlapping cells accurately. We incorporate wavelet based nuclei identification, image registration, 3D topology features, and shape classification in Zebrafish whole mount embryo in automatically analysis platform named WaveletSEG. Three sub GUI are also created for segmentation results validation and methods comparison.

 ![image](https://github.com/George-wu509/WaveletSEG/README_ref/software 0.jpg)
 
 
What is Wavelet Segmentation ?
-------------------------

Wavelet-based segmentation is a novel nuclei segmentation algorithm which can do robust nuclei segmentation or single-molecule RNA segmentation without any prepossessing or thresholding steps, and separate overlapping cells accurately.  A wavelet is a mathematical function used to separate a function or continuous-time signal into different frequency components and study each component with a resolution that matches its scale. We develop a five steps pipeline including 2D continuous wavelet transform, multi-scale object identification, 3D object alignment, and division steps in YZ,XZ and ZY planes.  

 ![image](https://github.com/George-wu509/WaveletSEG/README_ref/software 0.jpg)


USER MANUAL
-------------------------
You can either import image files or import existing result data file to check the result.

Import image files

1. Push Setting button and input channel and resolution information.
​2. Select single image file or folder using open file or open folder button
​3. Once loading process is finished, you can run nuclei wavelet segmentation by pushing Nuclei identification.
​4. Choice different segmentation methods or change parameters using parameter .
5. You can running step-by-step nuclei identification, embryo orientation and shape classification steps or push     
    RUN all to automatically run all processes.
6. Rotate the embryo by using Rotation button
7. Choice channel menu to visualize results such as pSmad distribution or nuclei density.
8. Click the Show whole embryo checkbox and select xyz ranges to visualize partial embryo nuclei.
9. Push Save figure button to store image visualization result as .fig file 
10. Push save Result button to save results as WaveletSEG_result.mat file.
11. All data, result and figures are stored in one folder. 

Import existing result file

​1. Push open file button and select sta.mat in specific folder.
​2. Once loading process is finished, you can check image visualization results or run analysis process.
​3. Choice different segmentation methods or change parameters using parameter .
4. Choice channel menu to visualize results such as pSmad distribution or nuclei density.
5. Click the Show whole embryo checkbox and select xyz ranges to visualize partial embryo nuclei.
6. Push Save figure button to store image visualization result as .fig file 
7. Push save Result button to save results as WaveletSEG_result.mat file.
8. All data, result and figures are stored in one folder. 

Using sub-GUI to validate results

​1. There are three sub-GUI for segmentation data validation.
​2. Push Raw images button to check the Z plane raw image with segmentation results.
​3. Push Raw3D images button to check the raw image with segmentation results in 3D
4. Push Compare SEG button to compare different segmentation results.

Synthesis images and add noise

​1. After pushing Generate image button, a pop-up menu will display. 
​2. You can input synthesis image 3D size, nuclei number, size and density. 
​3. Then apply different type of noise on synthesis images by pushing add noise button on pop-up menu.




