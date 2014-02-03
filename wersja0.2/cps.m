function varargout = cps(varargin)
% CPS MATLAB code for cps.fig
%      CPS, by itself, creates a new CPS or raises the existing
%      singleton*.
%
%      H = CPS returns the handle to a new CPS or the handle to
%      the existing singleton*.
%
%      CPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CPS.M with the given input arguments.
%
%      CPS('Property','Value',...) creates a new CPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cps

% Last Modified by GUIDE v2.5 08-Jun-2013 09:07:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cps_OpeningFcn, ...
                   'gui_OutputFcn',  @cps_OutputFcn, ...
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


% --- Executes just before cps is made visible.
function cps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cps (see VARARGIN)

% Choose default command line output for cps
handles.output = hObject;

%set variables

handles.save = 1; %is 0, if opened curves were not saved
handles.view_mode = 1;
%1 - approach&retract
%2 - approach only
%3 - retract only

handles.current_steps = []; %matrix for storing current adhesion steps
%give names to columns
cnames = {'<html><center />&delta;z</html>','<html><center />&delta;F</html>'};
set(handles.adhesion_table,'ColumnName',cnames);
%info about last processed directory
handles.current_dir = '';

%hide elements
set(handles.previous_button,'Visible','Off');
set(handles.next_button,'Visible','Off');
set(handles.curve_list,'Visible','Off');
set(handles.curve_info,'Visible','Off');
set(handles.curve_parameters,'Visible','Off');
set(handles.axes_force_time,'Visible','Off');
set(handles.axes_force_distance,'Visible','Off');
set(handles.adhesion_panel,'Visible','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cps wait for user response (see UIRESUME)
% uiwait(handles.cps);


% --- Outputs from this function are returned to the command line.
function varargout = cps_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function CurveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CurveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadSingleCurveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSingleCurveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if  ~handles.save
    button = questdlg('Save opened curves?','File not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.curves;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end        
    if strcmp(button,'Cancel')
         return;
    end
end
[FileName1,PathName] = uigetfile('*.*','Choose curve to open');
 h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
     if (FileName1)
        curve_info = ['Single curve loaded: ' FileName1];
        set(handles.curve_info,'String',curve_info);
        set(handles.curve_info,'Visible','On');
        handles.current_curve_index = 1;
        handles.curves(1) = parse_curve(PathName,FileName1);
        handles.current_curve = handles.curves(handles.current_curve_index);
        read_to_gui(hObject,handles,1);
     end
     set(handles.curve_parameters,'Visible','On');
    set(handles.axes_force_time,'Visible','On');
    set(handles.axes_force_distance,'Visible','On');
 close(h);
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadDirectoryMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDirectoryMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  ~handles.save
    button = questdlg('File not saved','Save opened curves?','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.curves;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end        
    if strcmp(button,'Cancel')
         return;
    end
end
PathName = uigetdir(handles.current_dir,'Choose dir to open');
handles.current_dir = PathName;
%read all txt files
files = dir(fullfile(PathName,'*.txt'));
handles.no_of_curves = size(files);
handles.no_of_curves = handles.no_of_curves(1);
 h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
  for i=1:handles.no_of_curves
      disp(['\' files(i).name]);
      handles.curves(i) = parse_curve(PathName,['\' files(i).name]);
      waitbar(i/handles.no_of_curves);
      file_names{i} = files(i).name;
  end
 handles.current_curve_index = 1;
 handles.current_curve = handles.curves(1);
 read_to_gui(hObject,handles,1);
 handles.save = 0;
 set(handles.curve_list,'String', file_names);
 set(handles.previous_button,'Visible','On');
set(handles.next_button,'Visible','On');
set(handles.curve_list,'Visible','On');
set(handles.curve_parameters,'Visible','On');
set(handles.axes_force_time,'Visible','On');
set(handles.axes_force_distance,'Visible','On'); 
 close(h);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintCurveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PrintCurveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in curve_list.
function curve_list_Callback(hObject, eventdata, handles)
% hObject    handle to curve_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns curve_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from curve_list
handles.current_curve_index = get(hObject,'Value');
handles.current_curve = handles.curves(handles.current_curve_index);
set(handles.curve_list,'Value',handles.current_curve_index);
handles.current_steps = [];
read_to_gui(hObject,handles,handles.current_curve_index);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function curve_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curve_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previous_button.
function previous_button_Callback(hObject, eventdata, handles)
% hObject    handle to previous_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.current_curve_index > 1
     handles.current_curve_index = handles.current_curve_index-1;
     handles.current_curve = handles.curves(handles.current_curve_index);
     set(handles.curve_list,'Value',handles.current_curve_index);
     handles.current_steps = [];
     read_to_gui(hObject,handles,handles.current_curve_index);
end
guidata(hObject, handles);


% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.current_curve_index < handles.no_of_curves
     handles.current_curve_index = handles.current_curve_index+1;
     handles.current_curve = handles.curves(handles.current_curve_index);
     set(handles.curve_list,'Value',handles.current_curve_index);
     handles.current_steps = [];
     read_to_gui(hObject,handles,handles.current_curve_index);
end
guidata(hObject, handles);


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



function f_closed_loop_Callback(hObject, eventdata, handles)
% hObject    handle to f_closed_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_closed_loop as text
%        str2double(get(hObject,'String')) returns contents of f_closed_loop as a double


% --- Executes during object creation, after setting all properties.
function f_closed_loop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_closed_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_extend_time_Callback(hObject, eventdata, handles)
% hObject    handle to f_extend_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_extend_time as text
%        str2double(get(hObject,'String')) returns contents of f_extend_time as a double


% --- Executes during object creation, after setting all properties.
function f_extend_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_extend_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_extend_length_Callback(hObject, eventdata, handles)
% hObject    handle to f_extend_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_extend_length as text
%        str2double(get(hObject,'String')) returns contents of f_extend_length as a double


% --- Executes during object creation, after setting all properties.
function f_extend_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_extend_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_retract_time_Callback(hObject, eventdata, handles)
% hObject    handle to f_retract_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_retract_time as text
%        str2double(get(hObject,'String')) returns contents of f_retract_time as a double


% --- Executes during object creation, after setting all properties.
function f_retract_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_retract_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_retract_length_Callback(hObject, eventdata, handles)
% hObject    handle to f_retract_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_retract_length as text
%        str2double(get(hObject,'String')) returns contents of f_retract_length as a double


% --- Executes during object creation, after setting all properties.
function f_retract_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_retract_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_pause_length_Callback(hObject, eventdata, handles)
% hObject    handle to f_pause_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_pause_length as text
%        str2double(get(hObject,'String')) returns contents of f_pause_length as a double


% --- Executes during object creation, after setting all properties.
function f_pause_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_pause_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_pause_time_Callback(hObject, eventdata, handles)
% hObject    handle to f_pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_pause_time as text
%        str2double(get(hObject,'String')) returns contents of f_pause_time as a double


% --- Executes during object creation, after setting all properties.
function f_pause_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_pause_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_mode_Callback(hObject, eventdata, handles)
% hObject    handle to f_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_mode as text
%        str2double(get(hObject,'String')) returns contents of f_mode as a double


% --- Executes during object creation, after setting all properties.
function f_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function toggle_adhesion_OnCallback(hObject, eventdata, handles)
% hObject    handle to toggle_adhesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.adhesion_panel,'Visible','on');


% --------------------------------------------------------------------
function toggle_adhesion_OffCallback(hObject, eventdata, handles)
% hObject    handle to toggle_adhesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.adhesion_panel,'Visible','off');


% --------------------------------------------------------------------
function toolbar_toggle_curve_parameters_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_toggle_curve_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.curve_parameters,'Visible','on');


% --------------------------------------------------------------------
function toolbar_toggle_curve_parameters_OffCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_toggle_curve_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.curve_parameters,'Visible','off');


% --- Executes on button press in b_get_step.
function b_get_step_Callback(hObject, eventdata, handles)
% hObject    handle to b_get_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Loop, picking up the points.
set(handles.status_bar,'Visible','On')
set(handles.status_bar,'String','Left click on the first point of the step, right click on the second one.')
but = 1;
z1=0;
F1=0;
axes(handles.axes_force_distance);
hold on;
while but == 1
    [x,y,but] = ginputax(handles.axes_force_distance,1);
    if but == 1
        z1=x;
        F1=y;
    end
end
z2=x;
F2=y;
last_point = plot(z1,F1,'gx',z2,F2,'gx','MarkerSize',13,'LineWidth',2);
handles.last_step_plotted = last_point;
dz = abs(z1-z2);
dF = abs(F1-F2);
[wierszy,kolumn] = size(handles.current_steps);
handles.current_steps(wierszy+1,:) = [z1,F1,z2,F2,dz,dF];
set(handles.adhesion_table,'Data',handles.current_steps(:,5:6));
curve = Curve;
curve = handles.curves(handles.current_curve_index);
curve.dataSteps = handles.current_steps;
handles.curves(handles.current_curve_index) = curve;
%SetDataSteps(handles.curves(handles.current_curve_index), handles.current_steps);
set(handles.b_delete_last_step,'Enable','On');
guidata(hObject, handles);

    


% --- Executes on button press in b_delete_last_step.
function b_delete_last_step_Callback(hObject, eventdata, handles)
% hObject    handle to b_delete_last_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_force_distance);
delete(handles.last_step_plotted);
[wierszy,kolumn] = size(handles.current_steps);
steps = handles.current_steps(1:wierszy-1,:);
handles.current_steps = steps;
set(handles.adhesion_table,'Data',handles.current_steps(:,5:6));
set(handles.b_delete_last_step,'Enable','Off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function save_data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = questdlg('Save it?','The processed curves are not saved','Yes','No','Cancel','Yes');
    if strcmp(button,'Yes')
        [filename, pathname,filterindex] = uiputfile('*.mat', 'Save curves to MAT file');
        krzywe=handles.curves;
        save([pathname filename],'krzywe');
        handles.save=1;    
    end   
    if strcmp(button,'Cancel')
         return;
    end


% --------------------------------------------------------------------
function OpenSavedCurves_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OpenSavedCurves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat','Select the file with curves to load');
load([pathname filename]);
handles.curves = krzywe;
[no_of_curves len] = size(krzywe);
curve_info = [no_of_curves 'curves loaded'];
set(handles.curve_info,'String',curve_info);
set(handles.curve_info,'Visible','On');
handles.current_curve_index = 1;
handles.current_curve = handles.curves(handles.current_curve_index);
handles.current_steps = handles.current_curve.dataSteps;
read_to_gui(hObject,handles,1);
set(handles.curve_parameters,'Visible','On');
set(handles.axes_force_time,'Visible','On');
set(handles.axes_force_distance,'Visible','On');
guidata(hObject, handles);


% --- Executes on button press in export_steps_txt.
function export_steps_txt_Callback(hObject, eventdata, handles)
% hObject    handle to export_steps_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

all_step_data = [];
for i=1:handles.no_of_curves
    data_length = size(handles.curves(i).dataSteps);
    for j=1:data_length(1)
        row = [i, handles.curves(i).dataSteps(j,:)];
        all_step_data = [all_step_data; row];
    end
end
[filename, pathname,filterindex] = uiputfile('*.xls', 'Save step data to Excel');
h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
xlswrite([pathname filename],all_step_data);
close(h);

