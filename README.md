# WaveletSEG 
A novel and concise algorithm for MS data peak detection and especially peak quantification by utilize 2-D Continuous Wavelet Transform (CWT) coefficients matrix information, which derived from applying CWT over MS raw data. No further baseline removal or peak smoothing preprocessing steps are required before peak detection.


 ![image](https://github.com/George-wu509/Wavelet-MS-quantificatio-method/blob/master/readme_figures/cover1.jpeg)
 
 ![image](https://github.com/George-wu509/Wavelet-MS-quantificatio-method/blob/master/readme_figures/cover2.jpeg)
 
 Introduction
-------------------------
Peak detection and quantification of mass spectrometry (MS) data are essential and indispensable steps for MS based proteomic data analysis. In general, peak detection procedure can decompose into three consequent steps: smoothing, baseline correction and peak finding. Nevertheless, difficulties arise to detect true peaks for low Signal to Noise Ratio (SNR) and complexity of MS signals. Baseline removal and smoothing steps are unrecoverable after applied on MS data inadequately and results are inconsistent among common peak detection algorithms. 

Most of the current methods for quantitative proteomics were based on isotope labeling combined with mass spectrometry or label-free quantification, such as peak quantification methods which applied directly curve fitting of MS raw data peaks by several different model functions. Due to increasing practicability in the proteomics field though high computational challenges label-free quantification techniques are, we present a novel and concise algorithm for MS data peak detection and especially peak quantification by utilize 2-D Continuous Wavelet Transform (CWT) coefficients matrix information, which derived from applying CWT over MS raw data. No further baseline removal or peak smoothing preprocessing steps are required before peak detection. 

This algorithm improves the accuracy to detect true peaks in a robust manner by investigate the ridge lines on the CWT coefficients matrix respect to peak positions. Furthermore, peak quantification and resolution of overlapping peaks, which are crucial process when neighboring peaks overlap strongly enough, are presented in this approach by utilize specific scales CWT coefficients information. Our approach has been validated by using both simulated Gaussian overlapping MS data and physics-based computer model of mass spectrometry.
  
 ![image](https://github.com/George-wu509/Wavelet-MS-quantificatio-method/blob/master/readme_figures/result1.png)


Scientific justification
-------------------------
Quantitative proteomics is increasingly developing in Bioinformatics research and not only protein identification, but also protein quantification is essential and indispensable to understand protein expression level or biological function. Most of the current methods for quantitative proteomics were based on isotope labeling combined with mass spectrometry or label-free quantification, such as peak quantification methods which applied directly curve fitting of MS raw data peaks by several different model functions. 

Due to increasing practicability in the proteomics field though high computational challenges label-free quantification techniques are, we present a novel and concise algorithm for MS data peak detection and especially peak quantification by utilize 2-D Continuous Wavelet Transform (CWT) coefficients matrix information, which derived from applying CWT over MS raw data. This algorithm improves the accuracy to detect true peaks in a robust manner by investigate the ridge lines on the CWT coefficients matrix respect to peak positions. Furthermore, peak quantification and resolution of overlapping peaks, which are crucial process when neighboring peaks overlap strongly enough, are presented in this approach by utilize specific scales CWT coefficients information. 
