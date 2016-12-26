function varargout = gui_dirs(varargin)
% GUI_DIRS MATLAB code for gui_dirs.fig
%      GUI_DIRS, by itself, creates a new GUI_DIRS or raises the existing
%      singleton*.
%
%      H = GUI_DIRS returns the handle to a new GUI_DIRS or the handle to
%      the existing singleton*.
%
%      GUI_DIRS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DIRS.M with the given input arguments.
%
%      GUI_DIRS('Property','Value',...) creates a new GUI_DIRS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_dirs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_dirs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_dirs

% Last Modified by GUIDE v2.5 25-Mar-2016 11:21:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_dirs_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_dirs_OutputFcn, ...
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

% --- Executes just before gui_dirs is made visible.
function gui_dirs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_dirs (see VARARGIN)

% Choose default command line output for gui_dirs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_dirs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_dirs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in done_button.
function done_button_Callback(hObject, eventdata, handles)
% hObject    handle to done_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1); 

% --- Executes on button press in script_browse.
function script_browse_Callback(hObject, eventdata, handles)
% hObject    handle to script_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('temp_dirs.mat'); 
Dirs.Scripts = [uigetdir(cd, 'Select Scripts Folder: ') filesep]; 
save('temp_dirs.mat', 'Dirs'); 

% --- Executes on button press in result_browse.
function result_browse_Callback(hObject, eventdata, handles)
% hObject    handle to result_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('temp_dirs.mat'); 
Dirs.Results = [uigetdir(cd, 'Select Results Folder: ') filesep]; 
save('temp_dirs.mat', 'Dirs');

% --- Executes on button press in data_browse.
function data_browse_Callback(hObject, eventdata, handles)
% hObject    handle to data_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('temp_dirs.mat'); 
Dirs.Data = [uigetdir(cd, 'Select Data Folder: ') filesep]; 
save('temp_dirs.mat', 'Dirs'); 

% % --- Executes on button press in subdata_browse.
% function subdata_browse_Callback(hObject, eventdata, handles)
% % hObject    handle to subdata_browse (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% load('temp_dirs.mat'); 
% Dirs.SubData = [uigetdir(cd, 'Select Sub-data Folder for one subject: ') filesep]; 
% save('temp_dirs.mat', 'Dirs'); 

% --- Executes on button press in roi_browse.
function roi_browse_Callback(hObject, eventdata, handles)
% hObject    handle to roi_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('temp_dirs.mat'); 
Dirs.ROI = [uigetdir(cd, 'Select folder with orginal masks: ') filesep];
save('temp_dirs.mat', 'Dirs'); 

% --- Executes on button press in excelfile_browse.
function excelfile_browse_Callback(hObject, eventdata, handles)
% hObject    handle to excelfile_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('temp_dirs.mat'); 
[Excelfile, Excelpath, ~] = uigetfile({'*xls', '*xlsx'});
Dirs.ExcelDir = [Excelpath Excelfile];
save('temp_dirs.mat', 'Dirs'); 

% --- Executes on button press in libsvm_browse.
function libsvm_browse_Callback(hObject, eventdata, handles)
% hObject    handle to libsvm_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('temp_dirs.mat'); 
Dirs.libsvm = [uigetdir(cd, 'Select the libsvm folder: ') filesep]; 
save('temp_dirs.mat', 'Dirs'); 
