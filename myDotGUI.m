%% myDOTGUI: a GUI that helps analyzing quantum dot blinking intensityTraces
%
% Copyright (C) 2018 Federico Pevere. All rights reserved.
%
% Permission to use, copy, modify, and distribute this software for any purpose without fee is hereby granted, provided that this entire notice is included in all copies of any software which is or includes a copy or modification of this software and in all copies of the supporting documentation for such software. Any for profit use of this software is expressly forbidden without first obtaining the explicit consent of the author.
%
% THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED WARRANTY. IN PARTICULAR, THE AUTHOR DOES NOT MAKE ANY REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
%
% Please put the following references in your publication if you use this plugin for your work:
%
% Text References:
%
% Pevere, F. , Bruhn, B. , Sangghaleh, F. , Hormozan, Y. , Sychugov, I. and Linnros, J. (2015), Effect of X‐ray irradiation on the blinking of single silicon nanocrystals. Phys. Status Solidi A, 212: 2692-2695.
%
% Bibtex:
%
% @article{blinkingSiQDs,
% author = {Pevere Federico and Bruhn Benjamin and Sangghaleh Fatemeh and Hormozan Yashar and Sychugov Ilya and Linnros Jan},
% title = {Effect of X‐ray irradiation on the blinking of single silicon nanocrystals},
% journal = {physica status solidi (a)},
% volume = {212},
% number = {12},
% pages = {2692-2695},
% doi = {10.1002/pssa.201532652}
% }
%
%

function varargout = myDotGUI(varargin)
% MYDOTGUI MATLAB code for myDotGUI.fig
%      MYDOTGUI, by itself, creates a new MYDOTGUI or raises the existing
%      singleton*.
%
%      H = MYDOTGUI returns the handle to a new MYDOTGUI or the handle to
%      the existing singleton*.
%
%      MYDOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYDOTGUI.M with the given input arguments.
%
%      MYDOTGUI('Property','Value',...) creates a new MYDOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myDotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myDotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myDotGUI

% Last Modified by GUIDE v2.5 05-Jun-2016 17:30:57

% Begin initialization code - DO NOT EDIT
datetime.timezone = 'Europe/Zurich';
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myDotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @myDotGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before myDotGUI is made visible.
function myDotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myDotGUI (see VARARGIN)

clc;

disp('myDotGUI.m written by Federico Pevere (2016)...');
disp('Program start...');

%set(handles.figure1,'visible','off');

% disable all the buttons, text inputs and slider

set(handles.dotNumberSlider,'enable','off');
set(handles.minValueText,'enable','off');
set(handles.maxValueText,'enable','off');
set(handles.updateIntensityTraceButton,'enable','off');
set(handles.maxValueText,'enable','off');
set(handles.resetMinMaxButton,'enable','off');
set(handles.resetAllMinMaxButton,'enable','off');
set(handles.numberOfBinsText,'enable','off');
set(handles.updateHistogramButton,'enable','off');
set(handles.muOnText,'enable','off');
set(handles.areaOnText,'enable','off');
set(handles.muOffText,'enable','off');
set(handles.areaOffText,'enable','off');
set(handles.fittingSuccessfulText,'enable','off');
set(handles.isBlinkingText,'enable','off');
set(handles.maxOffThresholdText,'enable','off');
set(handles.minOnThresholdText,'enable','off');
set(handles.nBlinkingEventsText,'enable','off');
set(handles.meanOnTimeText,'enable','off');
set(handles.meanOffTimeText,'enable','off');
set(handles.onPercentageText,'enable','off');
set(handles.offPercentageText,'enable','off');
set(handles.recalculateOnOffTimesButton,'enable','off');
set(handles.saveBlinkingDotsDataButton,'enable','off');
set(handles.onLifetimeText,'enable','off');
set(handles.offLifetimeText,'enable','off');
set(handles.onDutyCycleText,'enable','off');
set(handles.offDutyCycleText,'enable','off');
set(handles.minOnTimeHistText,'enable','off');
set(handles.maxOnTimeHistText,'enable','off');
set(handles.minOffTimeHistText,'enable','off');
set(handles.maxOffTimeHistText,'enable','off');
set(handles.binWidthOnTimeHistText,'enable','off');
set(handles.binWidthOffTimeHistText,'enable','off');
set(handles.minOnTimeHistFitText,'enable','off');
set(handles.maxOnTimeHistFitText,'enable','off');
set(handles.minOffTimeHistFitText,'enable','off');
set(handles.maxOffTimeHistFitText,'enable','off');
set(handles.updateOnTimeHistogramButton,'enable','off');
set(handles.fitOnTimeHistogramButton,'enable','off');
set(handles.updateOffTimeHistogramButton,'enable','off');
set(handles.fitOffTimeHistogramButton,'enable','off');


% Opens the blinking trace file
disp('Opening blinking trace file...')

[traceFileName,tracePathName] = uigetfile('.dat','Open the blinking trace file:');
if isequal(traceFileName,0)
    error('User Canceled Plugin');
else
    disp(['Blinking trace file opened: ', fullfile(tracePathName, traceFileName)]);
end

% Extracts the data from the blinking trace file selected
disp('Importing blinking traces...')
delimiterIn='\t'; %column delimiter
headerLinesIn=3; %number of header lines
temp = importdata(fullfile(tracePathName, traceFileName),delimiterIn, headerLinesIn);
if isa(temp,'struct')
    data = temp.data;
else
    data = temp;
end

% Initializes intensity traces handles
frame=data(:,1); %frames
time=data(:,2);
frameTime=time(1,1)/frame(1,1); %frame time in [s]
intensityTraces=data(:,3:size(data,2)); %intensity traces of the dots in [arb. u.]
nDots=size(intensityTraces,2); %number of dots
nFrames=size(intensityTraces,1); %number of frames

precision=2;
disp(['Number of dots: ' num2str(nDots,'%d')]);
disp(['Number of frames: ' num2str(nFrames,'%d')]);
disp(['Frame time: ' num2str(frameTime,precision) ' s']);


handles.tracePathName=tracePathName;
handles.traceFileName=traceFileName;
handles.time=time; %times in [s]
handles.frameTime=frameTime; %frame time in [s]
handles.intensityTraces=intensityTraces; %intensity traces of the dots in [arb. u.]
handles.nDots=nDots; %number of dots
handles.nFrames=nFrames; %number of frames
handles.currentDotNumber=1; %current dot displayed

% disp(strcat('Current dot: ',num2str(handles.currentDotNumber))); %debug

% Shows a dialog to input initial min and max intensity, number of bins
disp('Selecting initial displayed intensities settings...')
prompt = {'Min intens. (arb. u.)','Max intens. (arb. u.)','Number of histogram bins'};
dlg_title = 'Input Settings';
num_lines = 1;
defaultans = {'-500','1100','50'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

% Extracts data from dialog box
[minValue, status] = str2num(answer{1});
if ~status
    % Handle empty value returned
    % for unsuccessful conversion
    msg = 'Invalid min intensity.';
    error(msg);
end

[maxValue, status] = str2num(answer{2});
if ~status
    % Handle empty value returned
    % for unsuccessful conversion
    msg = 'Invalid max intensity.';
    error(msg);
end

[nBins, status] = str2num(answer{3});
if ~status
    % Handle empty value returned
    % for unsuccessful conversion
    msg = 'Invalid number of histogram bins.';
    error(msg);
end

% --- Initialization of handles structure

% Time for saving purposes

handles.t=datetime('now','TimeZone','local','Format','y-MM-dd-HH:mm');

% Intensity
handles.minIntensityTraceAxes=minValue*ones(1,nDots);
handles.maxIntensityTraceAxes=maxValue*ones(1,nDots);
handles.currentMinIntensity=handles.minIntensityTraceAxes(handles.currentDotNumber); %user-input min intensity
handles.currentMaxIntensity=handles.maxIntensityTraceAxes(handles.currentDotNumber); %user-input max intensity

% Intensity histogram
nBins=nBins*ones(1,nDots); %we start from 100 bins (reasonable value)
handles.nBins=nBins;
handles.currentNbins=handles.nBins(handles.currentDotNumber);

% Intensity histogram fitting
handles.onMeanIntensities=NaN(1,nDots);
handles.onStddevIntensities=NaN(1,nDots);
handles.onAreas=NaN(1,nDots);
handles.offMeanIntensities=NaN(1,nDots);
handles.offStddevIntensities=NaN(1,nDots);
handles.offAreas=NaN(1,nDots);
handles.onToOffMeanIntensities=NaN(1,nDots);
handles.onToOffStddevIntensities=NaN(1,nDots);
handles.curvesFitted=false(1,nDots);

% Blinking parameters
handles.isBlinking=false(1,nDots);
handles.nBlinkingDots=0;
handles.blinkingDots=NaN(1,nDots);
handles.wellSeparatedOnOffLevels=false(1,nDots);
handles.lowerOnThreshold=NaN(1,nDots);
handles.centerThreshold=NaN(1,nDots);
handles.upperOffThreshold=NaN(1,nDots);

% ON/OFF times
handles.onTimes=NaN(round(nFrames/2),nDots);
handles.offTimes=NaN(round(nFrames/2),nDots);
handles.onPercentage=NaN(nFrames,nDots);
handles.offPercentage=NaN(nFrames,nDots);
handles.nBlinkingEvents=zeros(1,nDots);
handles.nOnOffBlinkingEvents=zeros(1,nDots);
handles.nOffOnBlinkingEvents=zeros(1,nDots);
handles.onDutyCycle=NaN(1,nDots);
handles.meanOnTime=NaN(round(nFrames/2),nDots);
handles.meanOffTime=NaN(round(nFrames/2),nDots);

% ON/OFF statistics

% ON/OFF time histograms
handles.maxNpointsTimeHist=1000/handles.frameTime;
handles.onTimeHistBinCenters=NaN*ones(handles.maxNpointsTimeHist,nDots);
handles.onTimeHistOccurence=NaN*ones(handles.maxNpointsTimeHist,nDots);
handles.offTimeHistBinCenters=NaN*ones(handles.maxNpointsTimeHist,nDots);
handles.offTimeHistOccurence=NaN*ones(handles.maxNpointsTimeHist,nDots);
handles.minOnTimeHistogramAxes=(handles.frameTime/2)*ones(1,nDots);
handles.maxOnTimeHistogramAxes=NaN*ones(1,nDots);
handles.currentMinOnTimeHistogram=handles.minOnTimeHistogramAxes(handles.currentDotNumber); %user-input min On time histogram
handles.currentMaxOnTimeHistogram=handles.maxOnTimeHistogramAxes(handles.currentDotNumber); %user-input max On time histogram
handles.minOffTimeHistogramAxes=(handles.frameTime/2)*ones(1,nDots);
handles.maxOffTimeHistogramAxes=NaN*ones(1,nDots);
handles.currentMinOffTimeHistogram=handles.minOffTimeHistogramAxes(handles.currentDotNumber); %user-input min Off time histogram
handles.currentMaxOffTimeHistogram=handles.maxOffTimeHistogramAxes(handles.currentDotNumber); %user-input max Off time histogram
handles.binWidthOnTimeHist=handles.frameTime*ones(1,nDots);
handles.binWidthOffTimeHist=handles.frameTime*ones(1,nDots);
handles.currentBinWidthOnTimeHist=handles.binWidthOnTimeHist(handles.currentDotNumber);
handles.currentBinWidthOffTimeHist=handles.binWidthOffTimeHist(handles.currentDotNumber);

% ON/OFF time histograms fitting
handles.minOnTimeHistFit=handles.minOnTimeHistogramAxes;
handles.maxOnTimeHistFit=handles.maxOnTimeHistogramAxes;
handles.currentMinOnTimeHistFit=handles.minOnTimeHistFit(handles.currentDotNumber); %user-input min On time hist. linear fit
handles.currentMaxOnTimeHistFit=handles.maxOnTimeHistFit(handles.currentDotNumber); %user-input max On time hist. linear fit
handles.minOffTimeHistFit=handles.minOffTimeHistogramAxes;
handles.maxOffTimeHistFit=handles.maxOffTimeHistogramAxes;
handles.currentMinOffTimeHistFit=handles.minOffTimeHistFit(handles.currentDotNumber); %user-input min Off time hist. linear fit
handles.currentMaxOffTimeHistFit=handles.maxOffTimeHistFit(handles.currentDotNumber); %user-input max Off time hist. linear fit
handles.onLifetimeValue=NaN(1,nDots);
handles.onLifetimeStddev=NaN(1,nDots);
handles.onTimeHistFitP1=NaN(1,nDots);
handles.onTimeHistFitP2=NaN(1,nDots);
handles.onTimeHistFitAdjrsquare=zeros(1,nDots);
handles.offLifetimeValue=NaN(1,nDots);
handles.offLifetimeStddev=NaN(1,nDots);
handles.offTimeHistFitP1=NaN(1,nDots);
handles.offTimeHistFitP2=NaN(1,nDots);
handles.offTimeHistFitAdjrsquare=zeros(1,nDots);
handles.onDutyCycleStatsValue=NaN(1,nDots);
handles.offDutyCycleStatsValue=NaN(1,nDots);
handles.onDutyCycleStatsStddev=NaN(1,nDots);
handles.offDutyCycleStatsStddev=NaN(1,nDots);

% Updates handles structure
guidata(hObject, handles);

% --- Analysis of all the dots

disp('Analyzing all the dots to find blinking ones...');

for dotNumber=1:nDots
    % Fits the intensity trace with a double Gaussian
    fitIntensityTrace(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    % Finds the threshold to use for extracting ON/OFF times
    findThresholds(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    % Extracts ON/OFF times
    getOnOffTimes(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    % Calculates ON time histogram
    calculateOnTimeHistogram(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    % Calculates OFF time histogram
    calculateOffTimeHistogram(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    % Fits ON and OFF time histograms
    fitOnTimeHistogram(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    fitOffTimeHistogram(hObject, eventdata, handles, dotNumber)
    % Retrieves new handles
    handles = guidata(hObject);
    % Calculates ON/OFF duty cycle from time histograms fitting results
    calculateDutyCycleStats(hObject, eventdata, handles, dotNumber);
    % Retrieves new handles
    handles = guidata(hObject);
    % Updates handles structure
    guidata(hObject, handles);
end

% --- Displays current dot

disp('Displaying the results...');

% Plots the intensity trace of the current dot
plotIntensityTrace(hObject, eventdata, handles);

% Plots intensity histogram of the current dot
plotIntensityHistogram(hObject, eventdata, handles);

% Plots the double Gaussian fitting curve of the current dot
plotFittingCurves(hObject, eventdata, handles);

% Displays blinking thresholds of the current dot
displayThresholds(hObject, eventdata, handles);

% Displays On/Off times of the current dot
displayOnOffTimesResults(hObject, eventdata, handles);

% Plot On- and Off- percentages
plotOnPercentage(hObject, eventdata, handles);
plotMeanTimes(hObject, eventdata, handles);

% Plot On- and Off- time histograms
plotOnTimeHistogram(hObject, eventdata, handles);
plotOffTimeHistogram(hObject, eventdata, handles);

% Display On- and Off- time histogram fitting results
displayOnOffTimeHistFitResults(hObject, eventdata, handles);

% Plot On- and Off- time histogram fitting lines
plotOnTimeHistFitLine(hObject, eventdata, handles);
plotOffTimeHistFitLine(hObject, eventdata, handles);

% Set the sliders




% --- Enables all the buttons, text inputs and slider

set(handles.dotNumberSlider,'enable','on');
set(handles.minValueText,'enable','on');
set(handles.maxValueText,'enable','on');
set(handles.updateIntensityTraceButton,'enable','on');
set(handles.maxValueText,'enable','on');
set(handles.resetMinMaxButton,'enable','on');
set(handles.resetAllMinMaxButton,'enable','on');
set(handles.numberOfBinsText,'enable','on');
set(handles.updateHistogramButton,'enable','on');
set(handles.muOnText,'enable','on');
%set(handles.stddevOnText,'enable','on');
set(handles.areaOnText,'enable','on');
set(handles.muOffText,'enable','on');
%set(handles.stddevOffText,'enable','on');
set(handles.areaOffText,'enable','on');
set(handles.fittingSuccessfulText,'enable','on');
set(handles.isBlinkingText,'enable','on');
set(handles.maxOffThresholdText,'enable','on');
set(handles.minOnThresholdText,'enable','on');
set(handles.nBlinkingEventsText,'enable','on');
set(handles.meanOnTimeText,'enable','on');
set(handles.meanOffTimeText,'enable','on');
set(handles.onPercentageText,'enable','on');
set(handles.offPercentageText,'enable','on');
set(handles.recalculateOnOffTimesButton,'enable','on');
set(handles.saveBlinkingDotsDataButton,'enable','on');
%set(handles.figure1,'visible','on');
set(handles.onLifetimeText,'enable','on');
set(handles.offLifetimeText,'enable','on');
set(handles.onDutyCycleText,'enable','on');
set(handles.offDutyCycleText,'enable','on');
set(handles.minOnTimeHistText,'enable','on');
set(handles.maxOnTimeHistText,'enable','on');
set(handles.minOffTimeHistText,'enable','on');
set(handles.maxOffTimeHistText,'enable','on');
set(handles.binWidthOnTimeHistText,'enable','on');
set(handles.binWidthOffTimeHistText,'enable','on');
set(handles.minOnTimeHistFitText,'enable','on');
set(handles.maxOnTimeHistFitText,'enable','on');
set(handles.minOffTimeHistFitText,'enable','on');
set(handles.maxOffTimeHistFitText,'enable','on');
set(handles.updateOnTimeHistogramButton,'enable','on');
set(handles.fitOnTimeHistogramButton,'enable','on');
set(handles.updateOffTimeHistogramButton,'enable','on');
set(handles.fitOffTimeHistogramButton,'enable','on');

% Choose default command line output for myDotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

disp('...and now you can work with my GUI! :-) (Federico Pevere)')


% UIWAIT makes myDotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = myDotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function dotNumberSlider_Callback(hObject, eventdata, handles)
% hObject    handle to dotNumberSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% disp('Begin of slider callback...'); % debug
% disp('Setting slider properties...'); % debug
set(hObject,'Min',1);
set(hObject,'Max',handles.nDots);
step=1/(handles.nDots-1);
set(hObject,'SliderStep',[step step]);

% disp('Updating current dot number') % debug
handles.currentDotNumber = round(get(hObject,'Value'));
dotNumber=handles.currentDotNumber;
% display(strcat('Current dot: ',num2str(handles.currentDotNumber))); %debug

% Update handles structure
guidata(hObject, handles);

% --- Displays current dot
set(handles.minValueText,'String',num2str(handles.minIntensityTraceAxes(dotNumber)));
set(handles.maxValueText,'String',num2str(handles.maxIntensityTraceAxes(dotNumber)));
set(handles.numberOfBinsText,'String',num2str(handles.nBins(dotNumber)));
set(handles.minOnTimeHistText,'String',num2str(handles.minOnTimeHistogramAxes(dotNumber)));
set(handles.maxOnTimeHistText,'String',num2str(handles.maxOnTimeHistogramAxes(dotNumber)));
set(handles.minOffTimeHistText,'String',num2str(handles.minOffTimeHistogramAxes(dotNumber)));
set(handles.maxOffTimeHistText,'String',num2str(handles.maxOffTimeHistogramAxes(dotNumber)));
set(handles.binWidthOnTimeHistText,'String',num2str(handles.binWidthOnTimeHist(dotNumber)));
set(handles.binWidthOffTimeHistText,'String',num2str(handles.binWidthOffTimeHist(dotNumber)));
set(handles.minOnTimeHistFitText,'String',num2str(handles.minOnTimeHistFit(dotNumber)));
set(handles.maxOnTimeHistFitText,'String',num2str(handles.maxOnTimeHistFit(dotNumber)));
set(handles.minOffTimeHistFitText,'String',num2str(handles.minOffTimeHistFit(dotNumber)));
set(handles.maxOffTimeHistFitText,'String',num2str(handles.maxOffTimeHistFit(dotNumber)));
handles.currentMinIntensity=handles.minIntensityTraceAxes(dotNumber); %user-input min intensity
handles.currentMaxIntensity=handles.maxIntensityTraceAxes(dotNumber); %user-input max intensity
handles.currentNbins=handles.nBins(dotNumber);
handles.currentMinOnTimeHistogram=handles.minOnTimeHistogramAxes(dotNumber); %user-input min On time histogram
handles.currentMaxOnTimeHistogram=handles.maxOnTimeHistogramAxes(dotNumber); %user-input max On time histogram
handles.currentMinOffTimeHistogram=handles.minOffTimeHistogramAxes(dotNumber); %user-input min Off time histogram
handles.currentMaxOffTimeHistogram=handles.maxOffTimeHistogramAxes(dotNumber); %user-input max Off time histogram
handles.currentBinWidthOnTimeHist=handles.binWidthOnTimeHist(dotNumber);
handles.currentBinWidthOffTimeHist=handles.binWidthOffTimeHist(dotNumber);
handles.currentMinOnTimeHistFit=handles.minOnTimeHistFit(dotNumber); %user-input min On time hist. linear fit
handles.currentMaxOnTimeHistFit=handles.maxOnTimeHistFit(dotNumber); %user-input max On time hist. linear fit
handles.currentMinOffTimeHistFit=handles.minOffTimeHistFit(dotNumber); %user-input min Off time hist. linear fit
handles.currentMaxOffTimeHistFit=handles.maxOffTimeHistFit(dotNumber); %user-input max Off time hist. linear fit



plotIntensityTrace(hObject, eventdata, handles);

plotIntensityHistogram(hObject, eventdata, handles);

plotFittingCurves(hObject, eventdata, handles);

displayThresholds(hObject, eventdata, handles);

displayOnOffTimesResults(hObject, eventdata, handles);

plotOnPercentage(hObject, eventdata, handles);

plotMeanTimes(hObject, eventdata, handles);

plotOnTimeHistogram(hObject, eventdata, handles);

plotOffTimeHistogram(hObject, eventdata, handles);

displayOnOffTimeHistFitResults(hObject, eventdata, handles);

plotOnTimeHistFitLine(hObject, eventdata, handles);

plotOffTimeHistFitLine(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% disp('End of slider callback...') % debug


% --- Executes during object creation, after setting all properties.
function dotNumberSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dotNumberSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set object properties
set(hObject,'Value',1);
set(hObject,'Min',1);
set(hObject,'Max',handles.nDots);
step=1/(handles.nDots-1);
set(hObject,'SliderStep',[step step]);

% Update handles structure
guidata(hObject, handles);


function minValueText_Callback(hObject, eventdata, handles)
% hObject    handle to minValueText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minValueText as text
%        str2double(get(hObject,'String')) returns contents of minValueText as a double

% Updates the min intensity of the currentDot
% disp('Updating the minimum value...'); % debug
handles.currentMinIntensity=str2double(get(hObject,'String'));
% display(handles.currentMinIntensity); % debug

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minValueText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minValueText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxValueText_Callback(hObject, eventdata, handles)
% hObject    handle to maxValueText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxValueText as text
%        str2double(get(hObject,'String')) returns contents of maxValueText as a double

% Updates the max intensity of the currentDot
% disp('Updating the maximum value...'); % debug
handles.currentMaxIntensity=str2double(get(hObject,'String'));

%display(handles.currentMaxIntensity); %
%debug

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxValueText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxValueText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateIntensityTraceButton.
function updateIntensityTraceButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateIntensityTraceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp('Plot button pressed...'); %debug

% Updates intensity trace plot
handles.maxIntensityTraceAxes(handles.currentDotNumber)=handles.currentMaxIntensity;
handles.minIntensityTraceAxes(handles.currentDotNumber)=handles.currentMinIntensity;

% Update handles structure
guidata(hObject, handles);

fitIntensityTrace(hObject, eventdata,handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Find thresholds and determin if it is blinking or not
findThresholds(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

plotIntensityTrace(hObject, eventdata, handles);

plotIntensityHistogram(hObject, eventdata, handles);

plotFittingCurves(hObject, eventdata, handles);

displayThresholds(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function updateIntensityTraceButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to updateIntensityTraceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Updates the intenisty trace plot
function plotIntensityTrace(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp('Updating intensity trace plot...'); % debug
plot(handles.intensityTraceAxes,handles.time,handles.intensityTraces(:,handles.currentDotNumber));
ylim(handles.intensityTraceAxes,[handles.minIntensityTraceAxes(handles.currentDotNumber) handles.maxIntensityTraceAxes(handles.currentDotNumber)]);
xlabel(handles.intensityTraceAxes,'Time (s)','FontSize',12);
ylabel(handles.intensityTraceAxes,'Integr. intensity (arb. u.)','FontSize',12);

if handles.isBlinking(handles.currentDotNumber)
    lowerOnThr = handles.lowerOnThreshold(handles.currentDotNumber)*ones(size(handles.time));
    centerThr= handles.centerThreshold(handles.currentDotNumber)*ones(size(handles.time));
    upperOffThr = handles.upperOffThreshold(handles.currentDotNumber)*ones(size(handles.time));
    hold(handles.intensityTraceAxes,'on');
    plot(handles.intensityTraceAxes,handles.time,lowerOnThr,'LineWidth',1,'LineStyle','--','Color','g');
    plot(handles.intensityTraceAxes,handles.time,centerThr,'LineWidth',1,'LineStyle',':','Color','b');
    plot(handles.intensityTraceAxes,handles.time,upperOffThr,'LineWidth',1,'LineStyle','--','Color','r');
    hold(handles.intensityTraceAxes,'off');
    %l=legend(handles.intensityTraceAxes,strcat('dot ',num2str(handles.currentDotNumber)),'lowerOnThr','centerThr','upperOffThr','Location','best');
    l=legend(handles.intensityTraceAxes,strcat('dot ',num2str(handles.currentDotNumber)),'Location','north');
else
    l=legend(handles.intensityTraceAxes,strcat('dot ',num2str(handles.currentDotNumber)),'Location','north');
end

l.FontSize=12;
grid(handles.intensityTraceAxes,'on');


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in resetMinMaxButton.
function resetMinMaxButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetMinMaxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Resets min and max intensities of current dot
handles.maxIntensityTraceAxes(handles.currentDotNumber)=max(handles.intensityTraces(:,handles.currentDotNumber));
handles.minIntensityTraceAxes(handles.currentDotNumber)=min(handles.intensityTraces(:,handles.currentDotNumber));

% Update handles structure
guidata(hObject, handles);

% Fits the intensity trace
fitIntensityTrace(hObject, eventdata,handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Finds thresholds and determines if it is blinking or not
findThresholds(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Plots and display
plotIntensityTrace(hObject, eventdata, handles);

plotIntensityHistogram(hObject, eventdata, handles);

plotFittingCurves(hObject, eventdata, handles);

displayThresholds(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in resetAllMinMaxButton.
function resetAllMinMaxButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetAllMinMaxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Resets all min and max intensities
handles.maxIntensityTraceAxes=max(handles.intensityTraces);
handles.minIntensityTraceAxes=min(handles.intensityTraces);

% Update handles structure
guidata(hObject, handles);

% Fits the intensity trace
fitIntensityTrace(hObject, eventdata,handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Finds thresholds and determines if it is blinking or not
findThresholds(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Plots and display
plotIntensityTrace(hObject, eventdata, handles);

plotIntensityHistogram(hObject, eventdata, handles);

plotFittingCurves(hObject, eventdata, handles);

displayThresholds(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% --- Updates the intensity histogram plot
function plotIntensityHistogram(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp('Updating intensity histogram plot...'); % debug
binSize=(handles.maxIntensityTraceAxes(handles.currentDotNumber)-handles.minIntensityTraceAxes(handles.currentDotNumber))/handles.nBins(handles.currentDotNumber);
handles.currentBinEdges = handles.minIntensityTraceAxes(handles.currentDotNumber):binSize:handles.maxIntensityTraceAxes(handles.currentDotNumber);
binEdges=handles.currentBinEdges;
h=histogram(handles.intensityHistogramAxes,...
    handles.intensityTraces(:,handles.currentDotNumber),...
    handles.currentBinEdges,...
    'Normalization','pdf');
xlabel(handles.intensityHistogramAxes,'Integr. intensity (arb. u.)','FontSize',12);
ylabel(handles.intensityHistogramAxes,'Normalized occurence','FontSize',12);
% l=legend(handles.intensityHistogramAxes,strcat('dot ',num2str(handles.currentDotNumber)),'Location','best');
% l.Interpreter='latex';
% l.FontSize=10;

grid(handles.intensityHistogramAxes,'on');

% Update handles structure
guidata(hObject, handles);


function numberOfBinsText_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfBinsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfBinsText as text
%        str2double(get(hObject,'String')) returns contents of numberOfBinsText as a double

% Updates the max intensity of the currentDot
%disp('Updating the number of bins...'); % debug
handles.currentNbins=round(str2double(get(hObject,'String')));

% Use default value if input is negative

if handles.currentNbins<=0
    handles.currentNbins=50;
    disp('Negative number of bins entered! Default value will be considered instead.')
end

%display(handles.currentNbins); %
%debug

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function numberOfBinsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfBinsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateHistogramButton.
function updateHistogramButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateHistogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Updates number of bins
handles.nBins(handles.currentDotNumber)=handles.currentNbins;

% Update handles structure
guidata(hObject, handles);

% Updates intensity trace plot
plotIntensityHistogram(hObject, eventdata, handles);
plotFittingCurves(hObject, eventdata, handles);
plotThresholds(hObject, eventdata, handles);

%author: Federico Pevere, 2016
%description: function used to fit the intensity trace of a blinking dot by
%using a double Gaussian function. The intensity trace is considered as a
%series of occurences of the statistical variable intensity.
%input: handles, dot number
%output: [muOff, stddevOff, aOff, muOn, stddevOn, aOn] (row vector)
%contanting the mean value of the OFFPERCENTAGETEXT state, the standard deviation ...

function [muOff, stddevOff, aOff, muOn, stddevOn, aOn, curveFitted] = fitIntensityTrace(hObject, eventdata, handles, dotNumber)

% Gets the current intensity trace data between min and max
[row,~]=find(handles.intensityTraces(:,dotNumber)>=handles.minIntensityTraceAxes(dotNumber)...
               & handles.intensityTraces(:,dotNumber)<=handles.maxIntensityTraceAxes(dotNumber));

intensityTraceData=handles.intensityTraces(row,dotNumber);

% Fits the data
warning('off');
curveFitted=true;
try
    obj = fitgmdist(intensityTraceData,2,'start','plus','CovarianceType','diagonal');
catch
    curveFitted=false;
    muOff=NaN;
    stddevOff=NaN;
    aOff=NaN;
    muOn=NaN;
    stddevOn=NaN;
    aOn=NaN;
    str=strcat('Error: the intensity trace of dot ',num2str(dotNumber),' could not be fitted with two Gaussians.');
    disp(str);
end
warning('on');

% Sorts output results if fitting has succeded
if curveFitted
    if obj.mu(1) < obj.mu(2)
        muOff= obj.mu(1);
        stddevOff=sqrt(obj.Sigma(1));
        aOff=obj.ComponentProportion(1)/(obj.ComponentProportion(1)+obj.ComponentProportion(2));
        muOn= obj.mu(2);
        stddevOn=sqrt(obj.Sigma(2));
        aOn=obj.ComponentProportion(2)/(obj.ComponentProportion(1)+obj.ComponentProportion(2));
    else
        muOn= obj.mu(1);
        stddevOn=sqrt(obj.Sigma(1));
        aOn=obj.ComponentProportion(1)/(obj.ComponentProportion(1)+obj.ComponentProportion(2));
        muOff= obj.mu(2);
        stddevOff=sqrt(obj.Sigma(2));
        aOff=obj.ComponentProportion(2)/(obj.ComponentProportion(1)+obj.ComponentProportion(2));
    end
end

handles.onMeanIntensities(dotNumber)=muOn;
handles.onStddevIntensities(dotNumber)=stddevOn;
handles.onAreas(dotNumber)=aOn;
handles.offMeanIntensities(dotNumber)=muOff;
handles.offStddevIntensities(dotNumber)=stddevOff;
handles.offAreas(dotNumber)=aOff;
handles.curvesFitted(dotNumber)=curveFitted;
handles.onToOffMeanIntensities(dotNumber)=muOn-muOff;
if (stddevOn^2-stddevOff^2)>0
    handles.onToOffStddevIntensities(dotNumber)=sqrt(stddevOn^2-stddevOff^2);
else
    handles.onToOffStddevIntensities(dotNumber)=NaN;
end

% Update handles structure
guidata(hObject, handles);


% --- Updates the fitting curves
function plotFittingCurves(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('Fitting data with double Gaussians...'); % debug


muOn=handles.onMeanIntensities(handles.currentDotNumber);
stddevOn=handles.onStddevIntensities(handles.currentDotNumber);
aOn=handles.onAreas(handles.currentDotNumber);
muOff=handles.offMeanIntensities(handles.currentDotNumber);
stddevOff=handles.offStddevIntensities(handles.currentDotNumber);
aOff=handles.offAreas(handles.currentDotNumber);
curveFitted=handles.curvesFitted(handles.currentDotNumber);

% Plot the fitted curves

if curveFitted
    x = handles.minIntensityTraceAxes(handles.currentDotNumber):1:handles.maxIntensityTraceAxes(handles.currentDotNumber);
    yOn = aOn*exp(-(x-muOn).^2./(2*stddevOn^2))./(stddevOn*sqrt(2*pi));
    yOff = aOff*exp(-(x-muOff).^2./(2*stddevOff^2))./(stddevOff*sqrt(2*pi));
    hold(handles.intensityHistogramAxes,'on');
    plot(handles.intensityHistogramAxes,x,yOff,'LineWidth',2,'LineStyle','-','Color','r');
    plot(handles.intensityHistogramAxes,x,yOn,'LineWidth',2,'LineStyle','-','Color','g');
    plot(handles.intensityHistogramAxes,x,(yOn+yOff),'Linewidth',2,'LineStyle','-','Color','b');
    xlim(handles.intensityHistogramAxes,[handles.minIntensityTraceAxes(handles.currentDotNumber) handles.maxIntensityTraceAxes(handles.currentDotNumber)]);
    l=legend(handles.intensityHistogramAxes,'Histogram','Off Gaussian Fit','On Gaussian Fit','Cumulative Fit','Location','best');
    l.FontSize=10;
    l.Interpreter='latex';
    hold(handles.intensityHistogramAxes,'off');
end

% Update handles structure
guidata(hObject, handles);

% Updates displayed fitting results

muOnText_Callback(hObject, eventdata, handles);
muOffText_Callback(hObject, eventdata, handles);
areaOnText_Callback(hObject, eventdata, handles);
areaOffText_Callback(hObject, eventdata, handles);
fittingSuccessfulText_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);



function muOnText_Callback(hObject, eventdata, handles)
% hObject    handle to muOnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of muOnText as text
%        str2double(get(hObject,'String')) returns contents of muOnText as a double

%get(handles.muOnText,'string');
precision=3;
stddevStr=num2str(handles.onStddevIntensities(handles.currentDotNumber),precision);
precision=3;
muStr=num2str(handles.onMeanIntensities(handles.currentDotNumber),precision);
str=[muStr ' ' '(' stddevStr ')'];
set(handles.muOnText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function muOnText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to muOnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function stddevOnText_Callback(hObject, eventdata, handles)
% hObject    handle to stddevOnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stddevOnText as text
%        str2double(get(hObject,'String')) returns contents of stddevOnText as a double

%get(handles.stddevOnText,'string');
precision=3;
str=num2str(handles.onStddevIntensities(handles.currentDotNumber),precision);
set(handles.stddevOnText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stddevOnText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stddevOnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function muOffText_Callback(hObject, eventdata, handles)
% hObject    handle to muOffText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of muOffText as text
%        str2double(get(hObject,'String')) returns contents of muOffText as a double

%get(handles.muOffText,'string');
precision=3;
stddevStr=num2str(handles.offStddevIntensities(handles.currentDotNumber),precision);
precision=3;
muStr=num2str(handles.offMeanIntensities(handles.currentDotNumber),precision);
str=[muStr ' ' '(' stddevStr ')'];
set(handles.muOffText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function muOffText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to muOffText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function stddevOffText_Callback(hObject, eventdata, handles)
% hObject    handle to stddevOffText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stddevOffText as text
%        str2double(get(hObject,'String')) returns contents of stddevOffText as a double

%get(handles.stddevOffText,'string');
precision=3;
str=num2str(handles.offStddevIntensities(handles.currentDotNumber),precision);
set(handles.stddevOffText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stddevOffText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stddevOffText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function areaOnText_Callback(hObject, eventdata, handles)
% hObject    handle to areaOnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of areaOnText as text
%        str2double(get(hObject,'String')) returns contents of areaOnText as a double

%get(handles.areaOnText,'string');
precision=3;
str=num2str(handles.onAreas(handles.currentDotNumber)*100,precision);
set(handles.areaOnText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function areaOnText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to areaOnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function areaOffText_Callback(hObject, eventdata, handles)
% hObject    handle to areaOffText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of areaOffText as text
%        str2double(get(hObject,'String')) returns contents of areaOffText as a double

%get(handles.areaOffText,'string');
precision=3;
str=num2str(handles.offAreas(handles.currentDotNumber)*100,precision);
set(handles.areaOffText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function areaOffText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to areaOffText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fittingSuccessfulText_Callback(hObject, eventdata, handles)
% hObject    handle to fittingSuccessfulText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fittingSuccessfulText as text
%        str2double(get(hObject,'String')) returns contents of fittingSuccessfulText as a double

%get(handles.fittingSuccessfulText,'string');
if handles.curvesFitted(handles.currentDotNumber)
    str='Yes';
    set(handles.fittingSuccessfulText,'string',str);
else
    str='No';
    set(handles.fittingSuccessfulText,'string',str);
end

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fittingSuccessfulText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fittingSuccessfulText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [lowerOnThreshold,centerThreshold,upperOffThreshold,isBlinking]=findThresholds(hObject,eventdata,handles, dotNumber)

% Stores fitting results in local variables
muOn=handles.onMeanIntensities(dotNumber);
stddevOn=handles.onStddevIntensities(dotNumber);
aOn=handles.onAreas(dotNumber);
muOff=handles.offMeanIntensities(dotNumber);
stddevOff=handles.offStddevIntensities(dotNumber);
aOff=handles.offAreas(dotNumber);
curveFitted=handles.curvesFitted(dotNumber);

% Determines if it is blinking or not
isBlinking=(muOn-muOff-(stddevOn+stddevOff))>0;
handles.isBlinking(dotNumber)=isBlinking;

% Updates handles structure
guidata(hObject, handles);

if isBlinking

    % Calculates thresholds
    wellSeparatedOnOffLevels=(muOn-muOff-3*(stddevOn+stddevOff))>0;
    handles.wellSeparatedOnOffLevels(dotNumber)=wellSeparatedOnOffLevels;
    % Updates handles structure
    guidata(hObject, handles);

    if wellSeparatedOnOffLevels
        % One threshold
       lowerOnThreshold=(muOff+3*stddevOff+muOn-3*stddevOn)/2;
       centerThreshold=lowerOnThreshold;
       upperOffThreshold=lowerOnThreshold;
    else
        % Two threhsolds
        x = (muOff:1:muOn)';
        onGaussian = aOn.*pdf('Normal',x,muOn,stddevOn);
        offGaussian = aOff.*pdf('Normal',x,muOff,stddevOff);
        [M,I] = min(abs(onGaussian-offGaussian));
        % Calculates center threshold
        centerThreshold=x(I);

        % Calculates On- and offpercentagetext- thresholds
        lowerOnThreshold=muOn-3*stddevOn; %initial value
        upperOffThreshold=muOff+3*stddevOff; %initial value

        % Checks if they go beyond mean values
        if lowerOnThreshold < muOff
            lowerOnThreshold=muOff;
        end

        if upperOffThreshold > muOn
            upperOffThreshold=muOn;
        end

        % Takes an average between center threshold and previously
        % calculated values of upperOff and lowerOn thesholds

        upperOffThreshold=(upperOffThreshold+centerThreshold)/2;
        lowerOnThreshold=(lowerOnThreshold+centerThreshold)/2;

    end

else
    lowerOnThreshold=NaN;
    centerThreshold=NaN;
    upperOffThreshold=NaN;
end

handles.lowerOnThreshold(dotNumber)=lowerOnThreshold;
handles.centerThreshold(dotNumber)=centerThreshold;
handles.upperOffThreshold(dotNumber)=upperOffThreshold;

% Updates handles structure
guidata(hObject, handles);




function isBlinkingText_Callback(hObject, eventdata, handles)
% hObject    handle to isBlinkingText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of isBlinkingText as text
%        str2double(get(hObject,'String')) returns contents of isBlinkingText as a double

if handles.isBlinking(handles.currentDotNumber)
    str='Yes';
else
    str='No';
end

set(handles.isBlinkingText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function isBlinkingText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isBlinkingText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxOffThresholdText_Callback(hObject, eventdata, handles)
% hObject    handle to maxOffThresholdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxOffThresholdText as text
%        str2double(get(hObject,'String')) returns contents of maxOffThresholdText as a double

precision=3;
str=num2str(handles.upperOffThreshold(handles.currentDotNumber),precision);
set(handles.maxOffThresholdText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxOffThresholdText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxOffThresholdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minOnThresholdText_Callback(hObject, eventdata, handles)
% hObject    handle to minOnThresholdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minOnThresholdText as text
%        str2double(get(hObject,'String')) returns contents of minOnThresholdText as a double

precision=3;
str=num2str(handles.lowerOnThreshold(handles.currentDotNumber),precision);
set(handles.minOnThresholdText,'string',str);

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minOnThresholdText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minOnThresholdText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plotThresholds(hObject, eventdata, handles)

if handles.isBlinking(handles.currentDotNumber)
    hold(handles.intensityHistogramAxes,'on');
    YLim=handles.intensityHistogramAxes.YLim;
    lowerOnThr = handles.lowerOnThreshold(handles.currentDotNumber)*ones(1,2);
    centerThr= handles.centerThreshold(handles.currentDotNumber)*ones(1,2);
    upperOffThr = handles.upperOffThreshold(handles.currentDotNumber)*ones(1,2);
    plot(handles.intensityHistogramAxes,lowerOnThr,YLim,'LineWidth',1,'LineStyle','--','Color','g');
    plot(handles.intensityHistogramAxes,centerThr,YLim,'LineWidth',1,'LineStyle',':','Color','b');
    plot(handles.intensityHistogramAxes,upperOffThr,YLim,'LineWidth',1,'LineStyle','--','Color','r');
    xlim(handles.intensityHistogramAxes,[handles.minIntensityTraceAxes(handles.currentDotNumber) handles.maxIntensityTraceAxes(handles.currentDotNumber)]);
    l=legend(handles.intensityHistogramAxes,'Histogram','OFF Gauss Fit','ON Gauss Fit','Cumulative Fit','Min ON Thr.','Cross-point','Max OFF Thr.','Location','best');
    l.FontSize=10;
    l.Interpreter='latex';
    hold(handles.intensityHistogramAxes,'off');
end

% Updates handles structure
guidata(hObject, handles);


function displayThresholds(hObject, eventdata, handles)

minOnThresholdText_Callback(hObject, eventdata, handles);
isBlinkingText_Callback(hObject, eventdata, handles);
maxOffThresholdText_Callback(hObject, eventdata, handles);

plotThresholds(hObject, eventdata, handles);

% Updates handles structure
guidata(hObject, handles);

function displayOnOffTimesResults(hObject, eventdata, handles)

nBlinkingEventsText_Callback(hObject, eventdata, handles);
meanOnTimeText_Callback(hObject, eventdata, handles);
meanOffTimeText_Callback(hObject, eventdata, handles);
onPercentageText_Callback(hObject, eventdata, handles);
offPercentageText_Callback(hObject, eventdata, handles);

% Updates handles structure
guidata(hObject, handles);


function displayOnOffTimeHistFitResults(hObject, eventdata, handles)

onLifetimeText_Callback(hObject, eventdata, handles);
offLifetimeText_Callback(hObject, eventdata, handles);
onDutyCycleText_Callback(hObject, eventdata, handles);
offDutyCycleText_Callback(hObject, eventdata, handles);

% Updates handles structure
guidata(hObject, handles);

% --- Executes on button press in saveBlinkingDotsDataButton.
function saveBlinkingDotsDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveBlinkingDotsDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Saving blinking dots data...');

t=datetime('now','TimeZone','local','Format','y-MM-dd-HH:mm');
handles.t=t;

% Updates handles structure
guidata(hObject, handles);

blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);
disp(['Number of blinking dots: ' num2str(nBlinkingDots)]);

if nBlinkingDots~=0

    % Save intensity histogram fitting results
    saveIntensityHistogramFittingResults(hObject, eventdata, handles);

    % Save ON and OFF times
    saveOnOffTimes(hObject, eventdata, handles);

    % Save ON and OFF results
    saveOnOffResults(hObject, eventdata, handles);

    % Save ON and OFF time histogram fitting results
    saveOnOffTimeHistFitResults(hObject, eventdata, handles);

    disp('The results of the blinking dots were sucessfully saved!');
else
    disp('There are no blinking dots to save data of.');
end


% --- Save intensity histogram fitting results
function saveIntensityHistogramFittingResults(hObject, eventdata, handles)

tracePathName=handles.tracePathName;
traceFileName=handles.traceFileName;

% --- Intensity Fitting Results

blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);
variableNames = {'dot','wellSeparatedLevels','intensityOn','stddevOn','intensityOff','stddevOff',...
'intensityOntoOff','stddevOnToOff','areaOn','areaOff','lowerThreshold',...
'centerThreshold','upperThreshold'};
variableUnits = {' ',' ','arb. u.', 'arb. u.', 'arb. u.','arb. u.','arb. u.',...
    'arb. u.','%','%','arb. u.','arb. u.', 'arb. u.'};
nVariables=size(variableNames,2);
fittingResultsTable=zeros(nBlinkingDots,nVariables);
fittingResultsTable(:,1)=blinkingDots';

% Saves data in local variables (for simplicity)
muOn=handles.onMeanIntensities(blinkingDots)';
stddevOn=handles.onStddevIntensities(blinkingDots)';
aOn=100*handles.onAreas(blinkingDots)';
muOff=handles.offMeanIntensities(blinkingDots)';
stddevOff=handles.offStddevIntensities(blinkingDots)';
aOff=100*handles.offAreas(blinkingDots)';
muOnToOff=handles.onToOffMeanIntensities(blinkingDots)';
stddevOnToOff=handles.onToOffStddevIntensities(blinkingDots)';
lowerOnThr = handles.lowerOnThreshold(blinkingDots)';
centerThr= handles.centerThreshold(blinkingDots)';
upperOffThr = handles.upperOffThreshold(blinkingDots)';
wellSeparatedOnOffLevels=handles.wellSeparatedOnOffLevels(blinkingDots)';

% Makes array of all the fitting results
fittingResultsTable(:,2:nVariables)=[wellSeparatedOnOffLevels muOn...
    stddevOn muOff stddevOff muOnToOff stddevOnToOff aOn aOff...
    lowerOnThr centerThr upperOffThr ];

% Saves the fitting results together with the units
resultsOutput = cell2table(num2cell(fittingResultsTable),'VariableNames',variableNames);
resultsOutput.Properties.VariableUnits=variableUnits;
resultsUnits=cell2table(variableUnits,'VariableNames',variableNames);
assignin('base','intFitResults',resultsOutput);
assignin('base','intFitUnits',resultsUnits);

format='yyyy-mm-dd_HH-MM';
tStr=datestr(handles.t,format);

writetable(resultsOutput,[tracePathName tStr '_intFitResults_' traceFileName],'Delimiter','tab');
writetable(resultsUnits,[tracePathName tStr '_intFitUnits_' traceFileName],'Delimiter','tab');

% --- Save intensity histogram fitting results
function saveOnOffTimes(hObject, eventdata, handles)

tracePathName=handles.tracePathName;
traceFileName=handles.traceFileName;

% --- ON- OFF- times results
blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);

i=1;
variableNames = {strcat('dot',num2str(blinkingDots(1)),'on'),strcat('dot',num2str(blinkingDots(1)),'off')};
variableUnits = {'s','s'};

for i=2:nBlinkingDots
    variableNames = [variableNames {strcat('dot',num2str(blinkingDots(i)),'on'),strcat('dot',num2str(blinkingDots(i)),'off')}];
    variableUnits = [variableUnits {'s','s'}];
end


% Saves data in local variables (for simplicity)
onTimes=handles.onTimes;
offTimes=handles.offTimes;


% Makes the ON- OFF- time array
onOffTimesTable=NaN(size(onTimes,1),2*size(onTimes,2));
i=1;
onOffTimesTable=[onTimes(:,blinkingDots(1)),offTimes(:,blinkingDots(1))];

for i=2:nBlinkingDots
   onOffTimesTable=[onOffTimesTable, onTimes(:,blinkingDots(i)), offTimes(:,blinkingDots(i))];
end


% Creates on-off times array
%onPercentage=handles.onPercentage;
%offPercentage=handles.offPercentage;

% Saves the ON- OFF- times with the units
resultsOutput = cell2table(num2cell(onOffTimesTable),'VariableNames',variableNames);
resultsOutput.Properties.VariableUnits=variableUnits;
resultsUnits=cell2table(variableUnits,'VariableNames',variableNames);
assignin('base','onOffTresults',resultsOutput);
assignin('base','onOffTunits',resultsUnits);

format='yyyy-mm-dd_HH-MM';
tStr=datestr(handles.t,format);

writetable(resultsOutput,[tracePathName tStr '_onOffTresults_' traceFileName],'Delimiter','tab');
writetable(resultsUnits,[tracePathName tStr '_onOffTunits_' traceFileName],'Delimiter','tab');

% --- Save ON/OFF results
function saveOnOffResults(hObject, eventdata, handles)

tracePathName=handles.tracePathName;
traceFileName=handles.traceFileName;

% --- Save ON/OFF results

blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);
variableNames = {'dot','blinkingEvents','onOffBlinkingEvents','offOnBlinkingEvents','meanOnTime','meanOffTime','onPercentage','offPercentage'};
variableUnits = {' ',' ',' ',' ','s', 's', '%','%'};
nVariables=size(variableNames,2);
onOffResultsTable=zeros(nBlinkingDots,nVariables);
onOffResultsTable(:,1)=blinkingDots';

% Saves data in local variables (for simplicity)
nBlinkingEvents=handles.nBlinkingEvents(blinkingDots)';
nOnOffBlinkingEvents=handles.nOnOffBlinkingEvents(blinkingDots)';
nOffOnBlinkingEvents=handles.nOffOnBlinkingEvents(blinkingDots)';
meanOnTime=zeros(nBlinkingDots,1);
meanOffTime=zeros(nBlinkingDots,1);
onPercentage=zeros(nBlinkingDots,1);
offPercentage=zeros(nBlinkingDots,1);

for i=1:nBlinkingDots
    meanOnTime(i)=handles.meanOnTime(nOnOffBlinkingEvents(i),blinkingDots(i));
    meanOffTime(i)=handles.meanOffTime(nOffOnBlinkingEvents(i),blinkingDots(i));
    onPercentage(i)=handles.onPercentage(nBlinkingEvents(i),blinkingDots(i));
    offPercentage(i)=handles.offPercentage(nBlinkingEvents(i),blinkingDots(i));
end

% Makes array of all the fitting results
onOffResultsTable(:,2:nVariables)=[nBlinkingEvents nOnOffBlinkingEvents nOffOnBlinkingEvents meanOnTime...
    meanOffTime onPercentage offPercentage];

% Saves the fitting results together with the units
resultsOutput = cell2table(num2cell(onOffResultsTable),'VariableNames',variableNames);
resultsOutput.Properties.VariableUnits=variableUnits;
resultsUnits=cell2table(variableUnits,'VariableNames',variableNames);
assignin('base','onOffResults',resultsOutput);
assignin('base','onOffUnits',resultsUnits);

format='yyyy-mm-dd_HH-MM';
tStr=datestr(handles.t,format);

writetable(resultsOutput,[tracePathName tStr '_onOffResults_' traceFileName],'Delimiter','tab');
writetable(resultsUnits,[tracePathName tStr '_onOffUnits_' traceFileName],'Delimiter','tab');

function saveOnOffTimeHistFitResults(hObject, eventdata, handles)

tracePathName=handles.tracePathName;
traceFileName=handles.traceFileName;

% --- Save ON/OFF time histogram fitting (or ON/OFF time statistics)

blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);
variableNames = {'dot','minOnTimeHist','maxOnTimeHist','binWidthOnTimeHist',...
    'minOnTimeFit','maxOnTimeFit','minOffTimeHist','maxOffTimeHist',...
    'binWidthOffTimeHist','minOffTimeFit','maxOffTimeFit','adjRsquareOn',...
    'adjRsquareOff','tauOnValue','tauOnStddev','tauOffValue','tauOffStddev',...
    'dutyOnValue','dutyOnStddev','dutyOffValue','dutyOffStddev'};
variableUnits = {' ','s','s','s','s','s','s','s','s','s','s',' ',' ','s','s',...
    's','s','%','%','%','%'};
nVariables=size(variableNames,2);
onOffStatsTable=zeros(nBlinkingDots,nVariables);
onOffStatsTable(:,1)=blinkingDots';

% Saves data in local variables (for simplicity)
minOnTimeHist=handles.minOnTimeHistogramAxes(1,blinkingDots)';
maxOnTimeHist=handles.maxOnTimeHistogramAxes(1,blinkingDots)';
binWidthOnTimeHist=handles.binWidthOnTimeHist(1,blinkingDots)';
minOnTimeFit=handles.minOnTimeHistFit(1,blinkingDots)';
maxOnTimeFit=handles.maxOnTimeHistFit(1,blinkingDots)';
minOffTimeHist=handles.minOffTimeHistogramAxes(1,blinkingDots)';
maxOffTimeHist=handles.maxOffTimeHistogramAxes(1,blinkingDots)';
binWidthOffTimeHist=handles.binWidthOffTimeHist(1,blinkingDots)';
minOffTimeFit=handles.minOffTimeHistFit(1,blinkingDots)';
maxOffTfimeFit=handles.maxOffTimeHistFit(1,blinkingDots)';
adjRsquareOn=handles.onTimeHistFitAdjrsquare(1,blinkingDots)';
adjRsquareOff=handles.offTimeHistFitAdjrsquare(1,blinkingDots)';
tauOnValue=handles.onLifetimeValue(1,blinkingDots)';
tauOnStddev=handles.onLifetimeStddev(1,blinkingDots)';
tauOffValue=handles.offLifetimeValue(1,blinkingDots)';
tauOffStddev=handles.offLifetimeStddev(1,blinkingDots)';
dutyOnValue=handles.onDutyCycleStatsValue(1,blinkingDots)';
dutyOnStddev=handles.onDutyCycleStatsStddev(1,blinkingDots)';
dutyOffValue=handles.offDutyCycleStatsValue(1,blinkingDots)';
dutyOffStddev=handles.offDutyCycleStatsStddev(1,blinkingDots)';


% Makes array of all the fitting results
onOffStatsTable(:,2:nVariables)=[minOnTimeHist maxOnTimeHist binWidthOnTimeHist...
    minOnTimeFit maxOnTimeFit minOffTimeHist maxOffTimeHist binWidthOffTimeHist...
    minOffTimeFit maxOffTfimeFit adjRsquareOn adjRsquareOff tauOnValue...
    tauOnStddev tauOffValue tauOffStddev dutyOnValue dutyOnStddev dutyOffValue...
    dutyOffStddev];

% Saves the fitting results together with the units
resultsOutput = cell2table(num2cell(onOffStatsTable),'VariableNames',variableNames);
resultsOutput.Properties.VariableUnits=variableUnits;
resultsUnits=cell2table(variableUnits,'VariableNames',variableNames);
assignin('base','onOffThistFitResults',resultsOutput);
assignin('base','onOffThistFitUnits',resultsUnits);

format='yyyy-mm-dd_HH-MM';
tStr=datestr(handles.t,format);

writetable(resultsOutput,[tracePathName tStr '_onOffThistFitResults_' traceFileName],'Delimiter','tab');
writetable(resultsUnits,[tracePathName tStr '_onOffThistFitUnits_' traceFileName],'Delimiter','tab');

% --- Executes on button press in recalculateOnOffTimesButton.
function recalculateOnOffTimesButton_Callback(hObject, eventdata, handles)
% hObject    handle to recalculateOnOffTimesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dotNumber=handles.currentDotNumber;

getOnOffTimes(hObject, eventdata, handles, dotNumber);
handles = guidata(hObject);

displayOnOffTimesResults(hObject, eventdata, handles);

plotOnPercentage(hObject, eventdata, handles);
plotMeanTimes(hObject, eventdata, handles);

%Update displayed text ON/OFF- time histograms and fitting
set(handles.minOnTimeHistText,'String',num2str(handles.minOnTimeHistogramAxes(dotNumber)));
set(handles.maxOnTimeHistText,'String',num2str(handles.maxOnTimeHistogramAxes(dotNumber)));
set(handles.minOffTimeHistText,'String',num2str(handles.minOffTimeHistogramAxes(dotNumber)));
set(handles.maxOffTimeHistText,'String',num2str(handles.maxOffTimeHistogramAxes(dotNumber)));
set(handles.binWidthOnTimeHistText,'String',num2str(handles.binWidthOnTimeHist(dotNumber)));
set(handles.binWidthOffTimeHistText,'String',num2str(handles.binWidthOffTimeHist(dotNumber)));
set(handles.minOnTimeHistFitText,'String',num2str(handles.minOnTimeHistFit(dotNumber)));
set(handles.maxOnTimeHistFitText,'String',num2str(handles.maxOnTimeHistFit(dotNumber)));
set(handles.minOffTimeHistFitText,'String',num2str(handles.minOffTimeHistFit(dotNumber)));
set(handles.maxOffTimeHistFitText,'String',num2str(handles.maxOffTimeHistFit(dotNumber)));
handles.currentMinOnTimeHistogram=handles.minOnTimeHistogramAxes(dotNumber); %user-input min On time histogram
handles.currentMaxOnTimeHistogram=handles.maxOnTimeHistogramAxes(dotNumber); %user-input max On time histogram
handles.currentMinOffTimeHistogram=handles.minOffTimeHistogramAxes(dotNumber); %user-input min Off time histogram
handles.currentMaxOffTimeHistogram=handles.maxOffTimeHistogramAxes(dotNumber); %user-input max Off time histogram
handles.currentBinWidthOnTimeHist=handles.binWidthOnTimeHist(dotNumber);
handles.currentBinWidthOffTimeHist=handles.binWidthOffTimeHist(dotNumber);
handles.currentMinOnTimeHistFit=handles.minOnTimeHistFit(dotNumber); %user-input min On time hist. linear fit
handles.currentMaxOnTimeHistFit=handles.maxOnTimeHistFit(dotNumber); %user-input max On time hist. linear fit
handles.currentMinOffTimeHistFit=handles.minOffTimeHistFit(dotNumber); %user-input min Off time hist. linear fit
handles.currentMaxOffTimeHistFit=handles.maxOffTimeHistFit(dotNumber); %user-input max Off time hist. linear fit


calculateOnTimeHistogram(hObject, eventdata, handles, dotNumber);
handles = guidata(hObject);

calculateOffTimeHistogram(hObject, eventdata, handles, dotNumber);
handles = guidata(hObject);

plotOnTimeHistogram(hObject, eventdata, handles);
plotOffTimeHistogram(hObject, eventdata, handles);

% Fits ON time histogram
fitOnTimeHistogram(hObject, eventdata, handles, dotNumber);
% Retrieves new handles
handles = guidata(hObject);
% Fits OFF time histograms
fitOffTimeHistogram(hObject, eventdata, handles, dotNumber)
% Retrieves new handles
handles = guidata(hObject);
% Calculates ON/OFF duty cycle from time histograms fitting results
calculateDutyCycleStats(hObject, eventdata, handles, dotNumber);

displayOnOffTimeHistFitResults(hObject, eventdata, handles);

plotOnTimeHistFitLine(hObject, eventdata, handles);

plotOffTimeHistFitLine(hObject, eventdata, handles);

% Updates handles structure
guidata(hObject, handles);



function nBlinkingEventsText_Callback(hObject, eventdata, handles)
% hObject    handle to nBlinkingEventsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nBlinkingEventsText as text
%        str2double(get(hObject,'String')) returns contents of nBlinkingEventsText as a double

if handles.isBlinking(handles.currentDotNumber)
    set(handles.nBlinkingEventsText,'Visible','on');
    precision=3;
    str=num2str(handles.nBlinkingEvents(handles.currentDotNumber),precision);
    set(handles.nBlinkingEventsText,'string',str);

else
    set(handles.nBlinkingEventsText,'Visible','off');
end

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function nBlinkingEventsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nBlinkingEventsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanOnTimeText_Callback(hObject, eventdata, handles)
% hObject    handle to meanOnTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanOnTimeText as text
%        str2double(get(hObject,'String')) returns contents of meanOnTimeText as a double

if handles.isBlinking(handles.currentDotNumber)
    set(handles.meanOnTimeText,'Visible','on');
    precision=3;
    str=num2str(handles.meanOnTime(handles.nOnOffBlinkingEvents(handles.currentDotNumber),handles.currentDotNumber),precision);
    set(handles.meanOnTimeText,'string',str);
else
    set(handles.meanOnTimeText,'Visible','off');
end

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function meanOnTimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanOnTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanOffTimeText_Callback(hObject, eventdata, handles)
% hObject    handle to meanOffTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanOffTimeText as text
%        str2double(get(hObject,'String')) returns contents of meanOffTimeText as a double

if handles.isBlinking(handles.currentDotNumber)
    set(handles.meanOffTimeText,'Visible','on');
    precision=3;
    str=num2str(handles.meanOffTime(handles.nOffOnBlinkingEvents(handles.currentDotNumber),handles.currentDotNumber),precision);
    set(handles.meanOffTimeText,'string',str);
else
    set(handles.meanOffTimeText,'Visible','off');
end

% Updates handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function meanOffTimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanOffTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onPercentageText_Callback(hObject, eventdata, handles)
% hObject    handle to onPercentageText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onPercentageText as text
%        str2double(get(hObject,'String')) returns contents of onPercentageText as a double

if handles.isBlinking(handles.currentDotNumber)
    set(handles.onPercentageText,'Visible','on');
    precision=3;
    str=num2str(handles.onDutyCycle(handles.currentDotNumber),precision);
    set(handles.onPercentageText,'string',str);
else
    set(handles.onPercentageText,'Visible','off');
end

% Updates handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function onPercentageText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onPercentageText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function offPercentageText_Callback(hObject, eventdata, handles)
% hObject    handle to offPercentageText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offPercentageText as text
%        str2double(get(hObject,'String')) returns contents of offPercentageText as a double

if handles.isBlinking(handles.currentDotNumber)
    set(handles.offPercentageText,'Visible','on');
    precision=3;
    str=num2str(100-handles.onDutyCycle(handles.currentDotNumber),precision);
    set(handles.offPercentageText,'string',str);
else
    set(handles.offPercentageText,'Visible','off');
end

% Updates handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function offPercentageText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offPercentageText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [nBlinkingEvents, onTimes, offTimes, onPercentage, offPercentage, onDutyCycle]=getOnOffTimes(hObject, eventdata, handles, dotNumber)
% hObject    handle to ... (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialization

nBlinkingEvents=NaN;
onTimes=NaN;
offTimes=NaN;
onPercentage=NaN;
offPercentage=NaN;
onDutyCycle=NaN;


if handles.isBlinking(dotNumber)

    %disp('Calculating ON-OFF times...')
    %disp(['Dot number: ' num2str(dotNumber)]);

    % Store data in local variables (for simplicity)
    intensityTrace=handles.intensityTraces(:,dotNumber);
    nFrames=handles.nFrames;
    frameTime=handles.frameTime;
    centerThr=handles.centerThreshold(dotNumber);
    lowerOnThr=handles.lowerOnThreshold(dotNumber);
    upperOffThr=handles.upperOffThreshold(dotNumber);

    onTimes=NaN(round(nFrames/2),1);
    offTimes=NaN(round(nFrames/2),1);
    meanOnTime=NaN(round(nFrames/2),1);
    onPercentage=NaN(nFrames,1);
    meanOffTime=NaN(round(nFrames/2),1);
    offPercentage=NaN(nFrames,1);

    % --- Initialization for the blinking dot
    %disp('Initialization...');
    firstBlinkingEvent=1;
    nBlinkingEvents=0;
    onOffEventNumber=0;
    offOnEventNumber=0;
    onTime=0;
    offTime=0;
    cumulativeOnTime=0;
    cumulativeOffTime=0;

    % --- Find initial state
    %disp('Find initial state...');
    frameNumber=1;

    if intensityTrace(1,frameNumber) > centerThr
        isOn=true;
        %onTime=onTime+frameTime; % removed to skip first ON-time
        %cumulativeOnTime=cumulativeOnTime+onTime;
        %disp('Initial state: ON');
    else
        isOn=false;
        %offTime=offTime+frameTime; % removed to skip first OFF-time
        %cumulativeOffTime=cumulativeOffTime+offTime;
        %disp('Initial state: OFF');
    end

    % --- Extract states

    for frameNumber=2:nFrames
        if isOn
            % Checks new state
            if intensityTrace(frameNumber) < lowerOnThr
                % --- ON to OFF switching event

                if ~firstBlinkingEvent

                    nBlinkingEvents=nBlinkingEvents+1;
                    onOffEventNumber=onOffEventNumber+1;
                    onTimes(onOffEventNumber)=onTime; %saves ON time

                    % Updates cumulative times
                    cumulativeOnTime=cumulativeOnTime+onTime;
                    cumulativeOffTime=cumulativeOffTime+offTime;

                    % Updates ON- and OFF- percentages
                    onPercentage(nBlinkingEvents)=100*cumulativeOnTime/(cumulativeOnTime+cumulativeOffTime);
                    offPercentage(nBlinkingEvents)=100*cumulativeOffTime/(cumulativeOnTime+cumulativeOffTime);

                    % Updates ON- mean times
                    meanOnTime(onOffEventNumber)=cumulativeOnTime/onOffEventNumber;

                else
                    % First blinking event just occured
                    firstBlinkingEvent=0;
                end

                % Updates state
                isOn=false;
                onTime=0;
                offTime=frameTime;

            else
               % still in ON state
               onTime=onTime+frameTime;
            end
        else
            % Checks new state
            if intensityTrace(frameNumber) > upperOffThr
                % --- OFF to ON switching event

                if ~firstBlinkingEvent

                    nBlinkingEvents=nBlinkingEvents+1;
                    offOnEventNumber=offOnEventNumber+1;
                    offTimes(offOnEventNumber)=offTime; %saves OFF time

                    % Updates cumulative times
                    cumulativeOnTime=cumulativeOnTime+onTime;
                    cumulativeOffTime=cumulativeOffTime+offTime;

                    % Updates ON- and OFF- percentages
                    onPercentage(nBlinkingEvents)=100*cumulativeOnTime/(cumulativeOnTime+cumulativeOffTime);
                    offPercentage(nBlinkingEvents)=100*cumulativeOffTime/(cumulativeOnTime+cumulativeOffTime);

                    % Updates OFF- mean times
                    meanOffTime(offOnEventNumber)=cumulativeOffTime/offOnEventNumber;

                else
                    % First blinking event just occured
                    firstBlinkingEvent=0;
                end

                isOn=true;
                onTime=frameTime;
                offTime=0;

            else
               % still in OFF state
               offTime=offTime+frameTime;
            end

        end

    end

    % Update handles structure

    if nBlinkingEvents==0
        handles.isBlinking(dotNumber)=false;
    else

        % ON and OFF times and blinking results
        handles.onTimes(:,dotNumber)=onTimes;
        handles.offTimes(:,dotNumber)=offTimes;
        handles.onPercentage(:,dotNumber)=onPercentage;
        handles.offPercentage(:,dotNumber)=offPercentage;
        handles.nBlinkingEvents(:,dotNumber)=nBlinkingEvents;
        handles.nOnOffBlinkingEvents(1,dotNumber)=onOffEventNumber;
        handles.nOffOnBlinkingEvents(1,dotNumber)=offOnEventNumber;
        handles.onDutyCycle(dotNumber)=onPercentage(nBlinkingEvents);
        handles.meanOnTime(:,dotNumber)=meanOnTime;
        handles.meanOffTime(:,dotNumber)=meanOffTime;

        % ON and OFF times histogram and fitting lines
        % the min values are set by frameTime/2
        % only the max values must be updated
        % handles.minOnTimeHistogramAxes(dotNumber)=min(onTimes);
        handles.maxOnTimeHistogramAxes(dotNumber)=max(onTimes);
        %handles.minOffTimeHistogramAxes(dotNumber)=min(offTimes);
        handles.maxOffTimeHistogramAxes(dotNumber)=max(offTimes);
        %handles.minOnTimeHistFit(dotNumber)=min(onTimes);
        handles.maxOnTimeHistFit(dotNumber)=max(onTimes);
        %handles.minOffTimeHistFit(dotNumber)=min(offTimes);
        handles.maxOffTimeHistFit(dotNumber)=max(offTimes);

    end
end

% Updates handles structure
guidata(hObject, handles);


function plotOnPercentage(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.isBlinking(handles.currentDotNumber)
    % disp('Updating on percentage plot...'); % debug

    nBlinkingEvents=handles.nBlinkingEvents(handles.currentDotNumber);
    blinkingEvents=1:nBlinkingEvents;
    %meanOnTime=handles.meanOnTime(handles.nOnOffBlinkingEvents(handles.currentDotNumber),handles.currentDotNumber);
    %meanOffTime=handles.meanOffTime(handles.nOffOnBlinkingEvents(handles.currentDotNumber),handles.currentDotNumber);

    plot(handles.onPercentageAxes,blinkingEvents,handles.onPercentage(1:nBlinkingEvents,handles.currentDotNumber),'LineWidth',1,'LineStyle','-','Color','b');
    ylim(handles.onPercentageAxes,[0 100]);
    xlim(handles.onPercentageAxes,[1 nBlinkingEvents])
    xlabel(handles.onPercentageAxes,'Blinking event','FontSize',12);
    hy=ylabel(handles.onPercentageAxes,'$$\delta_{ON}$$ (\%)','FontSize',12,'Interpreter','latex');
    %hy.Interpreter='latex';
    onDutyCycle = handles.onDutyCycleStatsValue(handles.currentDotNumber)*ones(size(blinkingEvents)); %from ON/OFF-time histogram fitting
    areaOn=handles.onAreas(handles.currentDotNumber)*ones(size(blinkingEvents)); %from area of Gaussian fitting
    %blinkingStatOnDutyCycle=meanOnTime*ones(size(blinkingEvents))/(meanOnTime+meanOffTime);
    hold(handles.onPercentageAxes,'on');
    plot(handles.onPercentageAxes,blinkingEvents,onDutyCycle,'LineWidth',1,'LineStyle','--','Color','b');
    plot(handles.onPercentageAxes,blinkingEvents,100*areaOn,'LineWidth',1,'LineStyle','-','Color','g');
    %plot(handles.onPercentageAxes,blinkingEvents,100*blinkingStatOnDutyCycle,'LineWidth',1,'LineStyle','-','Color','m');
    hold(handles.onPercentageAxes,'off');
    l=legend(handles.onPercentageAxes,'blinking data','$$\delta_{ON,Time-hist. Fit}$$','$$\delta_{ON,Gauss Fit}$$','Location','northeast');
    l.Interpreter='latex';
    l.FontSize=10;
    grid(handles.onPercentageAxes,'on');
    set(handles.onPercentageAxes,'visible','on');
else
    A = get(handles.onPercentageAxes,'children'); %Contains all data on onPercentageAxes
    set(A,'visible','off');
end

% Update handles structure
guidata(hObject, handles);



function plotMeanTimes(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.isBlinking(handles.currentDotNumber)
    % disp('Updating off percentage plot...'); % debug
    nOnOffBlinkingEvents=handles.nOnOffBlinkingEvents(handles.currentDotNumber);
    onOffBlinkingEvents=1:nOnOffBlinkingEvents;
    nOffOnBlinkingEvents=handles.nOffOnBlinkingEvents(handles.currentDotNumber);
    offOnBlinkingEvents=1:nOffOnBlinkingEvents;
    cla(handles.meanOnOffTimeAxes);
    hold(handles.meanOnOffTimeAxes,'on');
    plot(handles.meanOnOffTimeAxes,onOffBlinkingEvents,handles.meanOnTime(1:nOnOffBlinkingEvents,handles.currentDotNumber),'LineWidth',1,'LineStyle','-','Color','g');
    plot(handles.meanOnOffTimeAxes,offOnBlinkingEvents,handles.meanOffTime(1:nOffOnBlinkingEvents,handles.currentDotNumber),'LineWidth',1,'LineStyle','-','Color','r');
    meanOnTime = handles.onLifetimeValue(handles.currentDotNumber)*ones(size(onOffBlinkingEvents)); %from ON/OFF time histogram fitting
    meanOffTime = handles.offLifetimeValue(handles.currentDotNumber)*ones(size(offOnBlinkingEvents)); %from ON/OFF time histogram fitting
    plot(handles.meanOnOffTimeAxes,onOffBlinkingEvents,meanOnTime,'LineWidth',1,'LineStyle','--','Color','g');
    plot(handles.meanOnOffTimeAxes,offOnBlinkingEvents,meanOffTime,'LineWidth',1,'LineStyle','--','Color','r');
    set(handles.meanOnOffTimeAxes,'yscale','log')
    xlim(handles.meanOnOffTimeAxes,[1 max(nOnOffBlinkingEvents,nOffOnBlinkingEvents)]);
    xlabel(handles.meanOnOffTimeAxes,'ON-OFF/OFF-ON Blinking event','FontSize',12);
    hy=ylabel(handles.meanOnOffTimeAxes,'Mean time (s)','FontSize',12,'Interpreter','none');
    hold(handles.meanOnOffTimeAxes,'off');
    l=legend(handles.meanOnOffTimeAxes,'ON','OFF','ON Time-hist. Fit','OFF Time-hist. Fit','Location','northeast');
    l.Interpreter='latex';
    l.FontSize=10;
    grid(handles.meanOnOffTimeAxes,'on');
    set(handles.meanOnOffTimeAxes,'visible','on');
else
    A = get(handles.meanOnOffTimeAxes,'children'); %Contains all data on offPercentageAxes
    set(A,'visible','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on slider movement.
function blinkingDotSlider_Callback(hObject, eventdata, handles)
% hObject    handle to blinkingDotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(hObject,'Min',1);
blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);
set(hObject,'Max',nBlinkingDots);
step=1/(nBlinkingDots-1);
set(hObject,'SliderStep',[step step]);
guidata(hObject, handles);

%disp('Updating current dot number') % debug
handles.currentDotNumber = blinkingDots(round(get(hObject,'Value')));
dotNumber=handles.currentDotNumber;
%disp(strcat('Current dot: ',num2str(handles.currentDotNumber))); %debug

% Update handles structure
guidata(hObject, handles);

% --- Displays current dot
set(handles.minValueText,'String',num2str(handles.minIntensityTraceAxes(dotNumber)));
set(handles.maxValueText,'String',num2str(handles.maxIntensityTraceAxes(dotNumber)));
set(handles.numberOfBinsText,'String',num2str(handles.nBins(dotNumber)));
set(handles.minOnTimeHistText,'String',num2str(handles.minOnTimeHistogramAxes(dotNumber)));
set(handles.maxOnTimeHistText,'String',num2str(handles.maxOnTimeHistogramAxes(dotNumber)));
set(handles.minOffTimeHistText,'String',num2str(handles.minOffTimeHistogramAxes(dotNumber)));
set(handles.maxOffTimeHistText,'String',num2str(handles.maxOffTimeHistogramAxes(dotNumber)));
set(handles.binWidthOnTimeHistText,'String',num2str(handles.binWidthOnTimeHist(dotNumber)));
set(handles.binWidthOffTimeHistText,'String',num2str(handles.binWidthOffTimeHist(dotNumber)));
set(handles.minOnTimeHistFitText,'String',num2str(handles.minOnTimeHistFit(dotNumber)));
set(handles.maxOnTimeHistFitText,'String',num2str(handles.maxOnTimeHistFit(dotNumber)));
set(handles.minOffTimeHistFitText,'String',num2str(handles.minOffTimeHistFit(dotNumber)));
set(handles.maxOffTimeHistFitText,'String',num2str(handles.maxOffTimeHistFit(dotNumber)));
handles.currentMinIntensity=handles.minIntensityTraceAxes(dotNumber); %user-input min intensity
handles.currentMaxIntensity=handles.maxIntensityTraceAxes(dotNumber); %user-input max intensity
handles.currentNbins=handles.nBins(dotNumber);
handles.currentMinOnTimeHistogram=handles.minOnTimeHistogramAxes(dotNumber); %user-input min On time histogram
handles.currentMaxOnTimeHistogram=handles.maxOnTimeHistogramAxes(dotNumber); %user-input max On time histogram
handles.currentMinOffTimeHistogram=handles.minOffTimeHistogramAxes(dotNumber); %user-input min Off time histogram
handles.currentMaxOffTimeHistogram=handles.maxOffTimeHistogramAxes(dotNumber); %user-input max Off time histogram
handles.currentBinWidthOnTimeHist=handles.binWidthOnTimeHist(dotNumber);
handles.currentBinWidthOffTimeHist=handles.binWidthOffTimeHist(dotNumber);
handles.currentMinOnTimeHistFit=handles.minOnTimeHistFit(dotNumber); %user-input min On time hist. linear fit
handles.currentMaxOnTimeHistFit=handles.maxOnTimeHistFit(dotNumber); %user-input max On time hist. linear fit
handles.currentMinOffTimeHistFit=handles.minOffTimeHistFit(dotNumber); %user-input min Off time hist. linear fit
handles.currentMaxOffTimeHistFit=handles.maxOffTimeHistFit(dotNumber); %user-input max Off time hist. linear fit


plotIntensityTrace(hObject, eventdata, handles);

plotIntensityHistogram(hObject, eventdata, handles);

plotFittingCurves(hObject, eventdata, handles);

displayThresholds(hObject, eventdata, handles);

displayOnOffTimesResults(hObject, eventdata, handles);

plotOnPercentage(hObject, eventdata, handles);
plotMeanTimes(hObject, eventdata, handles);

plotOnTimeHistogram(hObject, eventdata, handles);
plotOffTimeHistogram(hObject, eventdata, handles);

displayOnOffTimeHistFitResults(hObject, eventdata, handles);

plotOnTimeHistFitLine(hObject, eventdata, handles);
plotOffTimeHistFitLine(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% disp('End of slider callback...') % debug


% --- Executes during object creation, after setting all properties.
function blinkingDotSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blinkingDotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set object properties
set(hObject,'Value',1);
set(hObject,'Min',1);
blinkingDots=find(handles.isBlinking);
nBlinkingDots=size(blinkingDots,2);
set(hObject,'Max',nBlinkingDots);
step=1/(nBlinkingDots-1);
set(hObject,'SliderStep',[step step]);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function onTimeHistogramAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onTimeHistogramAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate onTimeHistogramAxes


% --- Plot the histogram of ON times
function plotOnTimeHistogram(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('Plotting histogram of ON times...'); % debug
if handles.isBlinking(handles.currentDotNumber)
    % Retrieve OFF time histogram data
    centers=handles.onTimeHistBinCenters(:,handles.currentDotNumber);
    N=handles.onTimeHistOccurence(:,handles.currentDotNumber);
    cla(handles.onTimeHistogramAxes);
    plot(handles.onTimeHistogramAxes,centers,log10(N),'LineStyle','none',...
        'Marker','.','MarkerSize',16,'MarkerEdgeColor','black',...
        'MarkerFaceColor','black');
    xlabel(handles.onTimeHistogramAxes,'ON time (s)','FontSize',12);
    hy=ylabel(handles.onTimeHistogramAxes,'$$\log_{10}(N)$$','FontSize',12,'Interpreter','latex');
    l=legend(handles.onTimeHistogramAxes,'blinking data','Location','northeast');
    grid(handles.onTimeHistogramAxes,'on');
    set(handles.onTimeHistogramAxes,'visible','on');
else
    A = get(handles.onTimeHistogramAxes,'children'); %Contains all data on onTimeHistogramAxes
    set(A,'visible','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Plot the histogram of ON times
function plotOffTimeHistogram(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('Plotting histogram of OFF times...'); % debug
if handles.isBlinking(handles.currentDotNumber)
    % Retrieve OFF time histogram data
    centers=handles.offTimeHistBinCenters(:,handles.currentDotNumber);
    N=handles.offTimeHistOccurence(:,handles.currentDotNumber);
    plot(handles.offTimeHistogramAxes,centers,log10(N),'LineStyle','none',...
        'Marker','.','MarkerSize',16,'MarkerEdgeColor','black',...
        'MarkerFaceColor','black');
    xlabel(handles.offTimeHistogramAxes,'OFF time (s)','FontSize',12);
    hy=ylabel(handles.offTimeHistogramAxes,'$$\log_{10}(N)$$','FontSize',12,'Interpreter','latex');
    l=legend(handles.offTimeHistogramAxes,'blinking data','Location','northeast');
    grid(handles.offTimeHistogramAxes,'on');
else
    A = get(handles.offTimeHistogramAxes,'children'); %Contains all data on onTimeHistogramAxes
    set(A,'visible','off');
end

% Update handles structure
guidata(hObject, handles);



function onLifetimeText_Callback(hObject, eventdata, handles)
% hObject    handle to onLifetimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onLifetimeText as text
%        str2double(get(hObject,'String')) returns contents of onLifetimeText as a double

if handles.isBlinking(handles.currentDotNumber)
    precision=3;
    stddevStr=num2str(handles.onLifetimeStddev(handles.currentDotNumber),precision);
    precision=3;
    muStr=num2str(handles.onLifetimeValue(handles.currentDotNumber),precision);
    str=[muStr ' ' '(' stddevStr ')'];
    set(handles.onLifetimeText,'string',str);
    set(handles.onLifetimeText,'Visible','on');
else
    set(handles.onLifetimeText,'Visible','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function onLifetimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onLifetimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offLifetimeText_Callback(hObject, eventdata, handles)
% hObject    handle to offLifetimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offLifetimeText as text
%        str2double(get(hObject,'String')) returns contents of offLifetimeText as a double

if handles.isBlinking(handles.currentDotNumber)
    precision=3;
    stddevStr=num2str(handles.offLifetimeStddev(handles.currentDotNumber),precision);
    precision=3;
    muStr=num2str(handles.offLifetimeValue(handles.currentDotNumber),precision);
    str=[muStr ' ' '(' stddevStr ')'];
    set(handles.offLifetimeText,'string',str);
    set(handles.offLifetimeText,'Visible','on');
else
    set(handles.offLifetimeText,'Visible','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function offLifetimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offLifetimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minOnTimeHistText_Callback(hObject, eventdata, handles)
% hObject    handle to minOnTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minOnTimeHistText as text
%        str2double(get(hObject,'String')) returns contents of minOnTimeHistText as a double

% Read the user-input min on time histogram value of the current dot
handles.currentMinOnTimeHistogram=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minOnTimeHistText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minOnTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxOnTimeHistText_Callback(hObject, eventdata, handles)
% hObject    handle to maxOnTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxOnTimeHistText as text
%        str2double(get(hObject,'String')) returns contents of maxOnTimeHistText as a double

% Read the user-input max on time histogram value of the current dot
handles.currentMaxOnTimeHistogram=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxOnTimeHistText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxOnTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateOnTimeHistogramButton.
function updateOnTimeHistogramButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateOnTimeHistogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp('Update on-time histogram button pressed...'); %debug

% Updates on time histogram plot
handles.minOnTimeHistogramAxes(handles.currentDotNumber)=handles.currentMinOnTimeHistogram;
handles.maxOnTimeHistogramAxes(handles.currentDotNumber)=handles.currentMaxOnTimeHistogram;
handles.binWidthOnTimeHist(handles.currentDotNumber)=handles.currentBinWidthOnTimeHist;

% Update handles structure
guidata(hObject, handles);

% Re-calculate ON time histogram
calculateOnTimeHistogram(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

plotOnTimeHistogram(hObject, eventdata, handles);

fitOnTimeHistogram(hObject, eventdata,handles, handles.currentDotNumber);
% Retrieves new handles
handles = guidata(hObject);

% Calculates ON/OFF duty cycle from time histograms fitting results
calculateDutyCycleStats(hObject, eventdata, handles, handles.currentDotNumber);

% Displays On/Off-time fitting results
displayOnOffTimeHistFitResults(hObject, eventdata, handles);

% Plots ON-time histogram fitting line
plotOnTimeHistFitLine(hObject, eventdata, handles);

% Plots updated mean times and ON percentage
plotMeanTimes(hObject, eventdata, handles);
plotOnPercentage(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in updateOffTimeHistogramButton.
function updateOffTimeHistogramButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateOffTimeHistogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp('Update off-time histogram button pressed...'); %debug

% Updates off time histogram plot
handles.minOffTimeHistogramAxes(handles.currentDotNumber)=handles.currentMinOffTimeHistogram;
handles.maxOffTimeHistogramAxes(handles.currentDotNumber)=handles.currentMaxOffTimeHistogram;
handles.binWidthOffTimeHist(handles.currentDotNumber)=handles.currentBinWidthOffTimeHist;

% Update handles structure
guidata(hObject, handles);

% Re-calculate OFF time histogram
calculateOffTimeHistogram(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

plotOffTimeHistogram(hObject, eventdata, handles);

fitOffTimeHistogram(hObject, eventdata,handles, handles.currentDotNumber);
% Retrieves new handles
handles = guidata(hObject);

% Calculates ON/OFF duty cycle from time histograms fitting results
calculateDutyCycleStats(hObject, eventdata, handles, handles.currentDotNumber);

% Displays On/Off-time fitting results
displayOnOffTimeHistFitResults(hObject, eventdata, handles);

% Plots Off-time histogram fitting line
plotOffTimeHistFitLine(hObject, eventdata, handles);

% Plots updated mean times and ON percentage
plotMeanTimes(hObject, eventdata, handles);
plotOnPercentage(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);



function minOffTimeHistText_Callback(hObject, eventdata, handles)
% hObject    handle to minOffTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minOffTimeHistText as text
%        str2double(get(hObject,'String')) returns contents of minOffTimeHistText as a double

% Read the user-input min off time histogram value of the current dot
handles.currentMinOffTimeHistogram=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function minOffTimeHistText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minOffTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxOffTimeHistText_Callback(hObject, eventdata, handles)
% hObject    handle to maxOffTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxOffTimeHistText as text
%        str2double(get(hObject,'String')) returns contents of maxOffTimeHistText as a double

% Read the user-input max off time histogram value of the current dot
handles.currentMaxOffTimeHistogram=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxOffTimeHistText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxOffTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxOnTimeHistFitText_Callback(hObject, eventdata, handles)
% hObject    handle to maxOnTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxOnTimeHistFitText as text
%        str2double(get(hObject,'String')) returns contents of maxOnTimeHistFitText as a double

% Read the user-input max on time histogram fit value of the current dot
handles.currentMaxOnTimeHistFit=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxOnTimeHistFitText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxOnTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minOnTimeHistFitText_Callback(hObject, eventdata, handles)
% hObject    handle to minOnTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minOnTimeHistFitText as text
%        str2double(get(hObject,'String')) returns contents of minOnTimeHistFitText as a double

% Read the user-input min on time histogram fit value of the current dot
handles.currentMinOnTimeHistFit=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minOnTimeHistFitText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minOnTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function binWidthOnTimeHistText_Callback(hObject, eventdata, handles)
% hObject    handle to binWidthOnTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binWidthOnTimeHistText as text
%        str2double(get(hObject,'String')) returns contents of binWidthOnTimeHistText as a double

% Read the user-input bin width on time histogram fit value of the current dot
handles.currentBinWidthOnTimeHist=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function binWidthOnTimeHistText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binWidthOnTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitOnTimeHistogramButton.
function fitOnTimeHistogramButton_Callback(hObject, eventdata, handles)
% hObject    handle to fitOnTimeHistogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.maxOnTimeHistFit(handles.currentDotNumber)=handles.currentMaxOnTimeHistFit;
handles.minOnTimeHistFit(handles.currentDotNumber)=handles.currentMinOnTimeHistFit;

% Update handles structure
guidata(hObject, handles);

fitOnTimeHistogram(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

calculateDutyCycleStats(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Display updated results
displayOnOffTimeHistFitResults(hObject, eventdata, handles);

% Plot On-time histogram
plotOnTimeHistogram(hObject, eventdata, handles);

% Plot fitting line
plotOnTimeHistFitLine(hObject, eventdata, handles);

% Plots updated mean times and ON percentage
plotMeanTimes(hObject, eventdata, handles);
plotOnPercentage(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


function maxOffTimeHistFitText_Callback(hObject, eventdata, handles)
% hObject    handle to maxOffTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxOffTimeHistFitText as text
%        str2double(get(hObject,'String')) returns contents of maxOffTimeHistFitText as a double

% Read the user-input max off time histogram fit value of the current dot
handles.currentMaxOffTimeHistFit=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxOffTimeHistFitText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxOffTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function minOffTimeHistFitText_Callback(hObject, eventdata, handles)
% hObject    handle to minOffTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minOffTimeHistFitText as text
%        str2double(get(hObject,'String')) returns contents of minOffTimeHistFitText as a double

% Read the user-input min off time histogram fit value of the current dot
handles.currentMinOffTimeHistFit=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minOffTimeHistFitText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minOffTimeHistFitText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function binWidthOffTimeHistText_Callback(hObject, eventdata, handles)
% hObject    handle to binWidthOffTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binWidthOffTimeHistText as text
%        str2double(get(hObject,'String')) returns contents of binWidthOffTimeHistText as a double

% Read the user-input bin width off time histogram fit value of the current dot
handles.currentBinWidthOffTimeHist=str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function binWidthOffTimeHistText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binWidthOffTimeHistText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitOffTimeHistogramButton.
function fitOffTimeHistogramButton_Callback(hObject, eventdata, handles)
% hObject    handle to fitOffTimeHistogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.maxOffTimeHistFit(handles.currentDotNumber)=handles.currentMaxOffTimeHistFit;
handles.minOffTimeHistFit(handles.currentDotNumber)=handles.currentMinOffTimeHistFit;

% Update handles structure
guidata(hObject, handles);

fitOffTimeHistogram(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

calculateDutyCycleStats(hObject, eventdata, handles, handles.currentDotNumber);

% Retrieves new handles
handles = guidata(hObject);

% Display updated results
displayOnOffTimeHistFitResults(hObject, eventdata, handles);

% Plot Off-time histogram
plotOffTimeHistogram(hObject, eventdata, handles);

% Plot fitting line
plotOffTimeHistFitLine(hObject, eventdata, handles);

% Plots updated mean times and ON percentage
plotMeanTimes(hObject, eventdata, handles);
plotOnPercentage(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);


function onDutyCycleText_Callback(hObject, eventdata, handles)
% hObject    handle to onDutyCycleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onDutyCycleText as text
%        str2double(get(hObject,'String')) returns contents of onDutyCycleText as a double

if handles.isBlinking(handles.currentDotNumber)
    precision=3;
    muStr=num2str(handles.onDutyCycleStatsValue(handles.currentDotNumber),precision);
    stddevStr=num2str(handles.onDutyCycleStatsStddev(handles.currentDotNumber),precision);
    str=[muStr ' ' '(' stddevStr ')'];
    set(handles.onDutyCycleText,'string',str);
    set(handles.onDutyCycleText,'Visible','on');
else
    set(handles.onDutyCycleText,'Visible','off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function onDutyCycleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onDutyCycleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offDutyCycleText_Callback(hObject, eventdata, handles)
% hObject    handle to offDutyCycleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offDutyCycleText as text
%        str2double(get(hObject,'String')) returns contents of offDutyCycleText as a double

if handles.isBlinking(handles.currentDotNumber)
    precision=3;
    muStr=num2str(handles.offDutyCycleStatsValue(handles.currentDotNumber),precision);
    stddevStr=num2str(handles.offDutyCycleStatsStddev(handles.currentDotNumber),precision);
    str=[muStr ' ' '(' stddevStr ')'];
    set(handles.offDutyCycleText,'string',str);
    set(handles.offDutyCycleText,'Visible','on');
else
    set(handles.offDutyCycleText,'Visible','off');
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function offDutyCycleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offDutyCycleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fitOnTimeHistogram(hObject, eventdata, handles, dotNumber)
% hObject    handle to
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%disp('Fitting histogram of ON times...'); % debug
if handles.isBlinking(dotNumber)

    % Gets the current ON time histogram data
    N=handles.onTimeHistOccurence(:,dotNumber);
    centers=handles.onTimeHistBinCenters(:,dotNumber);

    % Current ON time histogram data between selected min and max for
    % fitting

    minX=max([handles.minOnTimeHistFit(dotNumber) handles.minOnTimeHistogramAxes(dotNumber)]);
    maxX=min([handles.maxOnTimeHistFit(dotNumber) handles.maxOnTimeHistogramAxes(dotNumber)]);

    handles.minOnTimeHistFit(dotNumber)=minX;
    handles.maxOnTimeHistFit(dotNumber)=maxX;

    [row,~]=find(centers>=minX & centers<=maxX);

    % Remove Inf and NaN values as required for fitting
    yDataTemp=log10(N(row));
    idx=find(~isinf(yDataTemp) & ~isnan(yDataTemp));
    yData=yDataTemp(idx);
    xDataTemp=centers(row);
    xData=xDataTemp(idx);

    %disp(['Fitting On-time hist. of dot ' num2str(dotNumber)]);

    % Fits the data
    warning('off');
    curveFitted=true;
    try
        % Fits the data
        [fitObject,gof] = fit(xData,yData,'poly1');
    catch
        curveFitted=false;
        str=['Error: the ON-time histogram of dot ' num2str(dotNumber) ' could not be fitted with a straight line'];
        disp(str);
    end
    warning('on');

    if curveFitted
        % Sorts output results
        p1=fitObject.p1;
        p2=fitObject.p2;
        handles.onTimeHistFitP1(dotNumber)=p1;
        handles.onTimeHistFitP2(dotNumber)=p2;
        handles.onTimeHistFitAdjrsquare(dotNumber)=gof.adjrsquare; % adjusted r square
        level=0.68; % confidence level
        confintCalculated=true;

        try
            ci = confint(fitObject,level); % confidence interval
        catch
            confintCalculated=false;
            str=['Error: the confidence intervals of ON-time histogram fit of dot ' num2str(dotNumber) ' could not be calculated.'];
            disp(str);
            handles.onLifetimeValue(dotNumber)=NaN;
            handles.onLifetimeStddev(dotNumber)=NaN;
        end

        if confintCalculated
            onLifetimeValue=-log10(exp(1))/p1; % ON lifetime value [s]
            onLifetimeStddev=abs((ci(1,1)-ci(2,1))*log10(exp(1)))/(2*p1^2); % ON lifetime stddev [s]
            handles.onLifetimeValue(dotNumber)=onLifetimeValue;
            handles.onLifetimeStddev(dotNumber)=onLifetimeStddev;
        end
    end
end

% Update handles structure
guidata(hObject, handles);


function fitOffTimeHistogram(hObject, eventdata, handles, dotNumber)
% hObject    handle to
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%disp('Fitting histogram of OFF times...'); % debug
if handles.isBlinking(dotNumber)

    % Gets the current OFF time histogram data
    N=handles.offTimeHistOccurence(:,dotNumber);
    centers=handles.offTimeHistBinCenters(:,dotNumber);

    % Current ON time histogram data between selected min and max for
    % fitting
    minX=max([handles.minOffTimeHistFit(dotNumber) handles.minOffTimeHistogramAxes(dotNumber)]);
    maxX=min([handles.maxOffTimeHistFit(dotNumber) handles.maxOffTimeHistogramAxes(dotNumber)]);

    handles.minOffTimeHistFit(dotNumber)=minX;
    handles.maxOffTimeHistFit(dotNumber)=maxX;

    [row,~]=find(centers>=minX & centers<=maxX);

    % Remove Inf and NaN values as required for fitting
    yDataTemp=log10(N(row));
    idx=find(~isinf(yDataTemp) & ~isnan(yDataTemp));
    yData=yDataTemp(idx);
    xDataTemp=centers(row);
    xData=xDataTemp(idx);

    % Fits the data
    warning('off');
    curveFitted=true;
    try
        % Fits the data
        [fitObject,gof] = fit(xData,yData,'poly1');
    catch
        curveFitted=false;
        str=['Error: the OFF-time histogram of dot ' num2str(dotNumber) ' could not be fitted with a straight line'];
        disp(str);
    end
    warning('on');

    if curveFitted
        % Sorts output results
        p1=fitObject.p1;
        p2=fitObject.p2;
        handles.offTimeHistFitP1(dotNumber)=p1;
        handles.offTimeHistFitP2(dotNumber)=p2;
        handles.offTimeHistFitAdjrsquare(dotNumber)=gof.adjrsquare; % adjusted r square
        level=0.68; % confidence level
        confintCalculated=true;

        try
            ci = confint(fitObject,level); % confidence interval
        catch
            confintCalculated=false;
            str=['Error: the confidence intervals of OFF-time histogram fit of dot ' num2str(dotNumber) ' could not be calculated.'];
            disp(str);
            handles.offLifetimeValue(dotNumber)=NaN;
            handles.offLifetimeStddev(dotNumber)=NaN;
        end

        if confintCalculated
            offLifetimeValue=-log10(exp(1))/p1; % OFF lifetime value [s]
            offLifetimeStddev=abs((ci(1,1)-ci(2,1))*log10(exp(1)))/(2*p1^2); % OFF lifetime stddev [s]
            handles.offLifetimeValue(dotNumber)=offLifetimeValue;
            handles.offLifetimeStddev(dotNumber)=offLifetimeStddev;
        end
    end

end

% Update handles structure
guidata(hObject, handles);


function [N,centers]=calculateOnTimeHistogram(hObject, eventdata, handles, dotNumber)
% hObject    handle to
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%disp('Calculating histogram of ON times...'); % debug
if handles.isBlinking(dotNumber)
    minOnTime=handles.minOnTimeHistogramAxes(dotNumber);
    maxOnTime=handles.maxOnTimeHistogramAxes(dotNumber);
    binWidth=handles.binWidthOnTimeHist(dotNumber);
    edges=minOnTime:binWidth:maxOnTime;
    centers=((minOnTime+binWidth/2):binWidth:(maxOnTime-binWidth/2))';
    histogramCalculated=true;

    try
        [N,edges]=histcounts(handles.onTimes(:,dotNumber),edges);
    catch
        histogramCalculated=false;
        str=strcat('Error: the ON-time histogram of dot ',num2str(dotNumber),' could not be calculated.');
        disp(str);
        handles.onTimeHistOccurence(handles.maxNpointsTimeHist,dotNumber)=NaN;
        handles.onTimeHistBinCenters(handles.maxNpointsTimeHist,dotNumber)=NaN;
    end

    if histogramCalculated
        centers=[centers; NaN*ones((handles.maxNpointsTimeHist-size(centers,1)),1)];
        N=[N'; NaN*ones((handles.maxNpointsTimeHist-size(N',1)),1)];
        handles.onTimeHistOccurence(1:size(N,1),dotNumber)=N;
        handles.onTimeHistBinCenters(1:size(N,1),dotNumber)=centers;
    end

end

% Update handles structure
guidata(hObject, handles);

function [N,centers]=calculateOffTimeHistogram(hObject, eventdata, handles, dotNumber)
% hObject    handle to
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%disp('Calculating histogram of OFF times...'); % debug
if handles.isBlinking(dotNumber)
    minOffTime=handles.minOffTimeHistogramAxes(dotNumber);
    maxOffTime=handles.maxOffTimeHistogramAxes(dotNumber);
    binWidth=handles.binWidthOffTimeHist(dotNumber);
    edges=minOffTime:binWidth:maxOffTime;
    centers=((minOffTime+binWidth/2):binWidth:(maxOffTime-binWidth/2))';
    histogramCalculated=true;

    try
        [N,edges]=histcounts(handles.offTimes(:,dotNumber),edges);
    catch
        histogramCalculated=false;
        str=strcat('Error: the OFF-time histogram of dot ',num2str(dotNumber),' could not be calculated.');
        disp(str);
        handles.offTimeHistOccurence(handles.maxNpointsTimeHist,dotNumber)=NaN;
        handles.offTimeHistBinCenters(handles.maxNpointsTimeHist,dotNumber)=NaN;
    end

    if histogramCalculated
        centers=[centers; NaN*ones((handles.maxNpointsTimeHist-size(centers,1)),1)];
        N=[N'; NaN*ones((handles.maxNpointsTimeHist-size(N',1)),1)];
        handles.offTimeHistOccurence(1:size(N,1),dotNumber)=N;
        handles.offTimeHistBinCenters(1:size(N,1),dotNumber)=centers;
    end

end

% Update handles structure
guidata(hObject, handles);


% --- Plot ON-time histogram fitting line
function plotOnTimeHistFitLine(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('Plotting ON-time histogram fitting line...'); % debug

% Plot the fitted curves

if handles.isBlinking(handles.currentDotNumber)
      % On-time x vector for fitting line
      x = [handles.minOnTimeHistFit(handles.currentDotNumber),handles.maxOnTimeHistFit(handles.currentDotNumber)];
      % Retrieve p1 and p2 defined as: y = p1*x+p2
      p1=handles.onTimeHistFitP1(handles.currentDotNumber)*ones(size(x));
      p2=handles.onTimeHistFitP2(handles.currentDotNumber)*ones(size(x));
      adjRsquare=handles.onTimeHistFitAdjrsquare(handles.currentDotNumber);
      y=p1.*x+p2;
      hold(handles.onTimeHistogramAxes,'on');
      plot(handles.onTimeHistogramAxes,x,y,'LineWidth',1,'LineStyle','-','Color','r');
      coeff=1.1;
      minX=coeff*handles.minOnTimeHistogramAxes(handles.currentDotNumber);
      maxX=coeff*handles.maxOnTimeHistogramAxes(handles.currentDotNumber);
      xlim(handles.onTimeHistogramAxes,[minX maxX]);
      [row,col]=find(handles.onTimeHistOccurence(:,handles.currentDotNumber));
      minY=coeff*log10(min(handles.onTimeHistOccurence(row,handles.currentDotNumber)));
      maxY=coeff*log10(max(handles.onTimeHistOccurence(:,handles.currentDotNumber)));
      % maxY 1 in case both minY and maxY are 0
      if (maxY==0 && minY==0)
          maxY=1;
      end
      ylim(handles.onTimeHistogramAxes,[minY maxY]);
      l=legend(handles.onTimeHistogramAxes,'blinking data','Linear Fit','Location','best');
      l.FontSize=10;
      l.Interpreter='latex';
      coeffX=0.6;
      coeffY=0.7;
      tX=coeffX*(maxX-minX)+minX;
      tY=coeffY*(maxY-minY)+minY;
      str=['$$R_{adj}^2=$$ ' num2str(adjRsquare)];
      t=text(handles.onTimeHistogramAxes,tX,tY,str);
      t.FontSize=12;
      t.Interpreter='latex';
      grid(handles.onTimeHistogramAxes,'on');
      hold(handles.onTimeHistogramAxes,'off');
end


% Update handles structure
guidata(hObject, handles);

% --- Plots OFF-time histogram fitting line
function plotOffTimeHistFitLine(hObject, eventdata, handles)
% hObject    handle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('Plotting ON-time histogram fitting line...'); % debug

% Plot the fitted curves

if handles.isBlinking(handles.currentDotNumber)
      % OFF-time x vector for fitting line
      x = [handles.minOffTimeHistFit(handles.currentDotNumber),handles.maxOffTimeHistFit(handles.currentDotNumber)];
      % Retrieve p1 and p2 defined as: y = p1*x+p2
      p1=handles.offTimeHistFitP1(handles.currentDotNumber)*ones(size(x));
      p2=handles.offTimeHistFitP2(handles.currentDotNumber)*ones(size(x));
      adjRsquare=handles.offTimeHistFitAdjrsquare(handles.currentDotNumber);
      y=p1.*x+p2;
      hold(handles.offTimeHistogramAxes,'on');
      plot(handles.offTimeHistogramAxes,x,y,'LineWidth',1,'LineStyle','-','Color','r');
      coeff=1.1;
      minX=coeff*handles.minOffTimeHistogramAxes(handles.currentDotNumber);
      maxX=coeff*handles.maxOffTimeHistogramAxes(handles.currentDotNumber);
      xlim(handles.offTimeHistogramAxes,[minX maxX]);
      [row,col]=find(handles.offTimeHistOccurence(:,handles.currentDotNumber));
      minY=coeff*log10(min(handles.offTimeHistOccurence(row,handles.currentDotNumber)));
      maxY=coeff*log10(max(handles.offTimeHistOccurence(:,handles.currentDotNumber)));
      % maxY 1 in case both minY and maxY are 0
      if (maxY==0 && minY==0)
          maxY=1;
      end
      ylim(handles.offTimeHistogramAxes,[minY maxY]);
      l=legend(handles.offTimeHistogramAxes,'blinking data','Linear Fit','Location','best');
      l.FontSize=10;
      l.Interpreter='latex';
      coeffX=0.6;
      coeffY=0.7;
      tX=coeffX*(maxX-minX)+minX;
      tY=coeffY*(maxY-minY)+minY;
      str=['$$R_{adj}^2=$$ ' num2str(adjRsquare)];
      t=text(handles.offTimeHistogramAxes,tX,tY,str);
      t.FontSize=12;
      t.Interpreter='latex';
      grid(handles.offTimeHistogramAxes,'on');
      hold(handles.offTimeHistogramAxes,'off');
end

% Update handles structure
guidata(hObject, handles);

% Calculates ON/OFF duty cycle from time histograms fitting results
function calculateDutyCycleStats(hObject, eventdata, handles, dotNumber)

% Retrieve data
tauOn=handles.onLifetimeValue(dotNumber);
uTauOn=handles.onLifetimeStddev(dotNumber);
tauOff=handles.offLifetimeValue(dotNumber);
uTauOff=handles.offLifetimeStddev(dotNumber);

% Duty Cycle ON
handles.onDutyCycleStatsValue(dotNumber)=100*tauOn/(tauOn+tauOff);
handles.onDutyCycleStatsStddev(dotNumber)=100*sqrt(uTauOn^2*(tauOff/(tauOn+tauOff)^2)^2+...
    uTauOff^2*(tauOn/(tauOn+tauOff)^2)^2);

% Duty Cycle OFF
handles.offDutyCycleStatsValue(dotNumber)=100*tauOff/(tauOn+tauOff);
handles.offDutyCycleStatsStddev(dotNumber)=100*sqrt(uTauOn^2*(tauOff/(tauOn+tauOff)^2)^2+...
    uTauOff^2*(tauOn/(tauOn+tauOff)^2)^2);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
% hObject    handle to quitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all;
