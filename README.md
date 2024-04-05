# Guide for the reproducible run
**Manuscript: _Spontaneous activity of astrocytes is a stochastic yet functional signal for memory consolidation_**. 

## 1 Introduction
This repository contains the MATLAB code used for microdomain extraction and cross-correlation analysis used for the manuscript _Spontaneous activity of astrocytes is a stochastic yet functional signal for memory consolidation_ by Losi G. et al. As representative example, it reproduces the pipeline used to extract the microdomains of the astrocyte depicted in **Extended Data Figure 1**, outlining the computational methodology.

The code operates through AppDesigner applications, which were designed for broad data exploration and visualization. To streamline reproducibility, we have created a macro script (**IG_MACRO_Padua_Single_experiment.m**) that automatically launches these applications with the parameters we have ultimately chosen for analysis.
The sections below detail the system requirements, how to execute the macro, and some aspects of exploring loaded data.

## 2 Requirements

**A local MATLAB installation is required.**

**This code has been tested on Windows only**.

### Required MATLAB Version
The code should run fine on any version of MATLAB **equal to or above R2019**.

If you are using a MATLAB version different from R2023a, ensure to manually open these apps in AppDesigner: ImageGateway3.mlapp, applicationBinaryMap_app.mlapp, BinMapCCMatrix.mlapp, and save them. This allows MATLAB to update the GUI handles according to your version. Otherwise, depending on your version, some handle information might be missing and the macro will not run.

### Required MATLAB toolboxes
Ensure that you have installed these add-ons:

1) **Image Processing Toolbox** (always required);

2) **Signal Processing Toolbox** (might be required for certain actions);

3) **Statistics and Machine Learning Toolbox** (might be required for certain actions).

If not, you can do this by following the official [Mathworks guide for installing Add-Ons](https://it.mathworks.com/help/matlab/matlab_env/get-add-ons.html).

## 3 How to run the macro script

### 3.1 Download this repository
To do the reproducible run download this repository, unzip it, and open MATLAB. Make sure to set as current directory the **/code** folder, where the **IG_MACRO_Padua_Single_experiment.m** file is placed. 

**Note: while unzipping, make sure to choose a short name for the folder. Folder names that are too long might block the unzipping.**

### 3.2 Download data
Data are available on [this public G-Node repository](https://gin.g-node.org/RattoLab/Spontaneous-activity-of-astrocytes-is-a-stochastic-yet-functional-signal-for-memory-consolidation). Dowload the repository, unzip the file named **"2 Jul B 1409 - 3DMean3x3x2.tif"** and move it into the subfolder **"/data"**.

### 3.3 Run the script and give input data
Once you are in the **/code** folder in MATLAB, you can run the script **IG_MACRO_Padua_Single_experiment.m** to launch the analysis.

This script runs the applications and presses the handles in the correct order. It assumes that the handle values are the default ones already set in AppDesigner; thus, please do not make any changes in the GUI if you intend to run this macro for reproducibility!

By running this script, the user is prompted to perform three actions:

1) Select the time-lapse file (<ins>select **"2 Jul B 1409 - 3DMean3x3x2.tif"** in the **"/data"** folder</ins>); 

2) Select the astrocyte ROI (<ins>select **"2 Jul B 1409 - 3DMean3x3x2Astro_Example.mat"** in the **"/code/AstroBoundaries"** subfolder</ins>); 

3) Define the astrocyte ID and µm/px ratio (simply click **OK**; it's not critical for the example).

The elapsing time is around 1 minute. At the end of the macro computation, you should encounter a window similar to the one in Fig. 3.3.a and a dialog "Macro Finished" should appear.  

[![Fig. 3.3.a](https://i.imgur.com/LXwnvDb.png)](https://i.imgur.com/LXwnvDb.png)
_Fig. 3.3.a_

The **"/results"** folder should also appear, containing two subfolders named **"results/EventsAndClusters"** and **"results/Cross-correlation"**. In these two subfolders, the raw output data is stored as .mat files, which you can browse through the GUIs.

Three GUIs remain open. These are:

1) **ImageGateway3** (main), used for primary preprocessing and calcium imaging binarization;

2) **applicationBinaryMap_App**, which extracts the microdomains;

3) **BinMapCCMatrix**, which permits exploration of the cross-correlation matrices between microdomains.

## 4 General use of the program
After you have run the macro script, you can browse the application and the output.

**Important:** These tools were created for detailed exploration of imaging data. While many parameters are available in the GUIs, some have not been used. Interacting with these unused parameters might cause errors, but it won't disrupt interaction with other features.

In the sections below, I describe the functionalities a reviewer might be interested in. These involve the exploration of the binarized DF/F data, microdomains, and cross-correlation matrices.

### 4.1 ImageGateway3
It is the main module of the pipeline. Its function is to bin the imaging data and compute the DF/F of the imaging stack. Preprocessing parameters, such as minimal size and minimal duration, are applied.

You can browse the raw frames, the DF/F frames, and the binary frames through the _Display_ tab (Fig. 4.1.a).

[![Fig. 4.1.a](https://i.imgur.com/lYh2JwB.png)](https://i.imgur.com/lYh2JwB.png)
_Fig. 4.1.a_

### 4.2 applicationBinaryMap_App
It is the second step of the pipeline. It uses the binary stack obtained from ImageGateway to extract the footprints of single calcium events (referred to as _Footprints_ in the GUI) and microdomains (referred to as _Clusters_ in the GUI). In this application, the default view shows the totality of event footprints in the field. By selecting the radio button _Clusters_, as shown in Fig. 4.2.a, you can switch to microdomains.

[![Fig. 4.2.a](https://i.imgur.com/pusTvLs.png)](https://i.imgur.com/pusTvLs.png)
_Fig. 4.2.a_

Thereupon, it is possible to browse each single microdomain using the arrow handles on the right (Fig. 4.2.b). The panel below shows the DF/F trace of that microdomain.

[![Fig. 4.2.b](https://i.imgur.com/GtiMmWa.png)](https://i.imgur.com/GtiMmWa.png)
_Fig. 4.2.b_

It is possible to visualize the _nearest neighbor_ of that microdomain by checking the _NN_ button (Fig. 4.2.c). The nearest neighbour is the microdomain with the highest cross-correlation. The selected microdomain is in red, while the nearest neighbor is in green. In the plot dedicated to the DF/F traces, you can see in the same colors the corresponding traces (Fig. 4.2.d). The green one is flipped on the y-axis.

[![Fig. 4.2.c](https://i.imgur.com/OqdgihJ.png)](https://i.imgur.com/OqdgihJ.png)
_Fig. 4.2.c_
[![Fig. 4.2.d](https://i.imgur.com/HK9x1oT.png)](https://i.imgur.com/HK9x1oT.png)
_Fig. 4.2.d_

In this module, you can also investigate the connection between calcium event metrics (in the _Features extraction_ panel) and their distributions for the experiment (in the _Features Distribution_ panel).

### 4.3 BinMapCCMatrix
It shows the cross-correlation matrix. By default, it shows the distribution of the cross-correlation matrix values. To show the matrix, uncheck the button "Display CC distributions" in the bottom-left panel, as in Fig. 4.3.a.

[![Fig. 4.3.a](https://i.imgur.com/Q9CmxnK.png)](https://i.imgur.com/Q9CmxnK.png)
_Fig. 4.3.a_

This GUI allows computing the shuffling control through the bottom center panel as in Fig. 4.3.b.

[![Fig. 4.3.b](https://i.imgur.com/Y4UGLrm.png)](https://i.imgur.com/Y4UGLrm.png)
_Fig. 4.3.b_

Finally, the bottom-right panel allows to compute the scatter plot showing the relationship between distance and correlation (Fig. 4.2.c).

[![Fig. 4.3.c](https://i.imgur.com/NPpHbTX.png)](https://i.imgur.com/NPpHbTX.png)
_Fig. 4.3.c_

### 4.4 Final remarks
If the run doesn't work, make sure that you are in the correct MATLAB directory and that your MATLAB local installation meets the requirements (see **Requirements** section above).

## Credits 
The analysis pipeline was conceived by Gian Michele Ratto and implemented by Rocco Granata. The macro and this guide were written by Rocco Granata.

March 18th, 2024
