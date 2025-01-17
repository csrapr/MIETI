
function varargout = pds_1(varargin)
% PDS_1 MATLAB code for pds_1.fig
%      PDS_1, by itself, creates a new PDS_1 or raises the existing
%      singleton*.
%
%      H = PDS_1 returns the handle to a new PDS_1 or the handle to
%      the existing singleton*.
%
%      PDS_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PDS_1.M with the given input arguments.
%
%      PDS_1('Property','Value',...) creates a new PDS_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pds_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pds_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pds_1

% Last Modified by GUIDE v2.5 30-Jun-2014 14:00:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pds_1_OpeningFcn, ...
                   'gui_OutputFcn',  @pds_1_OutputFcn, ...
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


% --- Executes just before pds_1 is made visible.
function pds_1_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pds_1 (see VARARGIN)
global soundx;
global sound_noise;
global noise;
global clean;
global aux;
global clean_r;
% Choose default command line output for pds_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pds_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pds_1_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in guardar.
function guardar_Callback(hObject, ~, handles)
% hObject    handle to guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fs = str2num(get(handles.fs,'string'));
disp(fs)
wavwrite(soundx,fs,8,'C:\Users\NUNO\Documents\pds-trabalho\original_sound.wav');


function fs_Callback(hObject, ~, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs as text
%        str2double(get(hObject,'String')) returns contents of fs as a double
fs=str2double(get(hObject,'String'));
handles.metricdata.fs = fs;
guidata(hObject,handles)


function segundos_Callback(hObject, eventdata, handles)
% hObject    handle to segundos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segundos as text
%        str2double(get(hObject,'String')) returns contents of segundos as a double
seconds=str2double(get(hObject,'String'));
handles.metricdata.seconds = seconds;
guidata(hObject,handles)

% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = str2num(get(handles.fs,'string'));
disp(fs)
sec =str2num(get(handles.segundos,'string'));
disp(sec)
global soundx;
soundx = wavrecord(sec*fs,fs);
sound(soundx);
guidata(hObject,handles)

% --- Executes on button press in Grafico_record.
function Grafico_record_Callback(hObject, ~, handles)
% hObject    handle to Grafico_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global soundx;
axes(handles.Original_record);
plot(soundx);
 

% --- Executes on button press in add_noise.
function add_noise_Callback(hObject, ~, handles)
% hObject    handle to add_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global soundx;
global sound_noise;
global aux;
sound_noise = awgn(soundx,60);
aux = 1;
sound(sound_noise);
axes(handles.added_noise);
plot(sound_noise);
% Hint: get(hObject,'Value') returns toggle state of add_noise



function janela_Callback(hObject, eventdata, handles)
% hObject    handle to janela (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of janela as text
%        str2double(get(hObject,'String')) returns contents of janela as a double
global soundx;
wlen=str2double(get(hObject,'String'));
if(wlen > (length(soundx)/2))
    errordlg('A janela tem de ser menor que metade do tamanho da amostra','Error');
else
handles.metricdata.janela = wlen;
guidata(hObject,handles)
end

function alfa_Callback(hObject, eventdata, handles)
% hObject    handle to alfa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alfa as text
%        str2double(get(hObject,'String')) returns contents of alfa as a double
threshold=str2double(get(hObject,'String'));
if(threshold > 1)
    errordlg('O alfa tem de ser menor que 1','error');
else    
handles.metricdata.threshold = threshold;
guidata(hObject,handles)
end

% --- Executes on button press in select_amostra_ruido.
function select_amostra_ruido_Callback(hObject, eventdata, handles)
% hObject    handle to select_amostra_ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_amostra_ruido
select=get(hObject,'value');
handles.metricadata.select = select;
guidata(hObject,handles)

% --- Executes on button press in silence_elimination.
function silence_elimination_Callback(hObject, eventdata, handles)
% hObject    handle to silence_elimination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global noise;
global clean;
global soundx;
global sound_noise;
global clean_r;
SNR = 0;
SNR_r = 0;

wlen = str2num(get(handles.janela,'string'));
disp(wlen)
threshold =str2num(get(handles.alfa,'string'));
disp(threshold)
select = get(handles.select_amostra_ruido,'value');

if(select == 0)
    [noise, clean, SNR] = noise_elimination(soundx, wlen,threshold);
    axes(handles.ruido);
    plot(noise);
    axes(handles.voz);
    plot(clean);
    sound(clean);
    set(handles.snr,'string',num2str(SNR));
end

if(select == 1)
    [noise_r, clean_r, SNR_r] = noise_elimination(sound_noise, wlen,threshold);
    axes(handles.ruido_added_noise);
    plot(noise_r);
    axes(handles.voz_added_noise);
    plot(clean_r);
    sound(clean_r);
    set(handles.snr_R,'string',num2str(SNR_r));
end



function snr_Callback(hObject, eventdata, handles)
% hObject    handle to snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snr as text
%        str2double(get(hObject,'String')) returns contents of snr as a double


% --- Executes during object creation, after setting all properties.
function snr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function snr_R_Callback(hObject, eventdata, handles)
% hObject    handle to snr_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snr_R as text
%        str2double(get(hObject,'String')) returns contents of snr_R as a double


% --- Executes during object creation, after setting all properties.
function snr_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snr_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global clean;
global soundx;
global sound_noise;
global clean_r;
s =get(hObject,'value'); 

switch s
    case(1)
        sound(soundx);  
    case(2)
        sound(sound_noise);
    case(3)
        sound(clean);
    case(4)
        sound(clean_r);
end


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
