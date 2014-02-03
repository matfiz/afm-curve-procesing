function varargout = cps_curve_parameters(varargin)
% CPS_CURVE_PARAMETERS MATLAB code for cps_curve_parameters.fig
%      CPS_CURVE_PARAMETERS, by itself, creates a new CPS_CURVE_PARAMETERS or raises the existing
%      singleton*.
%
%      H = CPS_CURVE_PARAMETERS returns the handle to a new CPS_CURVE_PARAMETERS or the handle to
%      the existing singleton*.
%
%      CPS_CURVE_PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS_CURVE_PARAMETERS.M with the given input arguments.
%
%      CPS_CURVE_PARAMETERS('Property','Value',...) creates a new CPS_CURVE_PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_curve_parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_curve_parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps_curve_parameters

% Last Modified by GUIDE v2.5 03-Feb-2014 12:59:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_curve_parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_curve_parameters_OutputFcn, ...
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


% --- Executes just before cps_curve_parameters is made visible.
function cps_curve_parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps_curve_parameters (see VARARGIN)

% Choose default command line output for cps_curve_parameters
handles.output = hObject;

%remeber the main window handles for later
handles.cps = [];

cpsInput = find(strcmp(varargin, 'cps'));
if ~isempty(cpsInput)
   handles.cps = varargin{cpsInput+1};
end

% Publish the function refreshParams
handles.refreshParams = @refreshParams;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cps_curve_parameters wait for user response (see UIRESUME)
% uiwait(handles.cps_curve_parameters);

function refreshParams(hObject, current_curve)
    handles = guidata(hObject);
    set(handles.f_spring_constant,'String',current_curve.springConstant);
    set(handles.f_sensitivity,'String',current_curve.sensitivity);
    if current_curve.closedLoop == true
        set(handles.f_closed_loop,'String','On');
        set(handles.f_closed_loop,'Enable','On');
    else
        set(handles.f_closed_loop,'String','Off');
        set(handles.f_closed_loop,'Enable','Off');
    end
    set(handles.f_extend_time,'String',current_curve.extendTime);
    set(handles.f_extend_length,'String',current_curve.extendLength);
    set(handles.f_pause_time,'String',current_curve.extendPauseTime);
    set(handles.f_pause_length,'String',current_curve.pauseLength);
    set(handles.f_retract_time,'String',current_curve.retractTime);
    set(handles.f_retract_length,'String',current_curve.retractLength);
    set(handles.f_mode,'String',current_curve.mode);


% --- Outputs from this function are returned to the command line.
function varargout = cps_curve_parameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function f_spring_constant_Callback(hObject, eventdata, handles)
% hObject    handle to f_spring_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_spring_constant as text
%        str2double(get(hObject,'String')) returns contents of f_spring_constant as a double


% --- Executes during object creation, after setting all properties.
function f_spring_constant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_spring_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to f_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of f_sensitivity as a double


% --- Executes during object creation, after setting all properties.
function f_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in f_closed_loop.
function f_closed_loop_Callback(hObject, eventdata, handles)
% hObject    handle to f_closed_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f_closed_loop


% --- Executes when user attempts to close cps_curve_parameters.
function cps_curve_parameters_CloseRequestFcn(hObject, eventdata, handles)
% the object can be deleted only from CPS window
