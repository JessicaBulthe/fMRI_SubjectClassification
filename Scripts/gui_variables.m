function varargout = gui_variables(varargin)
% GUI_VARIABLES MATLAB code for gui_variables.fig
%      GUI_VARIABLES, by itself, creates a new GUI_VARIABLES or raises the existing
%      singleton*.
%
%      H = GUI_VARIABLES returns the handle to a new GUI_VARIABLES or the handle to
%      the existing singleton*.
%
%      GUI_VARIABLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VARIABLES.M with the given input arguments.
%
%      GUI_VARIABLES('Property','Value',...) creates a new GUI_VARIABLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_variables_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_variables_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_variables

% Last Modified by GUIDE v2.5 08-Apr-2016 10:39:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_variables_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_variables_OutputFcn, ...
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


% --- Executes just before gui_variables is made visible.
function gui_variables_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_variables (see VARARGIN)

% Choose default command line output for gui_variables
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_variables wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_variables_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle_rois = get(handles.rois_input);
ROIs = str2num(handle_rois.String);
handle_sbjgr1 = get(handles.subjgr1_input);
SubjectGroup1 = str2num(handle_sbjgr1.String); 
handle_sbjgr2 = get(handles.sbjgr2_input);
SubjectGroup2 = str2num(handle_sbjgr2.String); 
handle_nperm = get(handles.nperm_edit);
nperm = str2num(handle_nperm.String); 

handle_datatype = get(handles.functionaldata_button);
if handle_datatype.Value == 1 
    datatype = 'functional'; 
else
    datatype = 'anatomical'; 
end

handle_permutation = get(handles.yes_button); 
if handle_permutation.Value == 1
    do_permutation = 'yes'; 
else
    do_permutation = 'no'; 
end

handle_subjectconf = get(handles.no_subjectconf);
if handle_subjectconf.Value == 1
    do_subjectconfusion = 'no';
else
    do_subjectconfusion = 'yes';
end

handle_generalization = get(handles.generalization_no);
if handle_generalization.Value == 1
    do_generalization = 'no'; 
    save('temp_vars.mat', 'ROIs', 'SubjectGroup1', 'SubjectGroup2', 'nperm', 'datatype', 'do_permutation', 'do_subjectconfusion', 'do_generalization'); 
else
    do_generalization = 'yes';
    handle_sbjgr3 = get(handles.sbjgr3_input);
    SubjectGroup3 = str2num(handle_sbjgr3.String); 
    save('temp_vars.mat', 'ROIs', 'SubjectGroup1', 'SubjectGroup2', 'SubjectGroup3', 'nperm', 'datatype', 'do_permutation', 'do_subjectconfusion', 'do_generalization'); 

end

delete(handles.figure1); 

function nrep_input_Callback(hObject, eventdata, handles)
% hObject    handle to nrep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nrep_input as text
%        str2double(get(hObject,'String')) returns contents of nrep_input as a double


% --- Executes during object creation, after setting all properties.
function nrep_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nrep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nperm_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nperm_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nperm_edit as text
%        str2double(get(hObject,'String')) returns contents of nperm_edit as a double


% --- Executes during object creation, after setting all properties.
function nperm_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nperm_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function proptraining_edit_Callback(hObject, eventdata, handles)
% hObject    handle to proptraining_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of proptraining_edit as text
%        str2double(get(hObject,'String')) returns contents of proptraining_edit as a double


% --- Executes during object creation, after setting all properties.
function proptraining_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proptraining_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rois_input_Callback(hObject, eventdata, handles)
% hObject    handle to rois_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rois_input as text
%        str2double(get(hObject,'String')) returns contents of rois_input as a double


% --- Executes during object creation, after setting all properties.
function rois_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rois_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subjgr1_input_Callback(hObject, eventdata, handles)
% hObject    handle to subjgr1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjgr1_input as text
%        str2double(get(hObject,'String')) returns contents of subjgr1_input as a double


% --- Executes during object creation, after setting all properties.
function subjgr1_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjgr1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sbjgr2_input_Callback(hObject, eventdata, handles)
% hObject    handle to sbjgr2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sbjgr2_input as text
%        str2double(get(hObject,'String')) returns contents of sbjgr2_input as a double


% --- Executes during object creation, after setting all properties.
function sbjgr2_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sbjgr2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in no_subjectconf.
function no_subjectconf_Callback(hObject, eventdata, handles)
% hObject    handle to no_subjectconf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no_subjectconf


% --- Executes on button press in yes_subjectconf.
function yes_subjectconf_Callback(hObject, eventdata, handles)
% hObject    handle to yes_subjectconf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of yes_subjectconf



function sbjgr3_input_Callback(hObject, eventdata, handles)
% hObject    handle to sbjgr3_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sbjgr3_input as text
%        str2double(get(hObject,'String')) returns contents of sbjgr3_input as a double


% --- Executes during object creation, after setting all properties.
function sbjgr3_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sbjgr3_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
