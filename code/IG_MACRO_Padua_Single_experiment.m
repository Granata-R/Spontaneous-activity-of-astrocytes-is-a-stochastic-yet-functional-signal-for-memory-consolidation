%% Macro script for automatically launching ImageGateway and processing the example time lapse.
% This script runs Image Gateway to process the data in the "Example data"
% folder. It presses the handles in the correct order, assuming that the handle values
% are the default ones already set in AppDesigner.
% Please do not make any changes in the GUI if
% you intend to run this macro for reproducibility!
% The astrocyte used is the one shown in Extended Data Figure 1.
%
% By running this script, the user is prompted to perform three actions:
% 1) Select the time-lapse file (in "/data");
% 2) Select the astrocyte ROI (in "/code/AstroBoundaries");
% 3) Define the astrocyte ID and um/px ratio (simply click OK; it's not critical for the example).
%
% After the macro has finished (taking around 1 minute), three GUIs remain open.
% These are:
% a) ImageGateway (main), used for primary preprocessing and calcium imaging binarization;
% b) applicationBinaryMap_App, which extracts the microdomain territories (defined here as "clusters"); and
% c) BinMapCCMatrix, which permits exploration of the cross-correlation matrices between microdomains.
%
% These apps were designed for data exploration and visualization.
% The purpose of this macro is to guide you through the pipeline that we used.
%
%% **** Important: required MATLAB toolboxes ****
% To effectively use Image Gateway and run this script, ensure that you have installed:
% - Image Processing Toolbox (always required)
% - Signal Processing Toolbox (might be required for certain actions)
% - Statistics and Machine Learning Toolbox (might be required for certain actions)
%
% This code has been tested on Windows only and with different versions of MATLAB
% (from 2017 onwards).
% Note: If you are using a MATLAB version different from R2023a, ensure to
% manually open these apps in AppDesigner: ImageGateway3.mlapp,
% applicationBinaryMap_app.mlapp, BinMapCCMatrix.mlapp, and save them.
% This allows MATLAB to update the GUI handles according to
% your version, enabling you to run this script.
%
% Rocco Granata, M.Sc.
% March 17 2024

clear; close all; clc;

%% Image Gateway preprocessing
app=ImageGateway3;
drawnow;

H = app.openBTN; %% Action
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.clearEdgesBt;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.computeBinning;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.ImportBoundariesBT; %% Action
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.computeDf;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.thresholdFck;
set(H, 'Value', 0);
feval(get(H, 'ValueChangedFcn'),H,[]);
set(H, 'Value', 1);
feval(get(H, 'ValueChangedFcn'),H,[]);

H = app.computeFstats;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.computeDFstats;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H=app.uibuttongroupDistribution;
app.maskedDFck.Value=1; drawnow;
feval(get(H, 'SelectionChangedFcn'),H,[]);

%% Image Gateway binarization
H = app.computeBinaryStack;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app.BMapp_pb;
feval(get(H, 'ButtonPushedFcn'),H,[]);

%% Cluster (microdomain) extraction
app2=app.BinaryApp;
drawnow;

H = app2.applyclust;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app2.extractFeatures;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app2.SpCorrelationBt;
feval(get(H, 'ButtonPushedFcn'),H,[]);

% Action: um/px ratio and cell filename
prompt = {'Enter um/pixel ratio:','Enter cell name:'}; %% Action
dlgtitle = 'Input';
dims = [1 35];
definput = {'0.24','Astro_Example'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
set(app2.umpxEF,'Value',str2double(answer(1)));
set(app2.FilenameEF,'Value',string(answer(2)));

H = app2.AVRatiosBT; %% Save
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app2.CCmatrixBt;
feval(get(H, 'ButtonPushedFcn'),H,[]);


%% Cross-correlation
app3 = app2.BinMapCCMatrix;
drawnow;

H = app2.extractFeatures;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app3.ComputeCCMatrix1BT;
feval(get(H, 'ButtonPushedFcn'),H,[]);

H = app3.ExportHistogramsBT; %% Save
feval(get(H, 'ButtonPushedFcn'),H,[]);

% app3.delete
% app2.delete
% app.delete
% clear("app")

disp('Macro completed. Result tables are saved in EventsAndClusters and Cross-Correlation subfolders.')
drawnow
msgbox('The macro has successfully ended. Please check the results folder.', 'Macro Finished');
