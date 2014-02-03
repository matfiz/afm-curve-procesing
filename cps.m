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

% Last Modified by GUIDE v2.5 10-Jun-2013 15:37:11

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

% set(hObject,'toolbar','figure');

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
set(handles.pause_relaxation,'Visible','off');

% Define a context menu; it is not attached to anything
hcmenu = uicontextmenu;
% Define callbacks for context menu items that change linestyle
hcb1 = ['saveas(gca,''force-distance'',''jpg'')'];
%hcb2 = ['saveas(gca,''force-time'',''pdf'')'];
hcb2 = ['printpreview(gcf)'];
hcb3 = ['plotedit(gcf, ''plotedittoolbar'', ''toggle'')'];
% Define the context menu items and install their callbacks
item1 = uimenu(hcmenu, 'Label', 'Save as fig', 'Callback', hcb1);
item2 = uimenu(hcmenu, 'Label', 'Print preview', 'Callback', hcb2);
item3 = uimenu(hcmenu, 'Label', 'Edit plot', 'Callback', hcb3);
% Locate line objects
set(handles.axes_force_distance,'uicontextmenu',hcmenu);
set(handles.axes_force_time,'uicontextmenu',hcmenu);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cps wait for user response (see UIRESUME)
% uiwait(handles.cps);

function save_to_fig(axes)
 F=getframe(axes); %select axes in GUI
    figure(); %new figure
    image(F.cdata); %show selected axes in new figure
    saveas(gcf, 'force-distance', 'fig'); %save figure
    close(gcf); %and close it


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
    handles.no_of_curves = 1;
 close(h);
 %stress relaxation

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
set(handles.curve_parameters,'Visible','Off');
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
h = waitbar(0,'Please wait! Loading ...','WindowStyle','modal') ;
load([pathname filename]);
handles.curves = krzywe;
[no_of_curves len] = size(krzywe);
%curve_info = [no_of_curves 'curves loaded'];
%set(handles.curve_info,'String',curve_info);
%set(handles.curve_info,'Visible','On');
handles.no_of_curves = numel(krzywe);
handles.current_curve_index = 1;
handles.current_curve = handles.curves(handles.current_curve_index);
handles.current_steps = handles.current_curve.dataSteps;
read_to_gui(hObject,handles,1);
set(handles.curve_parameters,'Visible','On');
set(handles.axes_force_time,'Visible','On');
set(handles.axes_force_distance,'Visible','On');
close(h);
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


% --------------------------------------------------------------------
function load_test_data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to load_test_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curve_info = ['Single curve loaded: jpk.txt'];
set(handles.curve_info,'String',curve_info);
set(handles.curve_info,'Visible','On');
handles.current_curve_index = 1;
handles.curves(1) = parse_curve('./','jpk.txt');
handles.current_curve = handles.curves(handles.current_curve_index);
read_to_gui(hObject,handles,1);
set(handles.curve_parameters,'Visible','On');
set(handles.axes_force_time,'Visible','On');
set(handles.axes_force_distance,'Visible','On');
handles.no_of_curves = 1;
guidata(hObject, handles);


% --- Executes on button press in checkbox_relaxation.
function checkbox_relaxation_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_relaxation
state = get(hObject,'Value');

if state == 1
    handles.curves(handles.current_curve_index).hasStressRelaxation = true;
    set(handles.table_relaxation,'Visible','On');
else
    handles.curves(handles.current_curve_index).hasStressRelaxation = false;
    set(handles.table_relaxation,'Visible','Off');
end
disp(handles.curves(handles.current_curve_index).hasStressRelaxation);
guidata(hObject, handles);
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


% --- Executes on slider movement.
function slider_relaxation_Callback(hObject, eventdata, handles)
% hObject    handle to slider_relaxation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject,'Value');
handles.curves(handles.current_curve_index).StressRelaxationFitLength = value;
set(handles.f_relaxation_fit_range,'String',num2str(value/get(hObject,'Max')*100,'%5.0f%%'));
[stress_fit, params] = fit_stress_relaxation_params(handles.curves(handles.current_curve_index));
handles.curves(handles.current_curve_index).dataStressRelaxation = params;
guidata(hObject, handles);
read_to_gui(hObject,handles,handles.current_curve_index);

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

value_str = strrep(get(hObject,'String'), '%', '');
value = str2double(value_str);
handles.curves(handles.current_curve_index).StressRelaxationFitLength = floor(value*get(handles.slider_relaxation,'Max')/100);
set(handles.slider_relaxation,'Value',floor(value*get(handles.slider_relaxation,'Max')/100));
[stress_fit, params] = fit_stress_relaxation_params(handles.curves(handles.current_curve_index));
handles.curves(handles.current_curve_index).dataStressRelaxation = params;
guidata(hObject, handles);
read_to_gui(hObject,handles,handles.current_curve_index);


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
