function varargout = cps_stress_relaxation(varargin)
% CPS_STRESS_RELAXATION MATLAB code for cps_stress_relaxation.fig
%      CPS_STRESS_RELAXATION, by itself, creates a new CPS_STRESS_RELAXATION or raises the existing
%      singleton*.
%
%      H = CPS_STRESS_RELAXATION returns the handle to a new CPS_STRESS_RELAXATION or the handle to
%      the existing singleton*.
%
%      CPS_STRESS_RELAXATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS_STRESS_RELAXATION.M with the given input arguments.
%
%      CPS_STRESS_RELAXATION('Property','Value',...) creates a new CPS_STRESS_RELAXATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_stress_relaxation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_stress_relaxation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps_stress_relaxation

% Last Modified by GUIDE v2.5 10-Mar-2014 01:20:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_stress_relaxation_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_stress_relaxation_OutputFcn, ...
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


% --- Executes just before cps_stress_relaxation is made visible.
function cps_stress_relaxation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps_stress_relaxation (see VARARGIN)


%remeber the main window handles for later
handles.cps = [];    
cpsInput = find(strcmp(varargin, 'cps'));
if ~isempty(cpsInput)
   handles.cps = varargin{cpsInput+1};
   cps_handles = guidata(handles.cps);
end
% Choose default command line output for cps_stress_relaxation
handles.output = hObject;

%initially, hide axes
set(handles.axes_force_time,'Visible','Off');



% Update handles structure
guidata(hObject, handles);
handles = guidata(hObject);
%try to read stress relaxation
plot_time_curve(cps,cps_handles);
cps_handles.read_stress_relaxation(cps, cps_handles.current_curve_index);
% UIWAIT makes cps_stress_relaxation wait for user response (see UIRESUME)
% uiwait(handles.cps_stress_relaxation);


% --- Outputs from this function are returned to the command line.
function varargout = cps_stress_relaxation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_relaxation_Callback(hObject, eventdata, handles)
%read
value = get(hObject,'Value');
cps = handles.cps;
cpsHandles = guidata(cps);
curve = cpsHandles.curves(cpsHandles.current_curve_index);
%process
cpsHandles.curves(cpsHandles.current_curve_index).StressRelaxationFitLength = value;
set(handles.f_relaxation_fit_range,'String',num2str(value/get(hObject,'Max')*100,'%5.0f%%'));
%[stress_fit, params] = fit_stress_relaxation_params(curve);
%cpsHandles.curves(cpsHandles.current_curve_index).dataStressRelaxation = params;
cpsHandles.current_curve = cpsHandles.curves(cpsHandles.current_curve_index);
guidata(hObject, handles);
guidata(cps, cpsHandles);
fit_stress_relaxation(hObject,cps,cpsHandles.current_curve_index);
%plot_time_curve(cps,cpsHandles);
%read_to_gui(cps,cpsHandles,cpsHandles.current_curve_index);


% --- Executes during object creation, after setting all properties.
function f_relaxation_fit_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_relaxation_fit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close cps_stress_relaxation.
function cps_stress_relaxation_CloseRequestFcn(hObject, eventdata, handles)

 
% --- Executes on button press in checkbox_relaxation.
function checkbox_relaxation_Callback(hObject, eventdata, handles)
    %read
    state = get(hObject,'Value');
    cps = handles.cps;
    cpsHandles = guidata(cps);
    curve = cpsHandles.curves(cpsHandles.current_curve_index);
    if state == 1
        curve.hasStressRelaxation = 1;
        set(handles.table_relaxation,'Visible','On');
    else
        curve.hasStressRelaxation = 0;
        set(handles.table_relaxation,'Visible','Off');
    end
    cpsHandles.curves(cpsHandles.current_curve_index) = curve;
    cpsHandles.current_curve = curve;
    guidata(hObject, handles);
    guidata(cps, cpsHandles);
    
 % --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over checkbox_relaxation.
function checkbox_relaxation_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in b_export_relaxation.
function b_export_relaxation_Callback(hObject, eventdata, handles)
% hObject    handle to b_export_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname,filterindex] = uiputfile('*.csv', 'Save relaxation to CSV');
h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
fid = fopen([pathname '/' filename],'w');
header = {'#Curve name','a0','a1','a2','tau1','tau2'};
[rows,cols]=size(header);
for i=1:rows
    fprintf(fid,'%s,',header{i,1:end-1});
    fprintf(fid,'%s\n',header{i,end});
end
for i=1:handles.no_of_curves
    %if exist('handles.curves(i).dataStressRelaxation')
        if handles.curves(i).hasStressRelaxation
           data = handles.curves(i).dataStressRelaxation;
           fprintf(fid,'%s,',handles.curves(i).name);
           fprintf(fid,'%e,%e,%e,%e,%e\n',data(1:5));
        end
    %end
end
fclose(fid);
close(h);


% --- Executes on button press in b_export_creep.
function b_export_creep_Callback(hObject, eventdata, handles)
% hObject    handle to b_export_creep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function slider_relaxation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function f_relaxation_fit_range_Callback(hObject, eventdata, handles)
% hObject    handle to f_relaxation_fit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_relaxation_fit_range as text
%        str2double(get(hObject,'String')) returns contents of f_relaxation_fit_range as a double
cps = handles.cps;
cpsHandles = guidata(cps);
curve = cpsHandles.curves(cpsHandles.current_curve_index);

value_str = strrep(get(hObject,'String'), '%', '');
value = str2double(value_str);
cpsHandles.curves(cpsHandles.current_curve_index).StressRelaxationFitLength = floor(value*get(handles.slider_relaxation,'Max')/100);
set(handles.slider_relaxation,'Value',floor(value*get(handles.slider_relaxation,'Max')/100));
[stress_fit, params] = fit_stress_relaxation_params(curve);
cpsHandles.curves(cpsHandles.current_curve_index).dataStressRelaxation = params;
cpsHandles.current_curve = cpsHandles.curves(cpsHandles.current_curve_index);
guidata(hObject, handles);
guidata(cps, cpsHandles);
%read_to_gui(hObject,handles,handles.current_curve_index);
plot_time_curve(cps,cpsHandles);