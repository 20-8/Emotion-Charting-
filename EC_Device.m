function varargout = EC_Device(varargin)
% EC_DEVICE MATLAB code for EC_Device.fig
%      EC_DEVICE, by itself, creates a new EC_DEVICE or raises the existing
%      singleton*.
%
%      H = EC_DEVICE returns the handle to a new EC_DEVICE or the handle to
%      the existing singleton*.
%
%      EC_DEVICE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EC_DEVICE.M with the given input arguments.
%
%      EC_DEVICE('Property','Value',...) creates a new EC_DEVICE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EC_Device_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EC_Device_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EC_Device

% Last Modified by GUIDE v2.5 08-Jul-2019 21:50:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EC_Device_OpeningFcn, ...
                   'gui_OutputFcn',  @EC_Device_OutputFcn, ...
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


% --- Executes just before EC_Device is made visible.
function EC_Device_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EC_Device (see VARARGIN)

% Choose default command line output for EC_Device
handles.output = hObject;
set(handles.axes1,'xtick',[],'ytick',[])
set(handles.axes2,'xtick',[],'ytick',[])
set(handles.axes3,'visible', 'off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EC_Device wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EC_Device_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
clcvarargout{1} = handles.output;

clear
% --- Executes when figure1 is resized.clc

function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %% definitions

    %GSR
    
    shimmer_GSR = ShimmerHandleClass('3');
    
    %ECG
    
    shimmer_ECG = ShimmerHandleClass('7');
    SensorMacros = SetEnabledSensorsMacrosClass;                               % assign user friendly macros for setenabledsensors

    fs_GSR = 128;                                                                  % sample rate in [Hz]
    fs_ECG=256;
    firsttime = true;
    captureDuration=150;

    % Note: these constants are only relevant to this examplescript and are not used
    % by the ShimmerHandle Class
    NO_SAMPLES_IN_PLOT = 5000;                                                 % Number of samples in the plot 
    DELAY_PERIOD = 0.2;                                                        % Delay (in seconds) between data read operations
    numSamples = 0;
    numSamples_ECG = 0;

    %% settings

    % filtering settings
                                                                     
                                                                    
    nPoles = 4;                                                                % number of poles (HPF, LPF)
    pbRipple = 0.5;                                                            % pass band ripple (%)
    
                                                                   % enable (true) or disable (false) highpass filter
    LPF = true;                                                                % enable (true) or disable (false) lowpass filter
                                                                % enable (true) or disable (false) bandstop filter
    
    
   
    % lowpass filters for ExG channels
    if (LPF)
        lpfgsr1ch1 = FilterClass(FilterClass.LPF,fs_GSR,fs_GSR/2-1,nPoles,pbRipple);
        
    end
    
    %ECG LPF
     % lowpass filters for ExG channels
    if (LPF)
        lpfexg1ch1a = FilterClass(FilterClass.LPF,fs_ECG,fs_ECG/2-1,nPoles,pbRipple);
        lpfexg1ch2a = FilterClass(FilterClass.LPF,fs_ECG,fs_ECG/2-1,nPoles,pbRipple);
        lpfexg2ch1b = FilterClass(FilterClass.LPF,fs_ECG,fs_ECG/2-1,nPoles,pbRipple);
        lpfexg2ch2b = FilterClass(FilterClass.LPF,fs_ECG,fs_ECG/2-1,nPoles,pbRipple);
    end
    

    
    %%
    if ((shimmer_GSR.connect)&(shimmer_ECG.connect))
        shimmer_GSR.setsamplingrate(fs_GSR);                                       % Select sampling rate
        shimmer_GSR.setinternalboard('GSR');                                       % Select internal expansion board; select 'ECG' to enable both SENSOR_EXG1 and SENSOR_EXG2 
        shimmer_GSR.disableallsensors;                                             % Disable other sensors
        shimmer_GSR.setenabledsensors(SensorMacros.GSR,1)                          % Enable SENSOR
        
        
        shimmer_ECG.setsamplingrate(fs_ECG);                                       % Select sampling rate
        shimmer_ECG.setinternalboard('ECG');                                       % Select internal expansion board; select 'ECG' to enable both SENSOR_EXG1 and SENSOR_EXG2 
        shimmer_ECG.disableallsensors;                                             % Disable other sensors
        shimmer_ECG.setenabledsensors(SensorMacros.ECG,1)                          % Enable SENSOR

       
        if ((shimmer_GSR.start)&(shimmer_ECG.start))                                                     % TRUE if the shimmer starts streaming 

            plotData_GSR = [];                                               
            timeStamp_GSR = [];
            filteredplotData_GSR = [];
            
             plotData_ECG = [];                                               
            timeStamp_ECG = [];
            filteredplotData_ECG = [];

%             h.figure1=figure('Name','Shimmer GSR signals');                    % Create a handle to figure for plotting data from shimmer
%             set(h.figure1, 'Position', [100, 500, 800, 400]);
           
            elapsedTime = 0;                                                   % Reset to 0    
            tic;                                                               % Start timer

            while (elapsedTime < captureDuration)       

                pause(DELAY_PERIOD);                                           % Pause for this period of time on each iteration to allow data to arrive in the buffer

                [newData,signalNameArray,signalFormatArray,signalUnitArray] = shimmer_GSR.getdata('c');   % Read the latest data from shimmer data buffer, signalFormatArray defines the format of the data and signalUnitArray the unit
                
                %ECG
                
                [newData_ECG,signalNameArray_ECG,signalFormatArray_ECG,signalUnitArray_ECG] = shimmer_ECG.getdata('c');   % Read the latest data from shimmer data buffer, signalFormatArray defines the format of the data and signalUnitArray the unit

                
%                 if (firsttime==true && isempty(newData)~=1)
%                     firsttime = writeHeadersToFile(fileName,signalNameArray,signalFormatArray,signalUnitArray);
%                 end

                if ((~isempty(newData))& (~isempty(newData_ECG)))                                         % TRUE if new data has arrived
                    
                    chIndex(1) = find(ismember(signalNameArray, 'GSR'));
                    chIndex_ECG(1) = find(ismember(signalNameArray_ECG, 'ECG LL-RA'));
                    chIndex_ECG(2) = find(ismember(signalNameArray_ECG, 'ECG LA-RA'));
                    chIndex_ECG(3) = find(ismember(signalNameArray_ECG, 'ECG Vx-RL'));
                    chIndex_ECG(4) = find(ismember(signalNameArray_ECG, 'ECG RESP'));
                    
                    GSRData = newData(:,chIndex);
                    GSRDataFiltered = GSRData;
                    
                    ECGData = newData_ECG(:,chIndex_ECG);
                    ECGDataFiltered = ECGData;
                    % filter the data
                    
                    
                    
                    if LPF % h lowpassfilter to avoid aliasing
                        GSRDataFiltered(:,1) = lpfgsr1ch1.filterData(GSRDataFiltered(:,1));
                        
                    end
                    
                    
                    
                    %ECG
                    if LPF % filter bandstopfiltered data with lowpassfilter to avoid aliasing
                        ECGDataFiltered(:,1) = lpfexg1ch1a.filterData(ECGDataFiltered(:,1));
                        ECGDataFiltered(:,2) = lpfexg1ch2a.filterData(ECGDataFiltered(:,2));
                         ECGDataFiltered(:,3) = lpfexg2ch1b.filterData(ECGDataFiltered(:,3));
                         ECGDataFiltered(:,4) = lpfexg2ch2b.filterData(ECGDataFiltered(:,4));
                    end
                    
%                     dlmwrite(fileName, newData, '-append', 'delimiter', '\t','precision',16); % Append the new data to the file in a tab delimited format

                    plotData_GSR = [plotData_GSR; GSRData];                            % Update the plotData buffer with the new GSR data
                    filteredplotData_GSR = [filteredplotData_GSR; GSRDataFiltered];    % Update the filteredplotData buffer with the new filtered gsr data
                    numPlotSamples = size(plotData_GSR,1);
                    numSamples = numSamples + size(newData,1); % 1 rep rows
                    timeStampNew = newData(:,1);                                   % get timestamps
                    timeStamp_GSR = [timeStamp_GSR; timeStampNew];
                    
                    
                    %ECG
                    
                    
                    plotData_ECG = [plotData_ECG; ECGData];                            % Update the plotData buffer with the new GSR data
                    filteredplotData_ECG = [filteredplotData_ECG; ECGDataFiltered];    % Update the filteredplotData buffer with the new filtered gsr data
                    numPlotSamples_ECG = size(plotData_ECG,1);
                    numSamples_ECG = numSamples_ECG + size(newData_ECG,1); % 1 rep rows
                    timeStampNew_ECG = newData_ECG(:,1);                                   % get timestamps
                    timeStamp_ECG = [timeStamp_ECG; timeStampNew_ECG];
                    
                    
                    
                    if (numSamples > NO_SAMPLES_IN_PLOT)
                        plotData_GSR = plotData_GSR(numPlotSamples-NO_SAMPLES_IN_PLOT+1:end,:);
                        filteredplotData_GSR = filteredplotData_GSR(numPlotSamples-NO_SAMPLES_IN_PLOT+1:end,:);
                        
                    end
                    
                    if(numSamples_ECG > NO_SAMPLES_IN_PLOT)
                         plotData_ECG = plotData_ECG(numPlotSamples_ECG-NO_SAMPLES_IN_PLOT+1:end,:);
                        filteredplotData_ECG = filteredplotData_ECG(numPlotSamples_ECG-NO_SAMPLES_IN_PLOT+1:end,:);
                    end
                    
                    sampleNumber = max(numSamples-NO_SAMPLES_IN_PLOT+1,1):numSamples;
                    sampleNumber_ECG = max(numSamples_ECG-NO_SAMPLES_IN_PLOT+1,1):numSamples_ECG;
                    
                    signalIndex = chIndex(1);
                    axes(handles.axes1);
                     
                    plot(sampleNumber,filteredplotData_GSR(:,1));              % Plot the filtered gsr for 
                    
                    xlim([sampleNumber(1) sampleNumber(end)]);
                     
                    %ECG
                    signalIndex_ECG1 = chIndex_ECG(1);
                    signalIndex_ECG2 = chIndex_ECG(2);
                    axes(handles.axes2);
                    m=0.5*(filteredplotData_ECG(:,1)+filteredplotData_ECG(:,2));
                    plot(sampleNumber_ECG,m); 
                    
                    xlim([sampleNumber_ECG(1) sampleNumber_ECG(end)]);
                                
                end

                elapsedTime = elapsedTime + toc;                           % Update elapsedTime with the time that elapsed since starting the timer
                tic;                                                       % Start timer           

            end  

            elapsedTime = elapsedTime + toc;                               % Update elapsedTime with the time that elapsed since starting the timer
            fprintf('The percentage of received packets: %d \n',shimmer_GSR.getpercentageofpacketsreceived(timeStamp_GSR)); % Detect loss packets
            shimmer_GSR.stop;                                                  % Stop data streaming                                                    
            shimmer_ECG.stop;  
        end 
     shimmer_GSR.disconnect; 
      shimmer_ECG.disconnect; 
     file_GSR=filteredplotData_GSR(:,1);
     
     
     
     file_ecg=m.';
     
    end
    
    value_GSR=file_GSR.';
    value_ECG=file_ecg;
    norm_gsr=normalize(value_GSR, 'range');
    data(1,:) = norm_gsr;
    
    norm_ecg=normalize(value_ECG, 'range');
    data(2,:) = norm_ecg;
    GSRdata=file_GSR;
    ECGdata=file_ecg;
    save('GSRdata.mat','GSRdata') ; 
    save('ECGdata.mat','ECGdata') ; 
    [~,signalLength] = size(data);

    fb = cwtfilterbank('SignalLength',signalLength);
    r = size(data,1);
    
   for ii = 1:r
        cfs = abs(fb.wt(data(ii,:)));
        im = ind2rgb(im2uint8(rescale(cfs)),jet(128));

        folder = 'C:\MATLAB\R2018a\bin\Shimmer Matlab Instrument Driver v2.8';
        imFileName = strcat('Scalo',num2str(ii),'.png');
        imwrite(imresize(im,[227 227]),fullfile(folder,imFileName));
   end

GSR_image = imread('Scalo1.png');
ECG_image = imread('Scalo2.png');







load CNN.mat       %GSR
[class, score] = classify(classifier,GSR_image);
gsr_score=score;


load ECG_CNN.mat    %ECG
[class, score] = classify(classifier,ECG_image);
ecg_score=score;

for n=1:7
    SCORE_NEW(n)=0.5*(gsr_score(n)+ecg_score(n));
end
assignin('base','score',SCORE_NEW)
axes(handles.axes3);
a=double(SCORE_NEW);
pie(a,{'Anger','Disgust','Fear','Happy','Neutral','Sad','Surprise'})

% pause(15)
% set(handles.axes1,'xtick',[],'ytick',[])
% cla(handles.axes1)
% 
% set(handles.axes2,'xtick',[],'ytick',[])
% cla(handles.axes2)
% 
% cla(handles.axes3)




a1 ='https://ec-device-56629.firebaseio.com/';
id1='ECG'; % assigning input id
json='.json';
%concatenating the url
url1=strcat(a1,id1); 
Firebase_Url1=strcat(url1,json);
% current date 
e1 = today('datetime'); 
%assigning the emotion values to struct data
data1=struct;
data1.signal=file_ecg(:,1:900);
data1.date=e1; %current date
options1 = weboptions('MediaType','application/json'); %defining data as .json object
response1=webwrite(Firebase_Url1,data1,options1);  

 % sending gsr signals to the firebase
a2 ='https://ec-device-56629.firebaseio.com/';
id2='GSR'; % assigning input id
json='.json';
%concatenating the url
url2=strcat(a2,id2); 
Firebase_Url2=strcat(url2,json);
% current date 
e2= today('datetime'); 
%assigning the emotion values to struct data
data2=struct;
data2.signal=file_GSR(1:900,:);
data2.date=e2; %current date
options2= weboptions('MediaType','application/json'); %defining data as .json object
response2=webwrite(Firebase_Url2,data2,options2);  
% 
% 
% 
% 
% 

p_gender=getappdata(0,'gender');
p_age=getappdata(0,'age');
p_name=getappdata(0,'name');
a='https://ec-device-56629.firebaseio.com/';
id='expression'; % assigning input id
json='.json';
%concatenating the url
url=strcat(a,id); 
Firebase_Url=strcat(url,json);
% current date 
e = today('datetime'); 
% n='Aqsa';
d='Fever';
ob='20 Aug 1997';
%assigning the emotion values to struct data
data=struct;
data.anger=SCORE_NEW(1)*100;
data.disgust=SCORE_NEW(2)*100;
data.fear=SCORE_NEW(3)*100;
data.happy=SCORE_NEW(4)*100;
data.neutral=SCORE_NEW(5)*100;
data.sad=SCORE_NEW(6)*100;
data.surprise=SCORE_NEW(7)*100;

data.date=e; %current date
data.name=p_name;
data.gender=p_gender;
data.age=p_age;


options = weboptions('MediaType','application/json'); %defining data as .json object
response=webwrite(Firebase_Url,data,options);  

% pause(100)
% cla(handles.axes3)
% pause(300)
% set(handles.axes1,'xtick',[],'ytick',[])
% cla(handles.axes1)
% 
% set(handles.axes2,'xtick',[],'ytick',[])
% cla(handles.axes2)
% % 
% % cla(handles.axes3)
% % 
% pushbutton1_Callback(@pushbutton1_Callback,eventdata, handles);


% c = categorical({'Anger','Disgust','Fear','Happy','Neutral','Sad','Surprise'});

function nametext_Callback(hObject, eventdata, handles)
% hObject    handle to nametext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nametext as text
%        str2double(get(hObject,'String')) returns contents of nametext as a double
p_name=get(handles.nametext,'String');
setappdata(0,'name',p_name);

% --- Executes during object creation, after setting all properties.
function nametext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nametext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function agetext_Callback(hObject, eventdata, handles)
% hObject    handle to agetext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of agetext as text
%        str2double(get(hObject,'String')) returns contents of agetext as a double
p_age=get(handles.agetext,'String');
setappdata(0,'age',p_age);

% --- Executes during object creation, after setting all properties.
function agetext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to agetext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gendertext_Callback(hObject, eventdata, handles)
% hObject    handle to gendertext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gendertext as text
%        str2double(get(hObject,'String')) returns contents of gendertext as a double
p_gender=get(handles.gendertext,'String');
setappdata(0,'gender',p_gender);

% --- Executes during object creation, after setting all properties.
function gendertext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gendertext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
